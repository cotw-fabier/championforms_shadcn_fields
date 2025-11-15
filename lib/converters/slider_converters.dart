import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// Converter for Slider fields that store SliderValue values.
///
/// This converter handles the conversion between SliderValue (single or range)
/// and the various FormResults output formats.
///
/// Conversion Logic:
/// - asString: SliderValue → string representation ("value" or "start-end")
/// - asStringList: SliderValue → List<String> of values
/// - asBool: SliderValue → true (always true if value exists)
/// - asFile: Not supported (returns null)
class SliderConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is shadcn.SliderValue) {
          if (value.isRanged) {
            return '${value.start}-${value.end}';
          } else {
            return value.value.toString();
          }
        }
        if (value == null) return "";
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is shadcn.SliderValue) {
          if (value.isRanged) {
            return [value.start.toString(), value.end.toString()];
          } else {
            return [value.value.toString()];
          }
        }
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is shadcn.SliderValue) return true;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
