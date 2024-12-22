import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../shared/buttons/async_button.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AsyncButton(
            text: 'Go to Profile',
            onClick: () async {
              final _router = AutoRouter.of(context);
              unawaited(_router.push(const ProfileRoute()));
            },
          ),
        ],
      ),
    );
  }
}
