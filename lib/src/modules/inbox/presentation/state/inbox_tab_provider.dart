import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InboxTab {
  tasks,
  pages,
}

final inboxTabProvider = StateProvider<InboxTab>((ref) => InboxTab.tasks);
