import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongNames = ['SegmentedButton', 'CupertinoSlidingSegmentedControl'];

class UseAdaptiveSegmentedMaterial extends DartLintRule {
  const UseAdaptiveSegmentedMaterial() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_segmented',
    problemMessage: 'Use AdaptiveSegmented instead of Scrollbar',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString().split('<').first != _wrongNames[0]) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveSegmented(),
      ];
}

class UseAdaptiveSegmentedCupertino extends DartLintRule {
  const UseAdaptiveSegmentedCupertino() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_segmented',
    problemMessage: 'Use AdaptiveSegmented instead of CupertinoScrollbar',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString().split('<').first != _wrongNames[1]) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveSegmented(),
      ];
}

class _ReplaceWithAdaptiveSegmented extends DartFix {
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
        if (element == null || !_wrongNames.contains(element.toString().split('<').first)) return;
        reporter
            .createChangeBuilder(
          message: 'Use `AdaptiveSegmented`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveSegmented');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_segmented.dart'));
          },
        );
      },
    );
  }
}
