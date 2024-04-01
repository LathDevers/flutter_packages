import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongNames = ['PopupMenuButton', 'PullDownButton'];

class UseAdaptivePullDownButtonMaterial extends DartLintRule {
  const UseAdaptivePullDownButtonMaterial() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_pulldown',
    problemMessage: 'Use AdaptivePullDownButton instead of the build-in PopupMenuButton widget',
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
        _ReplaceWithAdaptivePulldown(),
      ];
}

class UseAdaptivePullDownButtonCupertino extends DartLintRule {
  const UseAdaptivePullDownButtonCupertino() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_pulldown',
    problemMessage: 'Use AdaptivePullDownButton instead of PullDownButton',
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
        _ReplaceWithAdaptivePulldown(),
      ];
}

class _ReplaceWithAdaptivePulldown extends DartFix {
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
          message: 'Use `AdaptivePullDownButton`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptivePullDownButton');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_pulldown.dart'));
          },
        );
      },
    );
  }
}
