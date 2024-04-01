import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const String _wrongCircular = 'CircularProgressIndicator';
const String _wrongLinear = 'LinearProgressIndicator';

class UseAdaptiveCircularProgressIndicator extends DartLintRule {
  const UseAdaptiveCircularProgressIndicator() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_circular_progress_indicator',
    problemMessage: 'Use AdaptiveCircularProgressIndicator instead of the build-in CircularProgressIndicator widget',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString() != _wrongCircular) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithDeterminateAdaptiveCircularProgressIndicator(),
        _ReplaceWithIndeterminateAdaptiveCircularProgressIndicator(),
      ];
}

class UseAdaptiveProgressBar extends DartLintRule {
  const UseAdaptiveProgressBar() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_progress_bar',
    problemMessage: 'Use AdaptiveProgressBar instead of the build-in LinearProgressIndicator widget',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || element.toString() != _wrongLinear) return;
      reporter.reportErrorForNode(code, node.constructorName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithDeterminateAdaptiveProgressBar(),
        _ReplaceWithIndeterminateAdaptiveProgressBar(),
      ];
}

class _ReplaceWithDeterminateAdaptiveCircularProgressIndicator extends DartFix {
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
        if (element == null || element.toString() != _wrongCircular) return;
        reporter
            .createChangeBuilder(
          message: 'Use `AdaptiveCircularProgressIndicator.determinate`',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder
              ..addReplacement(
                node.constructorName.sourceRange,
                (DartEditBuilder builder) {
                  builder.write('AdaptiveCircularProgressIndicator.determinate');
                },
              )
              ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_circular_progress_indicator.dart'));
          },
        );
      },
    );
  }
}

class _ReplaceWithIndeterminateAdaptiveCircularProgressIndicator extends DartFix {
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
      if (element == null || element.toString() != _wrongCircular) return;

      // Create a `ChangeBuilder` instance to do file operations with an action
      reporter
          .createChangeBuilder(
        message: 'Use `AdaptiveCircularProgressIndicator.indeterminate`',
        priority: 3,
      )
          .addDartFileEdit((builder) {
        // Use the `builder` to insert `static` keyword before method name
        builder
          ..addReplacement(
            node.constructorName.sourceRange,
            (DartEditBuilder builder) {
              builder.write('AdaptiveCircularProgressIndicator.indeterminate');
            },
          )
          ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_circular_progress_indicator.dart'));
      });
    });
  }
}

class _ReplaceWithDeterminateAdaptiveProgressBar extends DartFix {
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
      if (element == null || element.toString() != _wrongLinear) return;
      reporter
          .createChangeBuilder(
        message: 'Use `AdaptiveProgressBar.determinate`',
        priority: 2,
      )
          .addDartFileEdit((builder) {
        // Use the `builder` to insert `static` keyword before method name
        builder
          ..addReplacement(
            node.constructorName.sourceRange,
            (DartEditBuilder builder) {
              builder.write('AdaptiveProgressBar.determinate');
            },
          )
          ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_progress_bar.dart'));
      });
    });
  }
}

class _ReplaceWithIndeterminateAdaptiveProgressBar extends DartFix {
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
      if (element == null || element.toString() != _wrongLinear) return;
      reporter
          .createChangeBuilder(
        message: 'Use `AdaptiveProgressBar.indeterminate`',
        priority: 3,
      )
          .addDartFileEdit((builder) {
        // Use the `builder` to insert `static` keyword before method name
        builder
          ..addReplacement(
            node.constructorName.sourceRange,
            (DartEditBuilder builder) {
              builder.write('AdaptiveProgressBar.indeterminate');
            },
          )
          ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_progress_bar.dart'));
      });
    });
  }
}
