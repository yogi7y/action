import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/strings.dart';
import '../../core/exceptions/no_internet_exception.dart';

/// Abstract class defining the contract for checking network connectivity
@immutable
abstract class ConnectivityChecker {
  /// Returns true if there is an active internet connection
  Future<bool> checkConnection();

  /// Stream of connectivity status changes
  /// Emits true when connected, false when disconnected
  Stream<ConnectivityStatus> get connectionStatus;

  /// Returns the current connectivity status without making a new check
  ConnectivityStatus get currentStatus;

  /// Disposes any resources used by the checker
  Future<void> dispose();
}

/// Represents the current state of connectivity
enum ConnectivityStatus {
  connected,
  disconnected;

  bool get isConnected => this == ConnectivityStatus.connected;
}

class ConnectivityCheckerImpl implements ConnectivityChecker {
  @override
  Future<bool> checkConnection() async => true;

  @override
  Stream<ConnectivityStatus> get connectionStatus => throw UnimplementedError();

  @override
  ConnectivityStatus get currentStatus => ConnectivityStatus.connected;

  @override
  Future<void> dispose() async {}
}

final connectivityCheckerProvider =
    Provider<ConnectivityChecker>((ref) => ConnectivityCheckerImpl());

mixin ConnectivityCheckerMixin {
  ConnectivityChecker get connectivityChecker;

  /// Checks if there is an internet connection and throws a [NoInternetException] if there is no connection.
  /// Returns a [Result] with a [Success] if there is an internet connection.
  Result<void, AppException> checkAndThrowNoInternetException() {
    if (!connectivityChecker.currentStatus.isConnected) {
      return Failure(NoInternetException(
        exception: AppStrings.noInternetConnection,
        stackTrace: StackTrace.current,
      ));
    }

    return const Success(null);
  }
}
