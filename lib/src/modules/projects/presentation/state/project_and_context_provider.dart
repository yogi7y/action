import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProjectAndContext {
  project._(0),
  context._(1);

  const ProjectAndContext._(this.indexValue);

  factory ProjectAndContext.fromIndex(int index) => ProjectAndContext.values.firstWhere(
        (element) => element.indexValue == index,
        orElse: () => ProjectAndContext.project,
      );
  final int indexValue;
}

/// To decide the current selected tab.
final projectAndContextProvider =
    StateProvider<ProjectAndContext>((ref) => ProjectAndContext.project);
