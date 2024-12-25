import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

class ProjectPickerTileRenderer extends SearchRenderer {
  @override
  Widget render(BuildContext context, Searchable item) => Text(item.stringifiedValue);
}
