import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const String _wrongName = 'Switch';

class UseAdaptiveSwitch extends DartLintRule {
  const UseAdaptiveSwitch() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_switch',
    problemMessage: 'Use AdaptiveSwitch instead of the built-in Switch widget',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString() != _wrongName) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveSwitch(),
      ];
}

class _ReplaceWithAdaptiveSwitch extends DartFix {
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
        if (element == null || element.toString() != _wrongName) return;
        reporter
            .createChangeBuilder(
          message: 'Use `AdaptiveSwitch`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveSwitch');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptivity/adaptive_switch.dart'));
          },
        );
      },
    );
  }
}
