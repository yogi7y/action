import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../shared/buttons/async_button.dart';
import '../../../../shared/status/status.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AsyncButton(
            text: 'Go to Profile',
            onClick: () async {
              await context.pushNamed(AppRoute.profile.name);
            },
          ),
          const StatusWidget(status: StatusType.todo),
          const StatusWidget(status: StatusType.inProgress),
          const StatusWidget(status: StatusType.done),
        ],
      ),
    );
  }
}
