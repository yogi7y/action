import 'package:flutter/material.dart';

abstract class Weights {}

abstract class Regular implements Weights {
  TextStyle get regular;
}

abstract class Medium implements Weights {
  TextStyle get medium;
}

abstract class Semibold implements Weights {
  TextStyle get semibold;
}

abstract class Bold implements Weights {
  TextStyle get bold;
}
