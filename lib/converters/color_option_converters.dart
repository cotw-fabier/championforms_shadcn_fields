import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:flutter/material.dart';

/// Converters for Color Picker field that stores Color in FieldOption.additionalData.
///
/// The FieldOption structure for colors:
/// - value: hex string (#RRGGBB or #AARRGGBB)
/// - label: color name/description (e.g., "Primary Blue", "Success Green")
/// - additionalData: the actual Color object for direct access
class ColorOptionConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is form.FieldOption) {
          // Return the hex string from value field
          return value.value;
        }
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
        if (value is form.FieldOption) return true;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;

  /// Extract the Color object from FieldOption.additionalData.
  ///
  /// Returns null if value is not a FieldOption or if additionalData
  /// doesn't contain a Color object.
  static Color? extractColor(dynamic value) {
    if (value is form.FieldOption && value.additionalData is Color) {
      return value.additionalData as Color;
    }
    return null;
  }

  /// Create a FieldOption from a Color object.
  ///
  /// Generates a hex string for the value and stores the Color in additionalData.
  /// If no label is provided, generates a label from the hex value.
  static form.FieldOption fromColor(
    Color color, {
    String? label,
  }) {
    // Use toARGB32() instead of deprecated .value property
    final argb = color.toARGB32();
    final hexValue = '#${argb.toRadixString(16).padLeft(8, '0').substring(2)}';
    return form.FieldOption(
      value: hexValue,
      label: label ?? hexValue,
      additionalData: color,
    );
  }
}
