import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const String _wrongName = 'Scaffold';

class UseAdaptiveScaffold extends DartLintRule {
  const UseAdaptiveScaffold() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_scaffold',
    problemMessage: 'Use AdaptiveScaffold instead of the built-in Scaffold widget',
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
        _ReplaceWithAdaptiveScaffoldSingle(),
        _ReplaceWithAdaptiveScaffoldMultiple(),
      ];
}

class _ReplaceWithAdaptiveScaffoldSingle extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    // Callback fn that runs on every class declaration in a file
    context.registry.addInstanceCreationExpression(
      (node) {
        final element = node.staticType;
        if (element == null || element.toString() != _wrongName) return;
        reporter
            .createChangeBuilder(
          message: 'Use `AdaptiveScaffold.single`',
          priority: 3,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveScaffold.single');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_scaffold.dart'));
          },
        );
      },
    );
  }
}

class _ReplaceWithAdaptiveScaffoldMultiple extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    // Callback fn that runs on every class declaration in a file
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString() != _wrongName) return;

      // Create a `ChangeBuilder` instance to do file operations with an action
      reporter
          .createChangeBuilder(
        message: 'Use `AdaptiveScaffold.multiple`',
        priority: 2,
      )
          .addDartFileEdit((builder) {
        // Use the `builder` to insert `static` keyword before method name
        builder
          ..addReplacement(
            node.constructorName.sourceRange,
            (DartEditBuilder builder) {
              builder.write('AdaptiveScaffold.multiple');
            },
          )
          ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_scaffold.dart'));
      });
    });
  }
}
