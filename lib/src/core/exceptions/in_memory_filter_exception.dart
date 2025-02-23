import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';

import '../constants/strings.dart';

@immutable
class InMemoryFilterException implements AppException {
  InMemoryFilterException({
    required this.key,
    required this.value,
    required this.stackTrace,
    this.userFriendlyMessage = AppStrings.somethingWentWrong,
  }) : exception =
            'Either the key $key does not exist or the value $value (${value.runtimeType}) is not of the expected type.';

  /// The [key] which was being used in the filter.
  final String key;

  /// The [value] which was being looked up in the filter.
  final Object? value;

  /// The original exception that caused this serialization error.
  @override
  final Object? exception;

  /// The stack trace where the serialization exception occurred.
  @override
  final StackTrace stackTrace;

  /// A user-friendly message that can be displayed in the UI.
  @override
  final String userFriendlyMessage;
}
