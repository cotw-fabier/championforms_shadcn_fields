import 'package:championforms/championforms.dart' as form;

/// @deprecated
/// Converters for boolean fields (Checkbox, Switch, Toggle).
///
/// **DEPRECATED:** This converter is no longer used as of v1.0.0.
/// Boolean fields (Checkbox, Switch, Toggle) now use `FieldOption` storage
/// with `OptionSelectConverters` instead of direct bool values.
///
/// This file is kept for backward compatibility but will be removed in a future version.
///
/// Migration: Use `OptionSelectConverters` instead.
///
/// Handles conversion between bool values and the string/list representations
/// used by ChampionForms.
@Deprecated('Use OptionSelectConverters instead. Boolean fields now store FieldOption values.')
class BoolFieldConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is bool) return value.toString();
        if (value == null) return "false";
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is bool) return [value.toString()];
        if (value == null) return ["false"];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is bool) return value;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
