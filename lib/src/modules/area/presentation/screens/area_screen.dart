import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/typography/typography.dart';

@RoutePage()
class AreaScreen extends ConsumerWidget {
  const AreaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _fonts = ref.watch(fontsProvider);
    return Center(
      child: Text(
        'Area',
        style: _fonts.headline.md.semibold,
      ),
    );
  }
}
