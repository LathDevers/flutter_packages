import 'package:analyzer/error/error.dart' show AnalysisError;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongNames = ['ListTile', 'CupertinoListTile'];

class UseAdaptiveListTileMaterial extends DartLintRule {
  const UseAdaptiveListTileMaterial() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_listtile',
    problemMessage: 'Use AdaptiveListTile instead of the build-in ListTile widget',
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
      reporter.atNode(node.constructorName, code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveListTile(),
      ];
}

class UseAdaptiveListTileCupertino extends DartLintRule {
  const UseAdaptiveListTileCupertino() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_listtile',
    problemMessage: 'Use AdaptiveListTile instead of the build-in CupertinoListTile widget',
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
      reporter.atNode(node.constructorName, code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveListTile(),
      ];
}

class _ReplaceWithAdaptiveListTile extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || !_wrongNames.contains(element.toString())) return;
      reporter
          .createChangeBuilder(
        message: 'Use `AdaptiveListTile`',
        priority: 2,
      )
          .addDartFileEdit((builder) {
        builder
          ..addReplacement(
            node.constructorName.sourceRange,
            (DartEditBuilder builder) {
              builder.write('AdaptiveListTile');
            },
          )
          ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_listtile.dart'));
      });
    });
  }
}
