import 'package:analyzer/error/error.dart' show AnalysisError;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongNames = ['showDialog', 'showCupertinoDialog', 'showAdaptiveDialog', 'showAboutDialog', 'showGeneralDialog'];

class UseAdaptiveDialog extends DartLintRule {
  const UseAdaptiveDialog() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_dialog',
    problemMessage: 'Use showBIVitalDialog instead',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addExpression((node) {
      final element = node.staticType;
      if (element == null || !_wrongNames.contains(node.toString())) return;
      reporter.atNode(node, code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveDialog(),
      ];
}

class _ReplaceWithAdaptiveDialog extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addExpression(
      (node) {
        final element = node.staticType;
        if (element == null || !_wrongNames.contains(node.toString())) return;
        reporter
            .createChangeBuilder(
          message: 'Use `showBIVitalDialog`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('showBIVitalDialog');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_dialog.dart'));
          },
        );
      },
    );
  }
}
