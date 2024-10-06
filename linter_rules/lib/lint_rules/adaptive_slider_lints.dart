import 'package:analyzer/error/error.dart' show AnalysisError;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const String _wrongName = 'Slider';

class UseAdaptiveSlider extends DartLintRule {
  const UseAdaptiveSlider() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_slider',
    problemMessage: 'Use AdaptiveSlider instead of the built-in Slider widget',
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
      reporter.atNode(node.constructorName, code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveSlider(),
      ];
}

class _ReplaceWithAdaptiveSlider extends DartFix {
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
          message: 'Use `AdaptiveSlider`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveSlider');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_slider.dart'));
          },
        );
      },
    );
  }
}
