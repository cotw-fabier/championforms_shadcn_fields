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
/// final ratingField = StarRatingField(
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
class StarRatingField extends form.Field {
  @override
  final form.FieldOption? defaultValue;

  /// Maximum rating value (default: 5.0)
  final double? max;

  /// Minimum increment for rating changes (default: 0.5, use 1.0 for whole stars only)
  final double? step;

  /// Star fill color
  final Color? activeColor;

  /// Empty star color
  final Color? backgroundColor;

  /// Star icon size
  final double? starSize;

  /// Spacing between stars
  final double? starSpacing;

  StarRatingField({
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
    this.max,
    this.step,
    this.activeColor,
    this.backgroundColor,
    this.starSize,
    this.starSpacing,
  });

  @override
  StarRatingField copyWith({
    String? id,
    Widget? icon,
    String? title,
    String? description,
    bool? disabled,
    bool? hideField,
    bool? requestFocus,
    List<form.Validator>? validators,
    bool? validateLive,
    Function(form.FormResults)? onSubmit,
    Function(form.FormResults)? onChange,
    form.FormTheme? theme,
    Widget Function(
      BuildContext,
      form.Field,
      form.FormController,
      form.FieldColorScheme,
      Widget,
    )? fieldLayout,
    Widget Function(
      BuildContext,
      form.Field,
      form.FormController,
      form.FieldColorScheme,
      Widget,
    )? fieldBackground,
    form.FieldOption? defaultValue,
    double? max,
    double? step,
    Color? activeColor,
    Color? backgroundColor,
    double? starSize,
    double? starSpacing,
  }) {
    return StarRatingField(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      disabled: disabled ?? this.disabled,
      hideField: hideField ?? this.hideField,
      requestFocus: requestFocus ?? this.requestFocus,
      validators: validators ?? this.validators,
      validateLive: validateLive ?? this.validateLive,
      onSubmit: onSubmit ?? this.onSubmit,
      onChange: onChange ?? this.onChange,
      theme: theme ?? this.theme,
      fieldLayout: fieldLayout ?? this.fieldLayout,
      fieldBackground: fieldBackground ?? this.fieldBackground,
      defaultValue: defaultValue ?? this.defaultValue,
      max: max ?? this.max,
      step: step ?? this.step,
      activeColor: activeColor ?? this.activeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      starSize: starSize ?? this.starSize,
      starSpacing: starSpacing ?? this.starSpacing,
    );
  }

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

    // Cast to StarRatingField to access custom properties
    final field = ctx.field as StarRatingField;

    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            onChanged: ctx.field.disabled
                ? null
                : (newValue) {
                    // Wrap rating in FieldOption with generated label
                    final option = StarRatingOptionConverters.fromRating(newValue);
                    ctx.setValue<form.FieldOption?>(option);
                  },
            max: field.max ?? 5.0,
            step: field.step ?? 0.5,
            activeColor: field.activeColor,
            backgroundColor: field.backgroundColor,
            starSize: field.starSize,
            starSpacing: field.starSpacing,
          ),
        ),
      ],
    );
  }

  @override
  void onValueChanged(dynamic oldValue, dynamic newValue) {
    if (context.field.onChange != null) {
      final results = form.FormResults.getResults(
        controller: context.controller,
      );
      context.field.onChange!(results);
    }
  }
}
