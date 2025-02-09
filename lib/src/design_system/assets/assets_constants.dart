import 'package:flutter/material.dart';

@immutable
class AssetsV2 {
  const AssetsV2._();

  static const String _iconsBase = 'assets/icons';
  static const String _soundsBase = 'assets/sounds';

  // Navigation & Actions
  static const bookmarkAdd = '$_iconsBase/bookmark-add-outlined.svg';
  static const addTask = '$_iconsBase/add-task-outlined.svg';
  static const plus = '$_iconsBase/plus-outlined.svg';
  static const user = '$_iconsBase/user-outlined.svg';
  static const clock = '$_iconsBase/clock-outlined.svg';
  static const loader = '$_iconsBase/loader-outlined.svg';
  static const hammerOutlined = '$_iconsBase/hammer-outlined.svg';

  static const calendarLinesOutlined = '$_iconsBase/calendar-lines-outlined.svg';
  static const calendarOutlined = '$_iconsBase/calendar-outlined.svg';

  static const tag = '$_iconsBase/tag-outlined.svg';

  static const xmark = '$_iconsBase/xmark.svg';
  static const chevronDown = '$_iconsBase/chevron-down.svg';

  static const circle = '$_iconsBase/circle.svg';
  static const circleCheck = '$_iconsBase/circle_check.svg';
  static const circleDashed = '$_iconsBase/circle_dashed.svg';
  static const forwardStep = '$_iconsBase/forward_step.svg';

  static const home = '$_iconsBase/home-smile.svg';
  static const area = '$_iconsBase/area.svg';
  static const resources = '$_iconsBase/resources.svg';
  static const search = '$_iconsBase/search.svg';

  static const check = '$_iconsBase/check-bold.svg';
  static const chevronLeft = '$_iconsBase/chevron-left.svg';
  static const send = '$_iconsBase/send-alt-2.svg';

  // Sounds
  static const bubbleBurst1 = '$_soundsBase/bubble_burst_1_min.mp3';
  static const popTiny2 = '$_soundsBase/ui_pop_tiny_2_min.mp3';
  static const whoosh = '$_soundsBase/whoosh.mp3';
}
