import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';

/// @deprecated
/// Converter for ChipInput fields that store List<String> values.
///
/// **DEPRECATED:** This converter is no longer used as of v1.0.0.
/// ChipInput field now uses `List<FieldOption>` storage
/// with `ChipInputOptionConverters` instead of direct List<String> values.
///
/// This file is kept for backward compatibility but will be removed in a future version.
///
/// Migration: Use `ChipInputOptionConverters` instead.
///
/// This converter handles the conversion between List<String> values
/// and the various FormResults output formats.
///
/// Conversion Logic:
/// - asString: List<String> → comma-separated string
/// - asStringList: List<String> → List<String>
/// - asBool: non-empty list → true, empty/null → false
/// - asFile: Not supported (returns null)
@Deprecated('Use ChipInputOptionConverters instead. ChipInput field now stores List<FieldOption> values.')
class ChipInputConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is List<String>) {
          return value.join(', ');
        }
        if (value is List) {
          return value.map((e) => e.toString()).join(', ');
        }
        if (value == null) return "";
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is List<String>) {
          return value;
        }
        if (value is List) {
          return value.map((e) => e.toString()).toList();
        }
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is List) return value.isNotEmpty;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
