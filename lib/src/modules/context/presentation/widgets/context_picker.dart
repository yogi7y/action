import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/pickers/common_picker.dart';
import '../../../../shared/pickers/picker_item.dart';
import '../state/context_picker_provider.dart';
import '../view_models/context_view_model.dart';

class ContextPicker extends ConsumerWidget {
  const ContextPicker({
    required this.controller,
    required this.data,
    super.key,
  });

  final OverlayPortalController controller;

  /// [data] is all the props that are needed to be passed to the context picker
  final ContextPickerData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        contextPickerDataProvider.overrideWithValue(data),
        selectedContextPickerProvider.overrideWith((ref) => data.selectedContext),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          // Get the current query from the provider
          final query = ref.watch(contextPickerQueryProvider);

          // Get filtered contexts based on the query
          final filteredContexts = ref.watch(contextPickerResultsProvider(query));

          return CommonPicker(
            controller: controller,
            title: 'Search contexts...',
            items: filteredContexts,
            syncTextController: (controller, ref) {
              controller.syncWithContextPickerQuery(ref);
            },
            emptyStateWidget: const PickerEmptyState(
              message: 'No contexts found',
            ),
            itemBuilder: (context, index) {
              final contextViewModel = filteredContexts[index];
              return _ContextPickerItem(
                context: contextViewModel,
              );
            },
          );
        },
      ),
    );
  }
}

class _ContextPickerItem extends ConsumerWidget {
  const _ContextPickerItem({
    required this.context,
  });

  final ContextViewModel context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedContextPickerProvider) == this.context;

    // Find the parent widget to access the controller
    final pickerAncestor = context.findAncestorWidgetOfExactType<ContextPicker>();

    return PickerItem(
      title: this.context.context.name,
      icon: AppIcons.tagOutlined,
      isSelected: isSelected,
      onTap: () {
        ref.read(contextPickerDataProvider).onContextSelected(this.context);
        ref.read(selectedContextPickerProvider.notifier).state = this.context;

        // Hide the overlay on item selection
        pickerAncestor?.controller.hide();
      },
      onRemove: isSelected
          ? () {
              ref.read(contextPickerDataProvider).onRemove?.call(this.context);
              ref.read(selectedContextPickerProvider.notifier).state = null;
            }
          : null,
    );
  }
}
