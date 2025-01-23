import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';

import '../constants/strings.dart';

/// Exception thrown when there is no internet connection.
@immutable
class NoInternetException extends AppException {
  const NoInternetException({
    required super.exception,
    required super.stackTrace,
    super.userFriendlyMessage = AppStrings.noInternetConnection,
  });
}
