import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongNames = ['Scrollbar', 'CupertinoScrollbar'];

class UseAdaptiveScrollbarMaterial extends DartLintRule {
  const UseAdaptiveScrollbarMaterial() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_scrollbar',
    problemMessage: 'Use AdaptiveScrollbar instead of Scrollbar',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString() != _wrongNames[0]) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveScrollbar(),
      ];
}

class UseAdaptiveScrollbarCupertino extends DartLintRule {
  const UseAdaptiveScrollbarCupertino() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_scrollbar',
    problemMessage: 'Use AdaptiveScrollbar instead of CupertinoScrollbar',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString() != _wrongNames[1]) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveScrollbar(),
      ];
}

class _ReplaceWithAdaptiveScrollbar extends DartFix {
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
          message: 'Use `AdaptiveScrollbar`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveScrollbar');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_scrollbar.dart'));
          },
        );
      },
    );
  }
}
