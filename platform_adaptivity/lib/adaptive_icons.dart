// ignore_for_file: non_constant_identifier_names
library platform_adaptivity;

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:platform_adaptivity/app_icons_icons.dart';

/// A list of platform-adaptive icons.
@staticIconProvider
abstract final class AdaptiveIcons {
  const AdaptiveIcons._();

  /// <i class="material-icons md-36">arrow_back</i> &#x2014; material icon named "arrow back". <br> <i class='cupertino-icons md-36'>chevron_left</i> &#x2014; Cupertino icon named "chevron_left".
  static IconData get arrow_back => switch (designPlatform) {
        CitecPlatform.material => Icons.arrow_back,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_left,
        CitecPlatform.fluent => FluentIcons.arrow_left_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">arrow_forward</i> &#x2014; material icon named "arrow forward". <br> <i class='cupertino-icons md-36'>chevron_right</i> &#x2014; Cupertino icon named "chevron_right".
  static IconData get arrow_forward => switch (designPlatform) {
        CitecPlatform.material => Icons.arrow_forward,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_right,
        CitecPlatform.fluent => FluentIcons.arrow_right_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">flip_camera_android</i> &#x2014; material icon named "flip camera android". <br> <i class='cupertino-icons md-36'>camera_rotate_fill</i> &#x2014; Cupertino icon named "camera_rotate_fill".
  static IconData get flip_camera => switch (designPlatform) {
        CitecPlatform.material => Icons.flip_camera_android,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.camera_rotate_fill,
        CitecPlatform.fluent => FluentIcons.camera_switch_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">more_vert</i> &#x2014; material icon named "more vert". <br> <i class='cupertino-icons md-36'>ellipsis</i> &#x2014; Cupertino icon for three solid dots.
  static IconData get more => switch (designPlatform) {
        CitecPlatform.material => Icons.more_vert,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.ellipsis,
        CitecPlatform.fluent => FluentIcons.more_vertical_16_regular,
        _ => throw UnimplementedError(),
      };

  ///<i class="material-icons-outlined md-36">share</i> &#x2014; material icon named "share" (outlined). <br> <i class='cupertino-icons md-36'>square_arrow_up</i> &#x2014; Cupertino icon for an iOS style share icon with an arrow pointing up from a box.
  static IconData get share => switch (designPlatform) {
        CitecPlatform.material => Icons.share_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.share,
        CitecPlatform.fluent => FluentIcons.share_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">file_download</i> &#x2014; material icon named "file download" (outlined). <br> <i class='cupertino-icons md-36'>cloud_download</i> &#x2014; Cupertino icon named "cloud_download".
  static IconData get download => switch (designPlatform) {
        CitecPlatform.material => Icons.file_download_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.cloud_download,
        CitecPlatform.fluent => FluentIcons.arrow_download_16_regular,
        _ => throw UnimplementedError(),
      };

  /// A doc with a zip line. <br> <i class='cupertino-icons md-36'>archivebox</i> &#x2014; Cupertino icon named "archivebox".
  static IconData get archive => switch (designPlatform) {
        CitecPlatform.material => AppIcons.zip,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.archivebox,
        CitecPlatform.fluent => FluentIcons.folder_zip_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">info_outline</i> &#x2014; material icon named "info outline". <br> <i class='cupertino-icons md-36'>info_circle</i> &#x2014; Cupertino icon for a letter 'i' in a circle.
  static IconData get info => switch (designPlatform) {
        CitecPlatform.material => Icons.info_outline,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.info,
        CitecPlatform.fluent => FluentIcons.info_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">info_outline</i> &#x2014; material icon named "info outline". <br> <i class='cupertino-icons md-36'>question_circle</i> &#x2014; Cupertino icon named "question_circle".
  static IconData get question_circle => switch (designPlatform) {
        CitecPlatform.material => Icons.info_outline,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.question_circle,
        CitecPlatform.fluent => FluentIcons.question_circle_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">menu</i> &#x2014; material icon named "menu" (round). <br> <i class='cupertino-icons md-36'>ellipsis_circle</i> &#x2014; Cupertino icon named "ellipsis_circle".
  static IconData get menu_rounded => switch (designPlatform) {
        CitecPlatform.material => Icons.menu_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.ellipsis_circle,
        CitecPlatform.fluent => FluentIcons.more_circle_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">arrow_drop_up</i> &#x2014; <br> <i class="material-icons-round md-36">arrow_drop_down</i> &#x2014; <br> <i class='cupertino-icons md-36'>chevron_up_chevron_down</i> &#x2014; Cupertino icon named "chevron_up_chevron_down".
  static IconData get dropdown => switch (designPlatform) {
        CitecPlatform.material => AppIcons.dropdownup,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_up_chevron_down,
        CitecPlatform.fluent => FluentIcons.chevron_down_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">lock_open</i> &#x2014; material icon named "lock open". <br> <i class='cupertino-icons md-36'>lock_open</i> &#x2014; Cupertino icon named "lock_open".
  static IconData get lock_open => switch (designPlatform) {
        CitecPlatform.material => Icons.lock_open,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.lock_open,
        CitecPlatform.fluent => FluentIcons.lock_open_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">lock_outline</i> &#x2014; material icon named "lock outline" (round). <br> <i class='cupertino-icons md-36'>lock</i> &#x2014; Cupertino icon named "lock".
  static IconData get lock => switch (designPlatform) {
        CitecPlatform.material => Icons.lock_outline_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.lock,
        CitecPlatform.fluent => FluentIcons.lock_closed_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">save</i> &#x2014; material icon named "save" (outlined). <br> <i class='cupertino-icons md-36'>floppy_disk</i> &#x2014; Cupertino icon named "floppy_disk".
  static IconData get save => switch (designPlatform) {
        CitecPlatform.material => Icons.save_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.floppy_disk,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">delete_outline</i> &#x2014; material icon named "delete outline" (round). <br> <i class='cupertino-icons md-36'>trash</i> &#x2014; Cupertino icon named "trash".
  static IconData get delete => switch (designPlatform) {
        CitecPlatform.material => Icons.delete_outline_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.trash,
        CitecPlatform.fluent => FluentIcons.delete_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">delete_forever</i> &#x2014; material icon named "delete forever". <br> <i class='cupertino-icons md-36'>trash_fill</i> &#x2014; Cupertino icon for a trash bin for removing items. This icon is filled in.
  static IconData get delete_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.delete_forever,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.delete_solid,
        CitecPlatform.fluent => FluentIcons.delete_12_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">person_outline</i> &#x2014; material icon named "person outline". <br> <i class='cupertino-icons md-36'>person</i> &#x2014; Cupertino icon for a single person.
  static IconData get person => switch (designPlatform) {
        CitecPlatform.material => Icons.person_outline,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.person,
        CitecPlatform.fluent => FluentIcons.person_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">person</i> &#x2014; material icon named "person outline". <br> <i class='cupertino-icons md-36'>person_fill</i> &#x2014; Cupertino icon for a single person.
  static IconData get person_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.person,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.person_fill,
        CitecPlatform.fluent => FluentIcons.person_12_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">account_circle</i> &#x2014; material icon named "account circle" (round). <br> <i class='cupertino-icons md-36'>person_alt_circle</i> &#x2014; Cupertino icon named "person_alt_circle".
  static IconData get person_circle => switch (designPlatform) {
        CitecPlatform.material => Icons.account_circle_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.person_alt_circle,
        CitecPlatform.fluent => FluentIcons.person_circle_12_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">close</i> &#x2014; material icon named "close" (round). <br> <i class='cupertino-icons md-36'>xmark</i> &#x2014; Cupertino icon named "xmark".
  static IconData get xmark => switch (designPlatform) {
        CitecPlatform.material => Icons.close_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.xmark,
        CitecPlatform.fluent => FluentIcons.dismiss_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">cancel</i> &#x2014; material icon named "cancel" (outlined). <br> <i class='cupertino-icons md-36'>xmark_circle</i> &#x2014; Cupertino icon named "xmark_circle".
  static IconData get xmark_circle => switch (designPlatform) {
        CitecPlatform.material => Icons.cancel_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.xmark_circle,
        CitecPlatform.fluent => FluentIcons.dismiss_circle_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">cancel</i> &#x2014; material icon named "cancel" (outlined). <br> <i class='cupertino-icons md-36'>xmark_circle_fill</i> &#x2014; Cupertino icon named "xmark_circle_fill".
  static IconData get xmark_circle_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.cancel,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.xmark_circle_fill,
        CitecPlatform.fluent => FluentIcons.dismiss_circle_12_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">check_circle_outline</i> &#x2014; material icon named "check circle outline" (round). <br> <i class='cupertino-icons md-36'>checkmark_circle</i> &#x2014; Cupertino icon for a checkmark in a circle. The circle is not filled in.
  static IconData get check_circle => switch (designPlatform) {
        CitecPlatform.material => Icons.check_circle_outline_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.check_mark_circled,
        CitecPlatform.fluent => FluentIcons.checkmark_circle_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">check_circle</i> &#x2014; material icon named "check circle outline". <br> <i class='cupertino-icons md-36'>checkmark_circle_fill</i> &#x2014; Cupertino icon for a checkmark in a circle.
  static IconData get check_circle_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.check_circle,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.check_mark_circled_solid,
        CitecPlatform.fluent => FluentIcons.checkmark_circle_12_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">mode_edit_outline</i> &#x2014; material icon named "mode edit outline" (outlined). <br> <i class='cupertino-icons md-36'>ellipsis_vertical</i> &#x2014; Cupertino icon named "ellipsis_vertical".
  static IconData get edit => switch (designPlatform) {
        CitecPlatform.material => Icons.mode_edit_outline_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.ellipsis_vertical,
        CitecPlatform.fluent => FluentIcons.pen_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">admin_panel_settings</i> &#x2014; material icon named "admin panel settings" (outlined). <br> <i class='cupertino-icons md-36'>lock_shield</i> &#x2014; Cupertino icon named "lock_shield".
  static IconData get shield_person => switch (designPlatform) {
        CitecPlatform.material => Icons.admin_panel_settings_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.lock_shield,
        CitecPlatform.fluent => FluentIcons.shield_person_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">security</i> &#x2014; material icon named "security" (round). <br> <i class='cupertino-icons md-36'>shield_lefthalf_fill</i> &#x2014; Cupertino icon named "shield_lefthalf_fill".
  static IconData get shield_lefthalf_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.security_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.shield_lefthalf_fill,
        CitecPlatform.fluent => FluentIcons.shield_keyhole_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">search</i> &#x2014; material icon named "search". <br> <i class='cupertino-icons md-36'>search</i> &#x2014; Cupertino icon for a magnifier loop outline.
  static IconData get search => switch (designPlatform) {
        CitecPlatform.material => Icons.search,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.search,
        CitecPlatform.fluent => FluentIcons.search_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">settings</i> &#x2014; material icon named "settings" (outlined). <br> <i class='cupertino-icons md-36'>settings</i> &#x2014; Cupertino icon for a cogwheel with many cogs and decoration in the middle.
  static IconData get settings => switch (designPlatform) {
        CitecPlatform.material => Icons.settings_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.settings,
        CitecPlatform.fluent => FluentIcons.settings_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">settings</i> &#x2014; material icon named "settings". <br> Filled version of [AdaptiveIcons.settings]
  static IconData get settings_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.settings,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.gearfill,
        CitecPlatform.fluent => FluentIcons.settings_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">warning_amber</i> &#x2014; material icon named "warning amber" (round). <br> <i class='cupertino-icons md-36'>exclamationmark_triangle</i> &#x2014; Cupertino icon named "exclamationmark_triangle".
  static IconData get warning => switch (designPlatform) {
        CitecPlatform.material => Icons.warning_amber_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.exclamationmark_triangle,
        CitecPlatform.fluent => FluentIcons.warning_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>exclamationmark_bubble</i> &#x2014; Cupertino icon named "exclamationmark_bubble".
  static IconData get error_message => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.exclamationmark_bubble,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.exclamationmark_bubble,
        CitecPlatform.fluent => FluentIcons.chat_warning_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">thumb_up</i> &#x2014; material icon named "thumb up" (outlined). <br> <i class='cupertino-icons md-36'>hand_thumbsup</i> &#x2014; Cupertino icon named "hand_thumbsup".
  static IconData get thumbsup => switch (designPlatform) {
        CitecPlatform.material => Icons.thumb_up_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.hand_thumbsup,
        CitecPlatform.fluent => FluentIcons.thumb_like_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">add</i> &#x2014; material icon named "add". <br> <i class='cupertino-icons md-36'>plus</i> &#x2014; Cupertino icon of a plus sign.
  static IconData get plus => switch (designPlatform) {
        CitecPlatform.material => Icons.add,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.add,
        CitecPlatform.fluent => FluentIcons.add_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">horizontal_rule</i> &#x2014; material icon named "horizontal rule" (round). <br> <i class='cupertino-icons md-36'>minus</i> &#x2014; Cupertino icon named "minus".
  static IconData get minus => switch (designPlatform) {
        CitecPlatform.material => Icons.horizontal_rule_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.minus,
        CitecPlatform.fluent => FluentIcons.subtract_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="fa-solid fa-circle-arrow-up">circle-arrow-up</i> &#x2014; https://fontawesome.com/icons/circle-arrow-up?style=solid Font Awesome icon named "cirle-arrow-up". <br> <i class='cupertino-icons md-36'>arrow_up_circle_fill</i> &#x2014; Cupertino icon named "arrow_up_circle_fill".
  static IconData get arrow_up_circle_fill => switch (designPlatform) {
        CitecPlatform.material => FontAwesomeIcons.circleArrowUp,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.arrow_up_circle_fill,
        CitecPlatform.fluent => FluentIcons.arrow_up_12_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="fa-solid fa-circle-arrow-up">circle-arrow-down</i> &#x2014; https://fontawesome.com/icons/circle-arrow-down?style=solid Font Awesome icon named "cirle-arrow-down". <br> <i class='cupertino-icons md-36'>arrow_down_circle_fill</i> &#x2014; Cupertino icon named "arrow_down_circle_fill".
  static IconData get arrow_down_circle_fill => switch (designPlatform) {
        CitecPlatform.material => FontAwesomeIcons.circleArrowDown,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.arrow_down_circle_fill,
        CitecPlatform.fluent => FluentIcons.arrow_down_12_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">send</i> &#x2014; material icon named "send" (round). <br> <i class='cupertino-icons md-36'>paperplane_fill</i> &#x2014; Cupertino icon named "paperplane_fill".
  static IconData get send => switch (designPlatform) {
        CitecPlatform.material => Icons.send_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.paperplane_fill,
        CitecPlatform.fluent => FluentIcons.send_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">keyboard_arrow_up</i> &#x2014; material icon named "keyboard arrow up". <br> <i class='cupertino-icons md-36'>chevron_up</i> &#x2014; Cupertino icon named "chevron_up".
  static IconData get chevron_up => switch (designPlatform) {
        CitecPlatform.material => Icons.keyboard_arrow_up_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_up,
        CitecPlatform.fluent => FluentIcons.chevron_up_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>chevron_compact_up</i> &#x2014; Cupertino icon named "chevron_compact_up".
  static IconData get chevron_up_compact => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.chevron_compact_up,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_compact_up,
        CitecPlatform.fluent => CupertinoIcons.chevron_compact_up,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">keyboard_arrow_down</i> &#x2014; material icon named "keyboard arrow down". <br> <i class='cupertino-icons md-36'>chevron_down</i> &#x2014; Cupertino icon named "chevron_down".
  static IconData get chevron_down => switch (designPlatform) {
        CitecPlatform.material => Icons.keyboard_arrow_down_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_down,
        CitecPlatform.fluent => FluentIcons.chevron_down_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>chevron_compact_down</i> &#x2014; Cupertino icon named "chevron_compact_down".
  static IconData get chevron_down_compact => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.chevron_compact_down,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_compact_down,
        CitecPlatform.fluent => CupertinoIcons.chevron_compact_down,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">keyboard_arrow_left</i> &#x2014; material icon named "keyboard arrow left". <br> <i class='cupertino-icons md-36'>chevron_left</i> &#x2014; Cupertino icon named "chevron_left".
  static IconData get chevron_left => switch (designPlatform) {
        CitecPlatform.material => Icons.keyboard_arrow_left_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_left,
        CitecPlatform.fluent => FluentIcons.chevron_left_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">keyboard_arrow_right</i> &#x2014; material icon named "keyboard arrow right". <br> <i class='cupertino-icons md-36'>chevron_right</i> &#x2014; Cupertino icon named "chevron_right".
  static IconData get chevron_right => switch (designPlatform) {
        CitecPlatform.material => Icons.keyboard_arrow_right_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.chevron_right,
        CitecPlatform.fluent => FluentIcons.chevron_right_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">play_arrow</i> &#x2014; material icon named "play arrow" (round). <br> <i class='cupertino-icons md-36'>play_fill</i> &#x2014; Cupertino icon named "play_fill".
  static IconData get play => switch (designPlatform) {
        CitecPlatform.material => Icons.play_arrow_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.play_fill,
        CitecPlatform.fluent => FluentIcons.play_20_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">pause</i> &#x2014; material icon named "pause" (round). <br> <i class='cupertino-icons md-36'>pause_fill</i> &#x2014; Cupertino icon named "pause_fill".
  static IconData get pause => switch (designPlatform) {
        CitecPlatform.material => Icons.pause_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.pause_fill,
        CitecPlatform.fluent => FluentIcons.pause_20_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">replay</i> &#x2014; material icon named "replay" (round). <br> <i class='cupertino-icons md-36'>arrow_counterclockwise</i> &#x2014; Cupertino icon named "arrow_counterclockwise".
  static IconData get replay => switch (designPlatform) {
        CitecPlatform.material => Icons.replay_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.arrow_counterclockwise,
        CitecPlatform.fluent => FluentIcons.replay_20_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">stop</i> &#x2014; material icon named "stop" (round). <br> <i class='cupertino-icons md-36'>stop_fill</i> &#x2014; Cupertino icon named "stop_fill".
  static IconData get stop => switch (designPlatform) {
        CitecPlatform.material => Icons.stop_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.stop_fill,
        CitecPlatform.fluent => FluentIcons.stop_20_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">light_mode</i> &#x2014; material icon named "light mode". <br> <i class='cupertino-icons md-36'>sun_max_fill</i> &#x2014; Cupertino icon named "sun_max_fill".
  static IconData get sun_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.light_mode,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.sun_max_fill,
        CitecPlatform.fluent => FluentIcons.weather_sunny_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">light_mode</i> &#x2014; material icon named "light mode" (outlined). <br> <i class='cupertino-icons md-36'>sun_max</i> &#x2014; Cupertino icon named "sun_max".
  static IconData get sun_outlined => switch (designPlatform) {
        CitecPlatform.material => Icons.light_mode_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.sun_max,
        CitecPlatform.fluent => FluentIcons.weather_sunny_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">dark_mode</i> &#x2014; material icon named "dark mode". <br> <i class='cupertino-icons md-36'>moon_fill</i> &#x2014; Cupertino icon named "moon_fill".
  static IconData get moon_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.dark_mode,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.moon_fill,
        CitecPlatform.fluent => FluentIcons.weather_moon_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">dark_mode</i> &#x2014; material icon named "dark mode" (outlined). <br> <i class='cupertino-icons md-36'>moon</i> &#x2014; Cupertino icon named "moon".
  static IconData get moon_outlined => switch (designPlatform) {
        CitecPlatform.material => Icons.dark_mode_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.moon,
        CitecPlatform.fluent => FluentIcons.weather_moon_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">find_in_page</i> &#x2014; material icon named "find in page" (outlined). <br> <i class='cupertino-icons md-36'>doc_text_search</i> &#x2014; Cupertino icon named "doc_text_search".
  static IconData get find_in_page => switch (designPlatform) {
        CitecPlatform.material => Icons.find_in_page_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.doc_text_search,
        CitecPlatform.fluent => FluentIcons.screen_search_20_regular,
        _ => throw UnimplementedError(),
      };

  // NOTE: Support relative path links in hover
  // https://github.com/Dart-Code/Dart-Code/issues/2390
  // https://github.com/microsoft/vscode/issues/86564

  /// Icon of a trophy (goblet).
  static IconData get prize => switch (designPlatform) {
        CitecPlatform.material => AppIcons.prize,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.prize,
        CitecPlatform.fluent => AppIcons.prize,
        _ => throw UnimplementedError(),
      };

  /// Running person.
  static IconData get run => switch (designPlatform) {
        CitecPlatform.material => AppIcons.run,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.run,
        CitecPlatform.fluent => FluentIcons.person_running_20_filled,
        _ => throw UnimplementedError(),
      };

  /// Bubble pointing left. A big circle with a peak on the left.
  static IconData get bubble_left => switch (designPlatform) {
        CitecPlatform.material => AppIcons.bubbleleft,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.bubbleleft,
        CitecPlatform.fluent => AppIcons.bubbleleft,
        _ => throw UnimplementedError(),
      };

  /// A circle simplified beatle icon.
  static IconData get bug_round => switch (designPlatform) {
        CitecPlatform.material => AppIcons.buground,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.buground,
        CitecPlatform.fluent => FluentIcons.bug_16_filled,
        _ => throw UnimplementedError(),
      };

  /// Official BI-Vital logo.
  static IconData get bivital => AppIcons.bivital;

  /// Official Flutter logo.
  static IconData get flutter => AppIcons.flutter;

  /// Rounded square with a thermometer in it. An antenna on the top with waves radiating from it.
  static IconData get temperaturesensor => AppIcons.temperaturesensor;

  /// Typical mobile data bars with an exclamation mark in a circle in front of them.
  static IconData get no_signal => switch (designPlatform) {
        CitecPlatform.material => Icons.signal_cellular_connected_no_internet_0_bar_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.wifi_exclamationmark,
        CitecPlatform.fluent => FluentIcons.cellular_off_20_regular,
        _ => throw UnimplementedError(),
      };

  static IconData get continuous_page => switch (designPlatform) {
        CitecPlatform.material => AppIcons.continuouspage,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.continuouspagealt,
        CitecPlatform.fluent => FluentIcons.document_page_break_20_regular,
        _ => throw UnimplementedError(),
      };

  static IconData get page_by_page => switch (designPlatform) {
        CitecPlatform.material => AppIcons.pagebypage,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.pagebypagealt,
        CitecPlatform.fluent => FluentIcons.document_one_page_multiple_16_regular,
        _ => throw UnimplementedError(),
      };

  /// Chevrons pointing up and down, and a short line inbetween.
  static IconData get vertical_scrolling => switch (designPlatform) {
        CitecPlatform.material => AppIcons.verticalscrolling,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.verticalscrolling,
        CitecPlatform.fluent => FluentIcons.center_vertical_20_regular,
        _ => throw UnimplementedError(),
      };

  /// Chevrons pointing left and right, and a short line inbetween.
  static IconData get horizontal_scrolling => switch (designPlatform) {
        CitecPlatform.material => AppIcons.horizontalscrolling,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.horizontalscrolling,
        CitecPlatform.fluent => FluentIcons.center_horizontal_20_regular,
        _ => throw UnimplementedError(),
      };

  /// Binocular (filled).
  static IconData get binoculars_fill => switch (designPlatform) {
        CitecPlatform.material => AppIcons.binocularsfill,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.binocularsfill,
        CitecPlatform.fluent => AppIcons.binocularsfill,
        _ => throw UnimplementedError(),
      };

  /// Sun and half moon (filled).
  static IconData get day_and_night => switch (designPlatform) {
        CitecPlatform.material => AppIcons.dayandnight,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.dayandnight,
        CitecPlatform.fluent => FluentIcons.time_and_weather_20_filled,
        _ => throw UnimplementedError(),
      };

  /// Sun and crescent moon (outlined).
  static IconData get day_and_night_outlined => switch (designPlatform) {
        CitecPlatform.material => AppIcons.dayandnightoutlined,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.dayandnightoutlined,
        CitecPlatform.fluent => FluentIcons.time_and_weather_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">perm_media</i> &#x2014; material icon named "perm media" (outlined). <br> Stack of two images overlapping.
  static IconData get media_stacked => switch (designPlatform) {
        CitecPlatform.material => Icons.perm_media_outlined,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.imagesstack,
        CitecPlatform.fluent => FluentIcons.image_stack_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">open_in_new</i> &#x2014; material icon named "open in new" (round). <br> <i class='cupertino-icons md-36'>arrow_up_right</i> &#x2014; Cupertino icon named "arrow_up_right".
  static IconData get open_external => switch (designPlatform) {
        CitecPlatform.material => Icons.open_in_new_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.arrow_up_right,
        CitecPlatform.fluent => FluentIcons.open_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">star_border</i> &#x2014; material icon named "star border" (round). <br> <i class='cupertino-icons md-36'>star</i> &#x2014; Cupertino icon named "star".
  static IconData get star => switch (designPlatform) {
        CitecPlatform.material => Icons.star_border_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.star,
        CitecPlatform.fluent => FluentIcons.star_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">vibration</i> &#x2014; material icon named "vibration" (round). <br> <i class='cupertino-icons md-36'>dot_radiowaves_left_right</i> &#x2014; Cupertino icon named "dot_radiowaves_left_right".
  static IconData get vibrate => switch (designPlatform) {
        CitecPlatform.material => Icons.vibration_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.dot_radiowaves_left_right,
        CitecPlatform.fluent => FluentIcons.phone_vibrate_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">mic</i> &#x2014; material icon named "mic" (round). <br> <i class='cupertino-icons md-36'>mic_fill</i> &#x2014; Cupertino icon named "mic_fill".
  static IconData get mic => switch (designPlatform) {
        CitecPlatform.material => Icons.mic_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.mic_fill,
        CitecPlatform.fluent => FluentIcons.mic_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">mic_off</i> &#x2014; material icon named "mic off" (round). <br> <i class='cupertino-icons md-36'>mic_slash_fill</i> &#x2014; Cupertino icon named "mic_slash_fill".
  static IconData get mic_off => switch (designPlatform) {
        CitecPlatform.material => Icons.mic_off_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.mic_slash_fill,
        CitecPlatform.fluent => FluentIcons.mic_off_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">folder_open</i> &#x2014; material icon named "folder open" (round). <br> <i class='cupertino-icons md-36'>folder_open</i> &#x2014; Cupertino icon for a single folder, which stores multiple files. This icon is not filled in.
  static IconData get folder => switch (designPlatform) {
        CitecPlatform.material => Icons.folder_open_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.folder,
        CitecPlatform.fluent => FluentIcons.folder_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">folder</i> &#x2014; material icon named "folder". <br> <i class='cupertino-icons md-36'>folder_fill</i> &#x2014; Cupertino icon named "folder_fill".
  static IconData get folder_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.folder,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.folder_fill,
        CitecPlatform.fluent => FluentIcons.folder_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">insert_drive_file</i> &#x2014; material icon named "insert drive file" (outlined). <br> <i class='cupertino-icons md-36'>doc</i> &#x2014; Cupertino icon named "doc".
  static IconData get doc => switch (designPlatform) {
        CitecPlatform.material => Icons.insert_drive_file_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.doc,
        CitecPlatform.fluent => FluentIcons.document_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">insert_drive_file</i> &#x2014; material icon named "insert drive file" (round). <br> <i class='cupertino-icons md-36'>doc_fill</i> &#x2014; Cupertino icon named "doc_fill".
  static IconData get doc_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.insert_drive_file_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.doc_fill,
        CitecPlatform.fluent => FluentIcons.document_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">summarize</i> &#x2014; material icon named "summarize" (outlined). <br> <i class='cupertino-icons md-36'>doc_text</i> &#x2014; Cupertino icon named "doc_text".
  static IconData get doc_log => switch (designPlatform) {
        CitecPlatform.material => Icons.summarize_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.doc_text,
        CitecPlatform.fluent => FluentIcons.document_bullet_list_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">summarize</i> &#x2014; material icon named "summarize" (round). <br> <i class='cupertino-icons md-36'>doc_text_fill</i> &#x2014; Cupertino icon named "doc_text_fill".
  static IconData get doc_log_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.summarize_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.doc_text_fill,
        CitecPlatform.fluent => FluentIcons.document_bullet_list_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">fiber_smart_record</i> &#x2014; material icon named "fiber smart record" (round). <br> <i class='cupertino-icons md-36'>recordingtape</i> &#x2014; Cupertino icon named "recordingtape".
  static IconData get micAndLog => switch (designPlatform) {
        CitecPlatform.material => Icons.fiber_smart_record_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.recordingtape,
        CitecPlatform.fluent => FluentIcons.slide_record_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>gamecontroller</i> &#x2014; Cupertino icon for an outlined game controller.
  static IconData get game_controller => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.gamecontroller,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.gamecontroller,
        CitecPlatform.fluent => FluentIcons.xbox_controller_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>gamecontroller_fill</i> &#x2014; Cupertino icon for a filled in game controller.
  static IconData get game_controller_fill => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.gamecontroller_fill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.gamecontroller_fill,
        CitecPlatform.fluent => FluentIcons.xbox_controller_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="fa-solid fa-puzzle-piece">circle-arrow-down</i> &#x2014; https://fontawesome.com/icons/puzzle-piece?style=solid Font Awesome icon named "puzzle-piece". <br> <i class='cupertino-icons md-36'>tray_2</i> &#x2014; Cupertino icon named "tray_2".
  static IconData get packages => switch (designPlatform) {
        CitecPlatform.material => FontAwesomeIcons.puzzlePiece,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.tray_2,
        CitecPlatform.fluent => FluentIcons.puzzle_cube_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">table_chart</i> &#x2014; material icon named "table chart" (outlined). <br> <i class='cupertino-icons md-36'>table</i> &#x2014; Cupertino icon named "table".
  static IconData get table => switch (designPlatform) {
        CitecPlatform.material => Icons.table_chart_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.table,
        CitecPlatform.fluent => FluentIcons.table_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">table_chart</i> &#x2014; material icon named "table chart" (round). <br> <i class='cupertino-icons md-36'>table_fill</i> &#x2014; Cupertino icon named "table_fill".
  static IconData get table_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.table_chart_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.table_fill,
        CitecPlatform.fluent => FluentIcons.table_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">power_settings_new</i> &#x2014; material icon named "power settings new" (round). <br> <i class='cupertino-icons md-36'>power</i> &#x2014; Cupertino icon named "power".
  static IconData get power => switch (designPlatform) {
        CitecPlatform.material => Icons.power_settings_new_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.power,
        CitecPlatform.fluent => FluentIcons.power_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>tortoise</i> &#x2014; Cupertino icon named "tortoise".
  static IconData get tortoise => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.tortoise,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.tortoise,
        CitecPlatform.fluent => FluentIcons.animal_turtle_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>tortoise_fill</i> &#x2014; Cupertino icon named "tortoise_fill".
  static IconData get tortoise_fill => switch (designPlatform) {
        CitecPlatform.material => AppIcons.tortoisefill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.tortoise_fill,
        CitecPlatform.fluent => FluentIcons.animal_turtle_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>hare</i> &#x2014; Cupertino icon named "hare". Available on cupertino_icons package 1.0.0+ only.
  static IconData get hare => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.hare,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.hare,
        CitecPlatform.fluent => FluentIcons.animal_rabbit_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>hare_fill</i> &#x2014; Cupertino icon named "hare_fill".
  static IconData get hare_fill => switch (designPlatform) {
        CitecPlatform.material => AppIcons.rabbitfill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.hare_fill,
        CitecPlatform.fluent => FluentIcons.animal_rabbit_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">translate</i> &#x2014; material icon named "translate".
  static IconData get translate => switch (designPlatform) {
        CitecPlatform.material => Icons.translate,
        CitecPlatform.ios || CitecPlatform.macos => Icons.translate,
        CitecPlatform.fluent => FluentIcons.translate_auto_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>graph_circle</i> &#x2014; Cupertino icon named "graph_circle".
  static IconData get graph_circle => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.graph_circle,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.graph_circle,
        CitecPlatform.fluent => FluentIcons.gantt_chart_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>graph_circle_fill</i> &#x2014; Cupertino icon named "graph_circle_fill".
  static IconData get graph_circle_fill => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.graph_circle_fill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.graph_circle_fill,
        CitecPlatform.fluent => FluentIcons.gantt_chart_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">map</i> &#x2014; material icon named "map" (outlined). <br> <i class='cupertino-icons md-36'>map</i> &#x2014; Cupertino icon named "map".
  static IconData get map => switch (designPlatform) {
        CitecPlatform.material => Icons.map_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.map,
        CitecPlatform.fluent => FluentIcons.map_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">map</i> &#x2014; material icon named "map" (round). <br> <i class='cupertino-icons md-36'>map_fill</i> &#x2014; Cupertino icon named "map_fill".
  static IconData get map_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.map_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.map_fill,
        CitecPlatform.fluent => FluentIcons.map_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">question_mark</i> &#x2014; material icon named "question mark" (round). <br> <i class='cupertino-icons md-36'>question</i> &#x2014; Cupertino icon named "question".
  static IconData get question => switch (designPlatform) {
        CitecPlatform.material => Icons.question_mark_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.question,
        CitecPlatform.fluent => FluentIcons.question_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">bluetooth</i> &#x2014; material icon named "bluetooth".
  static IconData get bluetooth => switch (designPlatform) {
        CitecPlatform.material => Icons.bluetooth,
        CitecPlatform.ios || CitecPlatform.macos => Icons.bluetooth,
        CitecPlatform.fluent => FluentIcons.bluetooth_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">bluetooth_disabled</i> &#x2014; material icon named "bluetooth disabled" (round).
  static IconData get bluetooth_disabled => switch (designPlatform) {
        CitecPlatform.material => Icons.bluetooth_disabled_rounded,
        CitecPlatform.ios || CitecPlatform.macos => Icons.bluetooth_disabled_rounded,
        CitecPlatform.fluent => FluentIcons.bluetooth_disabled_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">bluetooth_audio</i> &#x2014; material icon named "bluetooth audio".
  static IconData get bluetooth_audio => switch (designPlatform) {
        CitecPlatform.material => Icons.bluetooth_audio,
        CitecPlatform.ios || CitecPlatform.macos => Icons.bluetooth_audio,
        CitecPlatform.fluent => FluentIcons.speaker_bluetooth_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">favorite_border</i> &#x2014; material icon named "favorite border" (round). <br> <i class='cupertino-icons md-36'>heart</i> &#x2014; Cupertino icon for an outlined heart shape. Can be used to indicate like or favorite states.
  static IconData get heart => switch (designPlatform) {
        CitecPlatform.material => AppIcons.favorite,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.heart,
        CitecPlatform.fluent => FluentIcons.heart_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">favorite</i> &#x2014; material icon named "favorite" (round). <br> <i class='cupertino-icons md-36'>heart_fill</i> &#x2014; Cupertino icon named "heart_fill".
  static IconData get heart_fill => switch (designPlatform) {
        CitecPlatform.material => AppIcons.favoritefill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.heart_fill,
        CitecPlatform.fluent => FluentIcons.heart_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>heart_slash</i> &#x2014; Cupertino icon named "heart_slash".
  static IconData get heart_slash => switch (designPlatform) {
        CitecPlatform.material => AppIcons.favoriteslash,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.heart_slash,
        CitecPlatform.fluent => FluentIcons.heart_off_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>heart_slash_fill</i> &#x2014; Cupertino icon named "heart_slash_fill".
  static IconData get heart_slash_fill => switch (designPlatform) {
        CitecPlatform.material => AppIcons.favoriteslashfill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.heart_slash_fill,
        CitecPlatform.fluent => FluentIcons.heart_off_16_filled,
        _ => throw UnimplementedError(),
      };

  /// An outlined heart with a pulse line in the middle.
  static IconData get heart_ecg => switch (designPlatform) {
        CitecPlatform.material => AppIcons.ecgheartmaterial,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.ecgheartcupertino,
        CitecPlatform.fluent => FluentIcons.heart_pulse_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">trending_up</i> &#x2014; material icon named "trending up" (round).
  static IconData get trending_up => switch (designPlatform) {
        CitecPlatform.material => Icons.trending_up_rounded,
        CitecPlatform.ios || CitecPlatform.macos => Icons.trending_up_rounded,
        CitecPlatform.fluent => FluentIcons.arrow_trending_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">trending_down</i> &#x2014; material icon named "trending down" (round).
  static IconData get trending_down => switch (designPlatform) {
        CitecPlatform.material => Icons.trending_down_rounded,
        CitecPlatform.ios || CitecPlatform.macos => Icons.trending_down_rounded,
        CitecPlatform.fluent => FluentIcons.arrow_trending_down_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">back_hand</i> &#x2014; material icon named "back hand" (outlined). <br> <i class='cupertino-icons md-36'>hand_raised</i> &#x2014; Cupertino icon named "hand_raised".
  static IconData get hand_raised => switch (designPlatform) {
        CitecPlatform.material => Icons.back_hand_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.hand_raised,
        CitecPlatform.fluent => FluentIcons.hand_right_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">back_hand</i> &#x2014; material icon named "back hand" (round). <br> <i class='cupertino-icons md-36'>hand_raised_fill</i> &#x2014; Cupertino icon named "hand_raised_fill".
  static IconData get hand_raised_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.back_hand_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.hand_raised_fill,
        CitecPlatform.fluent => FluentIcons.hand_right_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">speed</i> &#x2014; material icon named "speed" (round). <br> <i class='cupertino-icons md-36'>speedometer</i> &#x2014; Cupertino icon named "speedometer".
  static IconData get speedometer => switch (designPlatform) {
        CitecPlatform.material => Icons.speed_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.speedometer,
        CitecPlatform.fluent => FluentIcons.top_speed_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">gps_fixed</i> &#x2014; material icon named "gps fixed". <br> <i class='cupertino-icons md-36'>location_fill</i> &#x2014; Cupertino icon named "location_fill".
  static IconData get location => switch (designPlatform) {
        CitecPlatform.material => Icons.gps_fixed,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.location_fill,
        CitecPlatform.fluent => FluentIcons.my_location_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">location_on</i> &#x2014; material icon named "location on". <br> <i class='cupertino-icons md-36'>placemark_fill</i> &#x2014; Cupertino icon for a location pin. This icon is filled in.
  static IconData get location_pin => switch (designPlatform) {
        CitecPlatform.material => Icons.location_on,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.location_solid,
        CitecPlatform.fluent => FluentIcons.location_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>waveform_path</i> &#x2014; Cupertino icon named "waveform_path".
  static IconData get waveform_path => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.waveform_path,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.waveform_path,
        CitecPlatform.fluent => CupertinoIcons.waveform_path,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>waveform_path_ecg</i> &#x2014; Cupertino icon named "waveform_path_ecg".
  static IconData get waveform_path_ecg => switch (designPlatform) {
        CitecPlatform.material => AppIcons.vitalsigns,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.waveform_path_ecg,
        CitecPlatform.fluent => FluentIcons.pulse_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">monitor_heart</i> &#x2014; material icon named "monitor heart" (outlined).
  static IconData get waveform_path_ecg_rectangle => switch (designPlatform) {
        CitecPlatform.material => Icons.monitor_heart_outlined,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.waveformpathecgrectangle,
        CitecPlatform.fluent => FluentIcons.pulse_square_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">circle</i> &#x2014; material icon named "circle". <br> <i class='cupertino-icons md-36'>circle_fill</i> &#x2014; Cupertino icon named "circle_fill".
  static IconData get circle_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.circle,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.circle_fill,
        CitecPlatform.fluent => FluentIcons.circle_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>square_grid_2x2</i> &#x2014; Cupertino icon named "square_grid_2x2".
  static IconData get square_grid_2x2 => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.square_grid_2x2,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.square_grid_2x2,
        CitecPlatform.fluent => FluentIcons.table_simple_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>square_grid_2x2_fill</i> &#x2014; Cupertino icon named "square_grid_2x2_fill".
  static IconData get square_grid_2x2_fill => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.square_grid_2x2_fill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.square_grid_2x2_fill,
        CitecPlatform.fluent => FluentIcons.table_simple_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>square_grid_3x2</i> &#x2014; Cupertino icon named "square_grid_3x2".
  static IconData get square_grid_3x2 => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.square_grid_3x2,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.square_grid_3x2,
        CitecPlatform.fluent => FluentIcons.table_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class='cupertino-icons md-36'>square_grid_3x2_fill</i> &#x2014; Cupertino icon named "square_grid_3x2_fill".
  static IconData get square_grid_3x2_fill => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.square_grid_3x2_fill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.square_grid_3x2_fill,
        CitecPlatform.fluent => FluentIcons.table_16_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">list</i> &#x2014; material icon named "list" (round). <br> <i class='cupertino-icons md-36'>list_bullet</i> &#x2014; Cupertino icon named "list_bullet".
  static IconData get list_bullet => switch (designPlatform) {
        CitecPlatform.material => Icons.list_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.list_bullet,
        CitecPlatform.fluent => FluentIcons.text_bullet_list_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">terminal</i> &#x2014; material icon named "terminal" (round).<br> <i class='cupertino-icons md-36'>list_bullet_below_rectangle</i> &#x2014; Cupertino icon named "list_bullet_below_rectangle".
  static IconData get terminal => switch (designPlatform) {
        CitecPlatform.material => Icons.terminal_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.list_bullet_below_rectangle,
        CitecPlatform.fluent => FluentIcons.window_console_20_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">language</i> &#x2014; material icon named "language". <br> <i class='cupertino-icons md-36'>globe</i> &#x2014; Cupertino icon named "globe".
  static IconData get globe => switch (designPlatform) {
        CitecPlatform.material => Icons.language,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.globe,
        CitecPlatform.fluent => FluentIcons.globe_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">filter_list_off</i> &#x2014; material icon named "filter list off" (round). <br> <i class='cupertino-icons md-36'>line_horizontal_3_decrease_circle_fill</i> &#x2014; Cupertino icon named "line_horizontal_3_decrease_circle_fill".
  static IconData get filter_off => switch (designPlatform) {
        CitecPlatform.material => Icons.filter_list_off_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.line_horizontal_3_decrease_circle_fill,
        CitecPlatform.fluent => FluentIcons.filter_dismiss_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">filter_list</i> &#x2014; material icon named "filter list" (round). <br>  <i class='cupertino-icons md-36'>line_horizontal_3_decrease_circle</i> &#x2014; Cupertino icon named "line_horizontal_3_decrease_circle".
  static IconData get filter_on => switch (designPlatform) {
        CitecPlatform.material => Icons.filter_list_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.line_horizontal_3_decrease_circle,
        CitecPlatform.fluent => FluentIcons.filter_12_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">music_note</i> &#x2014; material icon named "music note" (round). <br> <i class='cupertino-icons md-36'>music_note</i> &#x2014; Cupertino icon for a symbol representing a solid single musical note.
  static IconData get music => switch (designPlatform) {
        CitecPlatform.material => Icons.music_note_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.music_note,
        CitecPlatform.fluent => FluentIcons.music_note_1_20_filled,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">videocam</i> &#x2014; material icon named "videocam" (outlined). <br> <i class='cupertino-icons md-36'>videocam</i> &#x2014; Cupertino icon named "videocam".
  static IconData get videocam => switch (designPlatform) {
        CitecPlatform.material => Icons.videocam_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.videocam,
        CitecPlatform.fluent => FluentIcons.video_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">photo_size_select_actual</i> &#x2014; material icon named "photo size select actual" (outlined). <br> <i class='cupertino-icons md-36'>photo</i> &#x2014; Cupertino icon named "photo".
  static IconData get photo => switch (designPlatform) {
        CitecPlatform.material => Icons.photo_size_select_actual_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.photo,
        CitecPlatform.fluent => FluentIcons.image_16_regular,
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-outlined md-36">layers</i> &#x2014; material icon named "layers" (outlined). <br> <i class='cupertino-icons md-36'>layers</i> &#x2014; Cupertino icon named "layers".
  static IconData get layers => switch (designPlatform) {
        CitecPlatform.material => Icons.layers_outlined,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.layers,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">layers</i> &#x2014; material icon named "layers" (round). <br> <i class='cupertino-icons md-36'>layers_fill</i> &#x2014; Cupertino icon named "layers_fill".
  static IconData get layers_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.layers_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.layers_fill,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">directions_run</i> &#x2014; material icon named "directions run" (round).
  static IconData get directions_run_rounded => switch (designPlatform) {
        CitecPlatform.material => Icons.directions_run_rounded,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.figurerun,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">flag</i> &#x2014; material icon named "flag" (round). <br> <i class='cupertino-icons md-36'>flag_fill</i> &#x2014; Cupertino icon named "flag_fill".
  static IconData get flag_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.flag_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.flag_fill,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons md-36">directions_car_filled</i> &#x2014; material icon named "directions car filled". <br> <i class='cupertino-icons md-36'>car_fill</i> &#x2014; Cupertino icon named "car_fill".
  static IconData get car_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.directions_car_filled,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.car_fill,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">credit_card</i> &#x2014; material icon named "credit card" (round). <br> <i class='cupertino-icons md-36'>creditcard_fill</i> &#x2014; Cupertino icon named "creditcard_fill".
  static IconData get card_fill => switch (designPlatform) {
        CitecPlatform.material => Icons.credit_card_rounded,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.creditcard_fill,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">credit_card</i> &#x2014; material icon named "credit card" (round). <br> <i class='cupertino-icons md-36'>creditcard_fill</i> &#x2014; Cupertino icon named "creditcard_fill".
  static IconData get wrench_fill => switch (designPlatform) {
        CitecPlatform.material => CupertinoIcons.wrench_fill,
        CitecPlatform.ios || CitecPlatform.macos => CupertinoIcons.wrench_fill,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">credit_card</i> &#x2014; material icon named "credit card" (round). <br> <i class='cupertino-icons md-36'>creditcard_fill</i> &#x2014; Cupertino icon named "creditcard_fill".
  static IconData get fuelpump_fill => switch (designPlatform) {
        CitecPlatform.material => AppIcons.fuelpumpfill,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.fuelpumpfill,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">credit_card</i> &#x2014; material icon named "credit card" (round). <br> <i class='cupertino-icons md-36'>creditcard_fill</i> &#x2014; Cupertino icon named "creditcard_fill".
  static IconData get stethoscope => switch (designPlatform) {
        CitecPlatform.material => AppIcons.stethoscope,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.stethoscope,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };

  /// <i class="material-icons-round md-36">tire_repair</i> &#x2014; material icon named "tire repair" (round). <br> <i class='cupertino-icons md-36'>creditcard_fill</i> &#x2014; Cupertino icon named "creditcard_fill".
  static IconData get tire => switch (designPlatform) {
        CitecPlatform.material => Icons.tire_repair_rounded,
        CitecPlatform.ios || CitecPlatform.macos => AppIcons.tire,
        CitecPlatform.fluent => throw UnimplementedError(),
        _ => throw UnimplementedError(),
      };
}
