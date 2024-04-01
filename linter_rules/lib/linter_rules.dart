import 'package:linter_rules/lint_rules/adaptive_checkbox_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_dialog_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_progressindicator_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_icons_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_listtile_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_navigator_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_pulldown_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_scaffold_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_scrollbar_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_segmented_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_slider_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_switch_lints.dart';
import 'package:linter_rules/lint_rules/adaptive_tabscaffold_lints.dart';
import 'package:linter_rules/lint_rules/flutter_blue_lints.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _BiVitalLints();

class _BiVitalLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        UseDeviceName(),
        const UseAdaptiveSwitch(),
        const UseAdaptiveCheckbox(),
        const UseAdaptiveCircularProgressIndicator(),
        const UseAdaptiveProgressBar(),
        const UseAdaptiveIcons(),
        const UseAdaptiveListTileMaterial(),
        const UseAdaptiveListTileCupertino(),
        const UseAdaptiveNavigator(),
        const UseAdaptivePullDownButtonMaterial(),
        const UseAdaptivePullDownButtonCupertino(),
        const UseAdaptiveScrollbarMaterial(),
        const UseAdaptiveScrollbarCupertino(),
        const UseAdaptiveSegmentedMaterial(),
        const UseAdaptiveSegmentedCupertino(),
        const UseAdaptiveSlider(),
        const UseAdaptiveTabScaffold(),
        const UseAdaptiveScaffold(),
        const UseAdaptiveDialog(),
      ];
}
