import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongTypes = [
  'Icons',
  'CupertinoIcons',
];

class UseAdaptiveIcons extends DartLintRule {
  const UseAdaptiveIcons() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_icons',
    problemMessage: 'Use AdaptiveIcons',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addSimpleIdentifier((node) {
      if (!_wrongTypes.contains(node.toString())) return;
      print(node.inConstantContext);
      reporter.reportErrorForNode(code, node);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAdaptiveIcons(),
      ];
}

class _ReplaceWithAdaptiveIcons extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addSimpleIdentifier((node) {
      if (!_wrongTypes.contains(node.toString())) return;
      reporter
          .createChangeBuilder(
        message: 'Use `AdaptiveIcons`',
        priority: 2,
      )
          .addDartFileEdit((builder) {
        builder
          ..addReplacement(
            node.sourceRange,
            (DartEditBuilder builder) {
              builder.write('AdaptiveIcons');
            },
          )
          ..importLibrary(Uri.parse('package:platform_adaptive_bivital/adaptive_icons.dart'));
      });
    });
  }
}
