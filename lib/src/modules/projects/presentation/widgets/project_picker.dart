import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/pickers/common_picker.dart';
import '../../../../shared/pickers/picker_item.dart';
import '../state/project_picker_provider.dart';
import '../view_models/project_view_model.dart';

class ProjectPicker extends ConsumerWidget {
  const ProjectPicker({
    required this.controller,
    required this.data,
    super.key,
  });

  final OverlayPortalController controller;

  /// [data] is all the props that are needed to be passed to the project picker
  final ProjectPickerData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        projectPickerDataProvider.overrideWithValue(data),
        selectedProjectPickerProvider.overrideWith((ref) => data.selectedProject),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          // Get the current query from the provider
          final query = ref.watch(projectPickerQueryProvider);

          // Get filtered projects based on the query
          final filteredProjects = ref.watch(projectPickerResultsProvider(query));

          return CommonPicker(
            controller: controller,
            title: 'Search projects...',
            items: filteredProjects,
            syncTextController: (controller, ref) {
              controller.syncWithProjectPickerQuery(ref);
            },
            emptyStateWidget: const PickerEmptyState(
              message: 'No projects found',
            ),
            itemBuilder: (context, index) {
              final projectViewModel = filteredProjects[index];
              return _ProjectPickerItem(
                project: projectViewModel,
              );
            },
          );
        },
      ),
    );
  }
}

class _ProjectPickerItem extends ConsumerWidget {
  const _ProjectPickerItem({
    required this.project,
  });
  final ProjectViewModel project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedProjectPickerProvider) == project;

    // Find the parent widget to access the controller
    final pickerAncestor = context.findAncestorWidgetOfExactType<ProjectPicker>();

    return PickerItem(
      title: project.project.name,
      icon: AppIcons.hammerOutlined,
      isSelected: isSelected,
      onTap: () {
        ref.read(projectPickerDataProvider).onProjectSelected(project);
        ref.read(selectedProjectPickerProvider.notifier).state = project;

        // Hide the overlay on item selection
        pickerAncestor?.controller.hide();
      },
      onRemove: isSelected
          ? () {
              ref.read(projectPickerDataProvider).onRemove?.call(project);
              ref.read(selectedProjectPickerProvider.notifier).state = null;
            }
          : null,
    );
  }
}

class _ProjectResultContainer extends ConsumerWidget {
  const _ProjectResultContainer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing.md),
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.35,
      ),
      decoration: ShapeDecoration(
        color: colors.overlay.background,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 1),
          side: BorderSide(color: colors.overlay.borderStroke),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const _ProjectPickerResults(),
    );
  }
}

class _PickerTextField extends ConsumerWidget {
  const _PickerTextField({
    required TextEditingController textController,
    required FocusNode focusNode,
  })  : _textController = textController,
        _focusNode = focusNode;

  final TextEditingController _textController;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return GestureDetector(
      // Prevent taps on TextField from closing the overlay
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.sm),
        child: TextField(
          autofocus: true,
          controller: _textController,
          focusNode: _focusNode,
          style: fonts.text.md.regular.copyWith(
            color: colors.textTokens.primary,
          ),
          decoration: InputDecoration(
            hintText: 'Search projects...',
            hintStyle: fonts.text.md.regular.copyWith(
              color: colors.textTokens.secondary,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                AppIcons.search,
                size: 20,
                color: colors.textTokens.secondary,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.overlay.borderStroke,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.overlay.borderStroke,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.overlay.borderStroke,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            filled: true,
            fillColor: colors.surface.backgroundContrast,
          ),
        ),
      ),
    );
  }
}

/// Results list for the project picker that uses the providers
class _ProjectPickerResults extends ConsumerWidget {
  const _ProjectPickerResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current query from the provider
    final query = ref.watch(projectPickerQueryProvider);

    // Get filtered projects based on the query
    final filteredProjects = ref.watch(projectPickerResultsProvider(query));

    if (filteredProjects.isEmpty) {
      return const ProjectPickerEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final projectViewModel = filteredProjects[index];
        return ProjectPickerItem(
          project: projectViewModel,
        );
      },
    );
  }
}

class ProjectPickerItem extends ConsumerWidget {
  const ProjectPickerItem({
    required this.project,
    super.key,
  });
  final ProjectViewModel project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    final isSelected = ref.watch(selectedProjectPickerProvider) == project;

    // Find the parent widget to access the controller
    final pickerAncestor = context.findAncestorWidgetOfExactType<ProjectPicker>();

    return InkWell(
      onTap: () {
        ref.read(projectPickerDataProvider).onProjectSelected(project);
        ref.read(selectedProjectPickerProvider.notifier).state = project;

        // Hide the overlay on item selection
        pickerAncestor?.controller.hide();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.overlay.borderStroke.withValues(alpha: .3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              AppIcons.hammerOutlined,
              size: 20,
              color: colors.textTokens.secondary,
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(
                project.project.name,
                style: fonts.text.sm.medium.copyWith(
                  color: colors.textTokens.primary,
                ),
              ),
            ),
            if (isSelected)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ref.read(projectPickerDataProvider).onRemove?.call(project);
                  ref.read(selectedProjectPickerProvider.notifier).state = null;
                },
                child: Icon(
                  AppIcons.xmark,
                  size: 20,
                  color: colors.textTokens.tertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Empty state widget for project picker with consistent styling
class ProjectPickerEmptyState extends ConsumerWidget {
  const ProjectPickerEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Text(
          'No projects found',
          style: fonts.text.md.regular.copyWith(
            color: colors.textTokens.secondary,
          ),
        ),
      ),
    );
  }
}
