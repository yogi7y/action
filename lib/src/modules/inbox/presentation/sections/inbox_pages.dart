import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/strings.dart';
import '../../../../design_system/design_system.dart';

class InboxPages extends ConsumerWidget {
  const InboxPages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              AppStrings.last24HoursTitle,
              style: fonts.headline.sm.semibold,
            ),
          ),
          SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const Placeholder(fallbackHeight: 40);
            },
          ),
          SliverToBoxAdapter(
            child: Text(
              AppStrings.unorganisedTitle,
              style: fonts.headline.sm.semibold,
            ),
          ),
          SliverList.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return const Placeholder(fallbackHeight: 40);
            },
          ),
        ],
      ),
    );
  }
}
