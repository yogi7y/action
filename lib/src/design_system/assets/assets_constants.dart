import 'package:flutter/material.dart';

@Deprecated('Use AssetsV2 instead')
abstract class Assets {
  @Deprecated('Use AssetsV2 instead')
  const Assets._();

  static const String _iconsPath = 'assets/icons';

  static const String addTask = '$_iconsPath/add_task.svg';
  static const String add = '$_iconsPath/add.svg';
  static const String alertCircle = '$_iconsPath/alert_circle.svg';
  static const String alertTriangle = '$_iconsPath/alert_triangle.svg';
  static const String bookmarkAdd = '$_iconsPath/bookmark_add.svg';
  static const String calendarMonth = '$_iconsPath/calendar_month.svg';
  static const String check = '$_iconsPath/check_bold.svg';
  static const String construction = '$_iconsPath/construction.svg';
  static const String explore = '$_iconsPath/explore.svg';
  static const String hardware = '$_iconsPath/hardware.svg';
  static const String home = '$_iconsPath/home.svg';
  static const String inbox = '$_iconsPath/inbox.svg';
  static const String name10 = '$_iconsPath/Name10.svg';
  static const String playCircle = '$_iconsPath/play-circle.svg';
  static const String play = '$_iconsPath/play.svg';
  static const String search = '$_iconsPath/search.svg';
  static const String tag = '$_iconsPath/tag.svg';
  static const String x = '$_iconsPath/x.svg';
  static const String send = '$_iconsPath/send.svg';
  static const String arrowBack = '$_iconsPath/arrow_back.svg';
  static const String circleWithDots = '$_iconsPath/circle_with_dots.svg';
  static const String circle = '$_iconsPath/circle.svg';
  static const String circleWithCheck = '$_iconsPath/circle_with_check.svg';
}

@immutable
class AssetsV2 {
  const AssetsV2._();

  static const String _base = 'assets/icons';

  // Navigation & Actions
  static const String bookmarkAdd = '$_base/bookmark-add-outlined.svg';
  static const String addTask = '$_base/add-task-outlined.svg';
  static const String plus = '$_base/plus-outlined.svg';
  static const String user = '$_base/user-outlined.svg';
  static const String clock = '$_base/clock-outlined.svg';
  static const String loader = '$_base/loader-outlined.svg';
  static const String home = '$_base/home-outlined.svg';
  static const hammerOutlined = '$_base/hammer-outlined.svg';

  static const String calendarLines = '$_base/calendar-lines-outlined.svg';
  static const String calendar = '$_base/calendar-outlined.svg';

  static const String tag = '$_base/tag-outlined.svg';

  static const String xmark = '$_base/xmark.svg';
  static const String chevronDown = '$_base/chevron-down.svg';
}
