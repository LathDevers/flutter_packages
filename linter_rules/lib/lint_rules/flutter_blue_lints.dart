import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const String _wrongName = 'platformName';

class UseDeviceName extends DartLintRule {
  UseDeviceName() : super(code: _code);

  static final LintCode _code = LintCode(
    name: 'use_devicename_instead_of_${_wrongName.toLowerCase()}',
    problemMessage: "Don't use $_wrongName, use deviceName instead",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addExpression((node) {
      if (node.toString() != _wrongName) return;
      reporter.reportErrorForNode(code, node);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithDeviceName(),
        _ReplaceWithDeviceNameNullable(),
      ];
}

class _ReplaceWithDeviceName extends DartFix {
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
        if (node.toString() != _wrongName) return;
        reporter
            .createChangeBuilder(
          message: 'Use deviceName',
          priority: 2,
        )
            .addDartFileEdit(
          (builder) {
            builder.addReplacement(
              node.sourceRange,
              (DartEditBuilder builder) {
                builder.write('deviceName');
              },
            );
          },
        );
      },
    );
  }
}

class _ReplaceWithDeviceNameNullable extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    // Callback fn that runs on every class declaration in a file
    context.registry.addExpression((node) {
      if (node.toString() != _wrongName) return;

      // Create a `ChangeBuilder` instance to do file operations with an action
      reporter
          .createChangeBuilder(
        message: 'Use deviceNameNullable',
        priority: 2,
      )
          .addDartFileEdit((builder) {
        // Use the `builder` to insert `static` keyword before method name
        builder.addReplacement(
          node.sourceRange,
          (DartEditBuilder builder) {
            builder.write('deviceNameNullable');
          },
        );
      });
    });
  }
}
