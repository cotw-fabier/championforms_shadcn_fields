import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';

/// Converters for Star Rating field that stores rating double in FieldOption.additionalData.
///
/// The FieldOption structure for star ratings:
/// - value: numeric string (e.g., "4.5", "3.0")
/// - label: rating category/description (e.g., "4.5 - Excellent", "3.0 - Good")
/// - additionalData: the actual double rating value for direct access
class StarRatingOptionConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is form.FieldOption) {
          // Return the numeric string from value field
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

  /// Extract the double rating value from FieldOption.additionalData.
  ///
  /// Returns null if value is not a FieldOption or if additionalData
  /// doesn't contain a double.
  static double? extractRating(dynamic value) {
    if (value is form.FieldOption) {
      if (value.additionalData is double) {
        return value.additionalData as double;
      }
      // Try parsing from value string as fallback
      try {
        return double.parse(value.value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Create a FieldOption from a rating double.
  ///
  /// Stores the rating in additionalData and generates a string representation.
  /// If no label is provided, generates a label with rating category.
  static form.FieldOption fromRating(
    double rating, {
    String? label,
  }) {
    final String defaultLabel = _getRatingLabel(rating);
    return form.FieldOption(
      value: rating.toString(),
      label: label ?? defaultLabel,
      additionalData: rating,
    );
  }

  /// Generate a descriptive label based on rating value.
  static String _getRatingLabel(double rating) {
    final String category;
    if (rating >= 4.5) {
      category = 'Excellent';
    } else if (rating >= 3.5) {
      category = 'Very Good';
    } else if (rating >= 2.5) {
      category = 'Good';
    } else if (rating >= 1.5) {
      category = 'Fair';
    } else {
      category = 'Poor';
    }
    return '$rating - $category';
  }
}
