import 'package:datatype_extensions/string_extensions.dart';
import 'package:settings_section/settings_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:settings_section/settings_section_child.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double spaceBetweenSections = 20;
const double spaceAtBottom = 30;

final Map<String, bool> isExpandeds = {};

class SettingsSection extends StatefulWidget {
  const SettingsSection({
    super.key,
    this.elevation = 0,
    this.dense = false,
    this.initialExpanded = true,
    this.leading,
    this.title,
    this.titleStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
    this.subtitle,
    required this.children,
    this.color,
    this.isExpandable = true,
    this.margin = const EdgeInsets.only(
      left: SettingsSectionDefaults.margin,
      top: spaceBetweenSections,
      right: SettingsSectionDefaults.margin,
      bottom: SettingsSectionDefaults.margin,
    ),
    this.saveExpandedState = true,
  }) : assert(!(title == null && subtitle != null));

  final double elevation;
  final bool dense;
  final bool initialExpanded;
  final Widget? leading;
  final String? title;
  final TextStyle titleStyle;
  final Widget? subtitle;
  final List<SettingsSectionChild> children;
  final Color? color;
  final bool isExpandable;
  final EdgeInsets margin;
  final bool saveExpandedState;

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  late bool _initiallyExpanded;
  final GlobalKey<SettingsExpansionTileState> _expansionTileKey = GlobalKey<SettingsExpansionTileState>();
  late bool _supressExpansion;

  @override
  void initState() {
    _supressExpansion = widget.title == null || !widget.isExpandable;
    _initiallyExpanded = widget.title == null || widget.initialExpanded;
    if (!_supressExpansion && widget.saveExpandedState) {
      if (isExpandeds[_makeKey()] != null)
        _initiallyExpanded = isExpandeds[_makeKey()]!;
      else
        _getIsExpanded().then((bool value) => _changeIsExpanded(value, true));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == null)
      return Padding(
        padding: widget.margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _addSpacingBetween(
            friendsSpacing: SettingsSectionDefaults.margin,
            enemiesSpacing: widget.margin.bottom + widget.margin.top,
            children: _buildChildren(
              children: widget.children,
            ),
          ),
        ),
      );
    else
      return SettingsExpansionTile(
        supressExpansion: _supressExpansion,
        key: _expansionTileKey,
        initiallyExpanded: _initiallyExpanded,
        maintainState: false,
        tilePadding: widget.margin.copyWith(bottom: SettingsSectionDefaults.margin),
        childrenPadding: widget.margin.copyWith(top: 0),
        onExpansionChanged: (bool newValue) => _changeIsExpanded(newValue, false),
        leading: widget.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.title!.capitalizeTitleCupertino,
              style: widget.titleStyle,
            ),
            if (widget.subtitle != null) widget.subtitle!,
          ],
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: _addSpacingBetween(
          friendsSpacing: SettingsSectionDefaults.margin,
          enemiesSpacing: widget.margin.bottom + widget.margin.top,
          children: _buildChildren(
            children: widget.children,
          ),
        ),
      );
  }

  List<Widget> _buildChildren({required List<SettingsSectionChild> children}) {
    final List<Widget> result = [];
    final List<SettingsSectionChild> group = [];
    for (final SettingsSectionChild subsection in children) {
      if (subsection is! SettingsSectionSubColumn && subsection is! SettingsSectionSubRow && subsection is! SettingsFooter) {
        // temp save unwrapped subsection
        group.add(subsection);
      } else {
        // subsection is wrapped or is a description
        if (group.isNotEmpty) {
          // there are unwrapped subsection(s) from before
          // wrap them
          result.add(SettingsSectionSubColumn(
            elevation: widget.elevation,
            color: widget.color,
            subsections: List.from(group),
          ));
        }
        if (subsection is SettingsSectionSubColumn) {
          // add wrapped subsection
          result.add(subsection);
        } else if (subsection is SettingsSectionSubRow) {
          // add wrapped subsection
          result.add(subsection);
        } else if (subsection is SettingsFooter) {
          // add description
          result.add(subsection);
        }
        // clear temp storage of unwrapped subsections
        group.clear();
      }
    }
    if (group.isNotEmpty)
      // there are unwrapped subsection(s) from before
      // wrap them and store for return
      result.add(
        SettingsSectionSubColumn(
          elevation: widget.elevation,
          color: widget.color,
          subsections: group,
        ),
      );
    return result;
  }

  List<Widget> _addSpacingBetween({
    required double friendsSpacing,
    required double enemiesSpacing,
    required List<Widget> children,
  }) {
    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i != children.length - 1) {
        if (children[i] is SettingsSectionSubColumn && children[i + 1] is SettingsSectionSubColumn)
          result.add(SizedBox(height: enemiesSpacing));
        else if (children[i] is Padding && children[i + 1] is SettingsSectionSubColumn)
          result.add(SizedBox(height: enemiesSpacing));
        else if (children[i] is SettingsSectionSubRow && children[i + 1] is SettingsSectionSubRow)
          result.add(SizedBox(height: enemiesSpacing));
        else if (children[i] is Padding && children[i + 1] is SettingsSectionSubRow)
          result.add(SizedBox(height: enemiesSpacing));
        else
          result.add(SizedBox(height: friendsSpacing));
      }
    }
    return result;
  }

  Future<bool> _getIsExpanded() async {
    if (_supressExpansion) return _initiallyExpanded;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? content = prefs.getBool(_makeKey());
    return content ?? widget.initialExpanded;
  }

  Future<void> _setIsExpanded(bool value) async {
    if (_supressExpansion) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_makeKey(), value);
  }

  String _makeKey() => 'isExpanded${widget.title![0]}';

  Future<void> _changeIsExpanded(bool value, bool isNew) async {
    if (isNew) {
      isExpandeds.addAll({_makeKey(): value});
      if (value)
        _expansionTileKey.currentState?.tileController.expand();
      else
        _expansionTileKey.currentState?.tileController.collapse();
    } else {
      isExpandeds[_makeKey()] = value;
      await _setIsExpanded(value);
    }
  }
}
