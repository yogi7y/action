import 'package:flutter/foundation.dart';

import '../../domain/entity/context.dart';

@immutable
class ContextViewModel {
  const ContextViewModel({
    required this.context,
  });

  /// Current context related data
  final ContextEntity context;

  ContextViewModel copyWith({
    ContextEntity? context,
  }) =>
      ContextViewModel(
        context: context ?? this.context,
      );

  @override
  String toString() => 'ContextViewModel(context: $context)';

  @override
  bool operator ==(covariant ContextViewModel other) {
    if (identical(this, other)) return true;

    return other.context == context;
  }

  @override
  int get hashCode => context.hashCode;
}
