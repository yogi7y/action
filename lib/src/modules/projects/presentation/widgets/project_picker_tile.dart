// ignore_for_file: public_member_api_docs, sort_constructors_first

// class ProjectPickerTileRenderer extends SearchRenderer<ProjectEntity> {
//   ProjectPickerTileRenderer({
//     required this.fonts,
//   });

//   final Fonts fonts;

//   @override
//   Widget render(BuildContext context, ProjectEntity item) {
//     return Text(
//       item.stringifiedValue,
//       style: fonts.text.sm.medium,
//     );
//   }

//   @override
//   void onItemSelected(BuildContext context, ProjectEntity item) {
//     final _container = ProviderScope.containerOf(context);
//     _container.read(newTaskProvider.notifier).focusNode.requestFocus();
//     _container.read(currentStickyTextFieldTypeProvider.notifier).update((_) => null);

//     _container.read(newTaskProvider.notifier).updateValue(projectId: item.id);
//   }
// }
