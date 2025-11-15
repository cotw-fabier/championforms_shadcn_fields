import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';

/// Converters for fields that store a single FieldOption value.
///
/// Handles conversion between FieldOption values and string/list/bool representations.
/// Used by: Radio Group, Radio Card, Select, Item Picker, Checkbox, Switch, Toggle
class OptionSelectConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
    if (value is form.FieldOption) return value.value;
    if (value == null) return "";
    throw TypeError();
  };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
    if (value is form.FieldOption) return [value.value];
    if (value == null) return [];
    throw TypeError();
  };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
    if (value is List<form.FieldOption>) return value.isNotEmpty;
    if (value == null) return false;
    throw TypeError();
  };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
