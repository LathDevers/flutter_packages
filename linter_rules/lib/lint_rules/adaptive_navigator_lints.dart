import 'package:analyzer/error/error.dart' show AnalysisError;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongTypes = [
  'Navigator',
];

class UseAdaptiveNavigator extends DartLintRule {
  const UseAdaptiveNavigator() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_navigator',
    problemMessage: 'Use AdaptiveNavigator',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addSimpleIdentifier((node) {
      if (!_wrongTypes.contains(node.toString())) return;
      reporter.atNode(node, code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveNavigator(),
      ];
}

class _ReplaceWithAdaptiveNavigator extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addSimpleIdentifier(
      (node) {
        if (!_wrongTypes.contains(node.toString())) return;
        reporter
            .createChangeBuilder(
          message: 'Use `AdaptiveNavigator`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveNavigator');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_navigator.dart'));
          },
        );
      },
    );
  }
}
