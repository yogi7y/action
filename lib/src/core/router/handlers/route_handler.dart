import 'package:flutter/material.dart';
import '../route_data.dart';

/// A route handler that validates route data and builds widgets with typed parameters.
///
/// Type parameter [T] represents the transformed route parameter type that will be
/// passed to the build method after validation.
@immutable
abstract class RouteHandler<T extends Object?> {
  /// Validates and transforms raw route data into type [T].
  ///
  /// This method should be implemented to convert the [data] into the
  /// strongly-typed parameter needed by [build].
  ///
  /// Parameters:
  ///   - [data]: The raw route data to validate and transform
  ///
  /// Returns a value of type [T] that will be passed to [build].
  @protected
  @visibleForTesting
  T validateAndTransform({
    required AppRouteData data,
  });

  /// Builds the widget for this route with the validated parameter.
  ///
  /// Parameters:
  ///   - [context]: The build context
  ///   - [param]: The validated parameter of type [T]
  ///
  /// Returns the widget to be rendered for this route.
  @protected
  @visibleForTesting
  Widget build(BuildContext context, T param);

  /// Handles the route by validating the data and building the widget.
  ///
  /// This method orchestrates the routing flow by:
  /// 1. Validating and transforming the route data
  /// 2. Building the widget with the transformed parameter
  ///
  /// Parameters:
  ///   - [context]: The build context
  ///   - [routeData]: The raw route data to be validated
  ///
  /// Returns the built widget for this route.
  Widget handle(BuildContext context, AppRouteData routeData) {
    final param = validateAndTransform(data: routeData);

    return build(context, param);
  }
}
