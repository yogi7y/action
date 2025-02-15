import 'package:flutter/material.dart';

@immutable
class AssetsV2 {
  const AssetsV2._();

  static const String _iconsBase = 'assets/icons';
  static const String _soundsBase = 'assets/sounds';

  // Navigation & Actions
  static const bookmarkAdd = '$_iconsBase/bookmark-add-outlined.svg.vec';
  static const addTask = '$_iconsBase/add-task-outlined.svg.vec';
  static const plus = '$_iconsBase/plus-outlined.svg.vec';
  static const user = '$_iconsBase/user-outlined.svg.vec';
  static const clock = '$_iconsBase/clock-outlined.svg.vec';
  static const loader = '$_iconsBase/loader-outlined.svg.vec';
  static const hammerOutlined = '$_iconsBase/hammer-outlined.svg.vec';
  static const calendarLinesOutlined = '$_iconsBase/calendar-lines-outlined.svg.vec';
  static const calendarOutlined = '$_iconsBase/calendar-outlined.svg.vec';
  static const tag = '$_iconsBase/tag.svg.vec';
  static const xmark = '$_iconsBase/xmark.svg.vec';
  static const chevronDown = '$_iconsBase/chevron-down.svg.vec';
  static const circle = '$_iconsBase/circle.svg.vec';
  static const circleCheck = '$_iconsBase/circle_check.svg.vec';
  static const circleDashed = '$_iconsBase/circle_dashed.svg.vec';
  static const forwardStep = '$_iconsBase/forward_step.svg.vec';
  static const home = '$_iconsBase/home-smile.svg.vec';
  static const area = '$_iconsBase/area.svg.vec';
  static const resources = '$_iconsBase/resources.svg.vec';
  static const search = '$_iconsBase/search.svg.vec';
  static const check = '$_iconsBase/check.svg.vec';
  static const chevronLeft = '$_iconsBase/chevron-left.svg.vec';
  static const send = '$_iconsBase/send-alt-2.svg.vec';

  // Sounds
  static const bubbleBurst1 = '$_soundsBase/bubble_burst_1_min.mp3';
  static const popTiny2 = '$_soundsBase/ui_pop_tiny_2_min.mp3';
  static const whoosh = '$_soundsBase/whoosh.mp3';
}
