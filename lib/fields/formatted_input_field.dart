import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays a formatted input widget with structured parts.
///
/// Useful for structured data entry like dates, times, credit cards, etc.
/// The field stores the formatted value as a concatenated string.
///
/// ## Usage
///
/// ```dart
/// final dateField = FormattedInputField(
///   id: 'date',
///   title: 'Date of Birth',
///   parts: [
///     shadcn.InputPart.editable(length: 2, width: 40, placeholder: Text('MM')),
///     shadcn.InputPart.static('/'),
///     shadcn.InputPart.editable(length: 2, width: 40, placeholder: Text('DD')),
///     shadcn.InputPart.static('/'),
///     shadcn.InputPart.editable(length: 4, width: 60, placeholder: Text('YYYY')),
///   ],
///   separator: '/',
/// );
/// ```
class FormattedInputField extends form.Field {
  /// The input parts that make up the formatted input.
  final List<shadcn.InputPart> parts;

  /// The separator used to join the values (default: '').
  final String separator;

  @override
  final String? defaultValue;

  // TextField parameters
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final List<shadcn.InputFeature>? features;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? readOnly;
  final bool? obscureText;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final int? maxLength;
  final bool? autofocus;
  final String? hintText;
  final shadcn.Border? border;
  final BorderRadiusGeometry? borderRadius;
  final bool? filled;

  FormattedInputField({
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
    required this.parts,
    this.separator = '',
    this.defaultValue,
    this.keyboardType,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.features,
    this.style,
    this.textAlign,
    this.readOnly,
    this.obscureText,
    this.autocorrect,
    this.enableSuggestions,
    this.maxLength,
    this.autofocus,
    this.hintText,
    this.border,
    this.borderRadius,
    this.filled,
  });

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults

  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is String) return value;
        if (value == null) return '';
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is String) return [value];
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is String) return value.isNotEmpty;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// ShadCN formatted input field for ChampionForms.
///
/// A text input field with formatted parts using ShadCN's FormattedInput component.
/// Useful for structured data entry like dates, times, credit cards, etc.
/// The field stores the formatted value as a concatenated string.
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'date',
///   title: 'Date of Birth',
///   fieldBuilder: (ctx) => ShadcnFormattedInputWidget(
///     context: ctx,
///     parts: [
///       shadcn.InputPart.editable(length: 2, width: 40, placeholder: Text('MM')),
///       shadcn.InputPart.static('/'),
///       shadcn.InputPart.editable(length: 2, width: 40, placeholder: Text('DD')),
///       shadcn.InputPart.static('/'),
///       shadcn.InputPart.editable(length: 4, width: 60, placeholder: Text('YYYY')),
///     ],
///   ),
/// )
/// ```
class ShadcnFormattedInputWidget extends form.StatefulFieldWidget {
  final List<shadcn.InputPart> parts;
  final String separator;

  const ShadcnFormattedInputWidget({
    required super.context,
    required this.parts,
    this.separator = '',
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Note: FormattedInput has limited customization. The field-level parameters
    // are defined for API consistency but are not currently used by the component.
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    final value = ctx.getValue<String>() ?? '';
    final initialValue = _parseValueToParts(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: shadcn.FormattedInput(
            key: ValueKey('formattedinput_${ctx.field.id}'),
            initialValue: initialValue,
            enabled: !ctx.field.disabled,
            onChanged: (formattedValue) {
              final stringValue = _formatValueToString(formattedValue);
              ctx.setValue(stringValue);
            },
            // Note: FormattedInput has limited customization parameters.
            // Most TextField parameters are not supported.
          ),
        ),
        if (ctx.field.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(ctx.field.description!, style: theme.hintTextStyle),
          ),
        if (hasError)
          ...errors.map((error) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error.reason,
                  style: TextStyle(
                    color: errorColors.textColor,
                    fontSize: 12,
                  ),
                ),
              )),
      ],
    );
  }

  /// Parse a string value into FormattedValue with parts
  shadcn.FormattedValue _parseValueToParts(String value) {
    if (value.isEmpty || parts.isEmpty) {
      return shadcn.FormattedValue(parts);
    }

    // For simplicity, if we have a separator, split by it
    // Otherwise, try to distribute the characters among editable parts
    List<String> valueParts = [];
    if (separator.isNotEmpty && value.contains(separator)) {
      valueParts = value.split(separator);
    } else {
      // Distribute characters based on part lengths
      int currentIndex = 0;
      for (var part in parts) {
        if (part is shadcn.EditablePart && currentIndex < value.length) {
          final partLength = part.length;
          final endIndex = (currentIndex + partLength).clamp(0, value.length);
          valueParts.add(value.substring(currentIndex, endIndex));
          currentIndex = endIndex;
        }
      }
    }

    // Create new parts with values
    final List<shadcn.FormattedValuePart> newParts = [];
    int valueIndex = 0;

    for (var part in parts) {
      if (part.canHaveValue) {
        if (valueIndex < valueParts.length) {
          newParts.add(part.withValue(valueParts[valueIndex]));
          valueIndex++;
        } else {
          newParts.add(shadcn.FormattedValuePart(part));
        }
      } else {
        newParts.add(shadcn.FormattedValuePart(part));
      }
    }

    return shadcn.FormattedValue(newParts);
  }

  /// Convert FormattedValue to a string
  String _formatValueToString(shadcn.FormattedValue formattedValue) {
    final List<String> values = [];
    for (var part in formattedValue.values) {
      if (part.value != null && part.value!.isNotEmpty) {
        values.add(part.value!);
      }
    }
    return values.join(separator);
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
