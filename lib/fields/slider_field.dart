import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/colorscheme.dart';
import 'package:championforms/models/file_model.dart';
import 'package:championforms/models/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// Field definition for slider input.
///
/// This field provides a slider for selecting numeric values (single or range).
///
/// Value Type: shadcn.SliderValue (single or range)
/// Converter: SliderConverters (custom)
///
/// Example (single value):
/// ```dart
/// SliderField(
///   id: 'volume',
///   title: 'Volume',
///   min: 0.0,
///   max: 100.0,
///   divisions: 100,
///   initialValue: 50.0,
/// )
/// ```
///
/// Example (range):
/// ```dart
/// SliderField(
///   id: 'price_range',
///   title: 'Price Range',
///   min: 0.0,
///   max: 1000.0,
///   isRange: true,
///   initialRange: [100.0, 500.0],
/// )
/// ```
class SliderField extends form.Field {
  /// Minimum value of the slider.
  final double min;

  /// Maximum value of the slider.
  final double max;

  /// Number of discrete divisions (null for continuous).
  final int? divisions;

  /// Whether to show the current value label.
  final bool showLabel;

  /// Whether this is a range slider (two thumbs).
  final bool isRange;

  /// Initial value for single-value slider.
  final double? initialValue;

  /// Initial range for range slider [start, end].
  final List<double>? initialRange;

  @override
  final shadcn.SliderValue? defaultValue;

  SliderField({
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
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.showLabel = true,
    this.isRange = false,
    this.initialValue,
    this.initialRange,
    this.defaultValue,
  });

  @override
  SliderField copyWith({
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
      FieldColorScheme,
      Widget,
    )? fieldLayout,
    Widget Function(
      BuildContext,
      form.Field,
      form.FormController,
      FieldColorScheme,
      Widget,
    )? fieldBackground,
    double? min,
    double? max,
    int? divisions,
    bool? showLabel,
    bool? isRange,
    double? initialValue,
    List<double>? initialRange,
    shadcn.SliderValue? defaultValue,
  }) {
    return SliderField(
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
      min: min ?? this.min,
      max: max ?? this.max,
      divisions: divisions ?? this.divisions,
      showLabel: showLabel ?? this.showLabel,
      isRange: isRange ?? this.isRange,
      initialValue: initialValue ?? this.initialValue,
      initialRange: initialRange ?? this.initialRange,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults

  @override
  String Function(dynamic value) get asStringConverter => (value) {
    if (value is shadcn.SliderValue) {
      if (value.isRanged) {
        return '${value.start}-${value.end}';
      } else {
        return value.value.toString();
      }
    }
    if (value == null) return '';
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
    if (value is shadcn.SliderValue) return value.value != 0;
    if (value == null) return false;
    throw TypeError();
  };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// Slider field using ShadCN Flutter's Slider widget.
///
/// This field provides a slider for selecting numeric values.
/// Value Type: SliderValue (single or range)
/// Converter: SliderConverters (custom)
///
/// Example (single value):
/// ```dart
/// form.TextField(
///   id: 'volume',
///   title: 'Volume',
///   fieldBuilder: (ctx) => ShadcnSliderWidget(
///     context: ctx,
///     min: 0,
///     max: 100,
///     divisions: 100,
///     initialValue: 50,
///   ),
/// )
/// ```
///
/// Example (range):
/// ```dart
/// form.TextField(
///   id: 'price_range',
///   title: 'Price Range',
///   fieldBuilder: (ctx) => ShadcnSliderWidget(
///     context: ctx,
///     min: 0,
///     max: 1000,
///     isRange: true,
///     initialRange: [100, 500],
///   ),
/// )
/// ```
class ShadcnSliderWidget extends form.StatefulFieldWidget {
  final double min;
  final double max;
  final int? divisions;
  final bool showLabel;
  final bool isRange;
  final double? initialValue;
  final List<double>? initialRange;

  const ShadcnSliderWidget({
    required super.context,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.showLabel = true,
    this.isRange = false,
    this.initialValue,
    this.initialRange,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get field from SliderField
    final field = ctx.field as SliderField;

    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    // Get current value or use default
    final currentValue = ctx.getValue<shadcn.SliderValue>();
    final shadcn.SliderValue value;

    if (currentValue != null) {
      value = currentValue;
    } else {
      // Use initialValue/initialRange or default
      if (field.isRange) {
        if (field.initialRange != null && field.initialRange!.length == 2) {
          value = shadcn.SliderValue.ranged(field.initialRange![0], field.initialRange![1]);
        } else {
          value = shadcn.SliderValue.ranged(
            field.min + (field.max - field.min) * 0.25,
            field.min + (field.max - field.min) * 0.75,
          );
        }
      } else {
        if (field.initialValue != null) {
          value = shadcn.SliderValue.single(field.initialValue!);
        } else {
          value = shadcn.SliderValue.single(field.min + (field.max - field.min) * 0.5);
        }
      }
      // Set initial value
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctx.setValue<shadcn.SliderValue>(value);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Value display (if showLabel is true)
        if (field.showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _formatValue(value, field.min, field.max),
              style: theme.hintTextStyle,
            ),
          ),

        // Slider
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
          child: shadcn.Slider(
            key: ValueKey('slider_${ctx.field.id}'),
            value: value,
            min: field.min,
            max: field.max,
            divisions: field.divisions,
            onChanged: (newValue) {
              ctx.setValue<shadcn.SliderValue>(newValue);
            },
          ),
        ),
      ],
    );
  }

  String _formatValue(shadcn.SliderValue value, double min, double max) {
    if (value.isRanged) {
      // Scale values to min-max range
      final scaledStart = min + (value.start * (max - min));
      final scaledEnd = min + (value.end * (max - min));
      return 'Range: ${scaledStart.toStringAsFixed(2)} - ${scaledEnd.toStringAsFixed(2)}';
    } else {
      // Scale value to min-max range
      final scaledValue = min + (value.value * (max - min));
      return 'Value: ${scaledValue.toStringAsFixed(2)}';
    }
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
