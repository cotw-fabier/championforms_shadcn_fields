import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';

/// Converter for DateTime values to ChampionForms field types.
///
/// Handles conversion of DateTime objects to:
/// - String (ISO 8601 format)
/// - List of String (single-element list)
/// - bool (true if DateTime exists, false if null)
///
/// Used by: Date Picker field
class DateTimeConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is DateTime) return value.toIso8601String();
        if (value == null) return "";
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is DateTime) return [value.toIso8601String()];
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is DateTime) return true;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
