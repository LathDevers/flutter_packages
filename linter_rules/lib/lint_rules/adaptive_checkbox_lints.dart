import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongNames = ['Checkbox', 'CupertinoCheckbox'];

class UseAdaptiveCheckbox extends DartLintRule {
  const UseAdaptiveCheckbox() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_checkbox',
    problemMessage: 'Use AdaptiveCheckbox instead of the build-in Checkbox widget',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || !_wrongNames.contains(element.toString())) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveCheckbox(),
      ];
}

class _ReplaceWithAdaptiveCheckbox extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression(
      (node) {
        final element = node.staticType;
        if (element == null || !_wrongNames.contains(element.toString())) return;
        reporter
            .createChangeBuilder(
          message: 'Use `AdaptiveCheckbox`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveCheckbox');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_checkbox.dart'));
          },
        );
      },
    );
  }
}
