import 'package:flutter/widgets.dart';

import 'exceptions/validation_exception.dart';

@immutable
abstract class Entity {
  /// Throws a [ValidationException] if the entity is not valid.
  void validate();
}
