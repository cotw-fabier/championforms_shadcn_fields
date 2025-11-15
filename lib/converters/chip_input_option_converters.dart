import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';

/// Converter for ChipInput fields that store List<FieldOption> values.
///
/// This converter handles the conversion between List<FieldOption> values
/// and the various FormResults output formats.
///
/// Conversion Logic:
/// - asString: List<FieldOption> → comma-separated labels
/// - asStringList: List<FieldOption> → List<value strings>
/// - asBool: non-empty list → true, empty/null → false
/// - asFile: Not supported (returns null)
class ChipInputOptionConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is List<form.FieldOption>) {
          return value.map((opt) => opt.label).join(', ');
        }
        if (value is List) {
          // Fallback for mixed lists
          return value
              .map((e) => e is form.FieldOption ? e.label : e.toString())
              .join(', ');
        }
        if (value == null) return "";
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is List<form.FieldOption>) {
          return value.map((opt) => opt.value).toList();
        }
        if (value is List) {
          // Fallback for mixed lists
          return value
              .map((e) => e is form.FieldOption ? e.value : e.toString())
              .toList();
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

  /// Helper method to create a FieldOption from a chip string value.
  ///
  /// If no label is provided, uses the value as the label.
  static form.FieldOption fromChipValue(
    String value, {
    String? label,
    Object? additionalData,
  }) {
    return form.FieldOption(
      value: value,
      label: label ?? value,
      additionalData: additionalData,
    );
  }
}
