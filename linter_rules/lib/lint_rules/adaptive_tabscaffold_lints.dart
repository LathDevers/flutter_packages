import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const List<String> _wrongNames = ['TabBar', 'TabBarView', 'NavigationBar', 'CupertinoTabScaffold', 'CupertinoTabBar', 'BottomNavigationBarItem', 'CupertinoTabView'];

class UseAdaptiveTabScaffold extends DartLintRule {
  const UseAdaptiveTabScaffold() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'use_adaptive_tabscaffold',
    problemMessage: 'Use AdaptiveTabScaffoldWithBottomNavigation instead',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.staticType;
      if (element == null || !_wrongNames.contains(element.toString().split('<').first)) return;
      reporter.atNode(node.constructorName, code);
    });
  }
}
