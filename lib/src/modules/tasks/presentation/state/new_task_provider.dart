import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

final isTaskTextInputFieldVisibleProvider = StateProvider<bool>((ref) => false);

/// holds the task entered by the user.
final newTaskTextProvider = NotifierProvider<NewTaskTextNotifier, String>(NewTaskTextNotifier.new);

class NewTaskTextNotifier extends Notifier<String> {
  late final controller = SmartTextFieldController();

  @override
  String build() {
    _syncControllerAndState();
    return '';
  }

  void _syncControllerAndState() => controller.addListener(() {
        state = controller.text;
      });

  void clear() => controller.clear();

  void updateText(String text) => controller.text = text;
}
