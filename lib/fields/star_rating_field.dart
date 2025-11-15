import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:championforms/models/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import '../converters/star_rating_option_converters.dart';

/// Field definition for ShadCN Star Rating.
///
/// A custom field that displays a star rating widget. The field stores a
/// FieldOption where:
/// - value: numeric string (e.g., "4.5", "3.0")
/// - label: rating category/description (e.g., "4.5 - Excellent", "3.0 - Good")
/// - additionalData: the actual double rating value
///
/// ## Usage
///
/// ```dart
/// final ratingField = ShadcnStarRatingField(
///   id: 'satisfaction',
///   title: 'How satisfied are you?',
///   description: 'Rate from 1 to 5 stars',
///   defaultValue: StarRatingOptionConverters.fromRating(3.5),
///   validators: [
///     form.Validator(
///       validator: (results) {
///         final option = results.getAsRaw<form.FieldOption>('satisfaction');
///         final rating = StarRatingOptionConverters.extractRating(option) ?? 0;
///         return rating >= 3.0;
///       },
///       reason: 'Please rate at least 3 stars',
///     ),
///   ],
/// );
/// ```
///
/// ## Accessing Values
///
/// ```dart
/// // Get the FieldOption
/// final option = results.getAsRaw<form.FieldOption>('satisfaction');
///
/// // Extract the double rating
/// final rating = StarRatingOptionConverters.extractRating(option);
///
/// // Get the numeric string
/// final ratingStr = results.grab('satisfaction').asString();
///
/// // Check if rating exists
/// final hasRating = results.grab('satisfaction').asBool();
/// ```
class ShadcnStarRatingField extends form.Field {
  @override
  final form.FieldOption? defaultValue;

  ShadcnStarRatingField({
    required super.id,
    super.title,
    super.description,
    super.disabled = false,
    super.hideField = false,
    super.requestFocus = false,
    super.validators,
    super.validateLive = false,
    super.onSubmit,
    super.onChange,
    super.theme,
    super.fieldLayout,
    super.fieldBackground,
    this.defaultValue,
  });

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults

  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is form.FieldOption) return value.value;
        if (value == null) return '';
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
}

/// Star rating field using ShadCN Flutter's StarRating component.
///
/// Displays an interactive star rating widget that allows users to select
/// a rating value (supports fractional values like 1.5 for half-stars).
///
/// Value type: `FieldOption` (with double rating in additionalData)
/// Converter: `StarRatingOptionConverters`
///
/// Example:
/// ```dart
/// form.Field(
///   id: 'satisfaction',
///   title: 'How satisfied are you?',
///   description: 'Rate from 1 to 5 stars',
///   fieldBuilder: (ctx) => ShadcnStarRatingWidget(context: ctx),
/// )
/// ```
class ShadcnStarRatingWidget extends form.StatefulFieldWidget {
  const ShadcnStarRatingWidget({required super.context});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get current field option and extract rating from additionalData
    final fieldOption = ctx.getValue<form.FieldOption?>();
    final value = StarRatingOptionConverters.extractRating(fieldOption) ?? 0.0;

    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (if present)
        if (ctx.field.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              ctx.field.title!,
              style: theme.titleStyle?.copyWith(
                color: hasError ? errorColors.titleColor : null,
              ),
            ),
          ),

        // Star Rating Widget
        Container(
          decoration: BoxDecoration(
            border: hasError
                ? Border.all(
                    color: errorColors.borderColor,
                    width: errorColors.borderSize.toDouble(),
                  )
                : null,
            borderRadius: hasError ? errorColors.borderRadius : null,
          ),
          child: shadcn.StarRating(
            key: ValueKey('starrating_${ctx.field.id}'),
            value: value,
            onChanged: (newValue) {
              // Wrap rating in FieldOption with generated label
              final option = StarRatingOptionConverters.fromRating(newValue);
              ctx.setValue<form.FieldOption?>(option);
            },
            starSize: 32,
          ),
        ),

        // Description (if present)
        if (ctx.field.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(ctx.field.description!, style: theme.hintTextStyle),
          ),

        // Error messages
        if (hasError)
          ...errors.map((error) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error.reason,
                  style: TextStyle(
                    color: errorColors.textColor,
                    fontSize: 12.0,
                  ),
                ),
              )),
      ],
    );
  }

  @override
  void onValueChanged(dynamic oldValue, dynamic newValue) {
    if (context.field.onChange != null) {
      final results = form.FormResults.getResults(controller: context.controller);
      context.field.onChange!(results);
    }
  }
}
