import 'package:flutter/material.dart' as material;
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';

/// Converter for Color field values.
///
/// Converts Color objects to string representations (hex format) and boolean
/// values indicating whether a color is set.
///
/// Conversion Logic:
/// - asString: Color → hex string (#RRGGBB or #AARRGGBB), null → ""
/// - asStringList: Color → [hex string], null → []
/// - asBool: Color → true, null → false
/// - asFile: Not supported (returns null)
class ColorConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is material.Color) {
          // Convert Color to hex string with alpha if not fully opaque
          final alpha = (value.a * 255.0).round().clamp(0, 255);
          final red = (value.r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
          final green = (value.g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
          final blue = (value.b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');

          if (alpha == 255) {
            // Fully opaque - use #RRGGBB format
            return '#$red$green$blue';
          } else {
            // Has transparency - use #AARRGGBB format
            final alphaHex = alpha.toRadixString(16).padLeft(2, '0');
            return '#$alphaHex$red$green$blue';
          }
        }
        if (value == null) return "";
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is material.Color) {
          final hexString = asStringConverter(value);
          return [hexString];
        }
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is material.Color) return true;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
