import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// Converter for ShadCN TimeOfDay values to ChampionForms field types.
///
/// Handles conversion of shadcn.TimeOfDay objects to:
/// - String (HH:mm format)
/// - List of String (single-element list)
/// - bool (true if TimeOfDay exists, false if null)
///
/// Used by: Time Picker field
class TimeConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is shadcn.TimeOfDay) {
          final hour = value.hour.toString().padLeft(2, '0');
          final minute = value.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        if (value == null) return "";
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is shadcn.TimeOfDay) {
          final hour = value.hour.toString().padLeft(2, '0');
          final minute = value.minute.toString().padLeft(2, '0');
          return ['$hour:$minute'];
        }
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is shadcn.TimeOfDay) return true;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
