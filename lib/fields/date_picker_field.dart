import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/themes.dart';
import 'package:championforms/models/field_types/formfieldclass.dart';
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays a date picker widget.
///
/// Allows users to select a date using ShadCN Flutter's DatePicker component.
/// Supports both popover and dialog modes for date selection.
///
/// Value type: `DateTime`
/// Converter: `DateTimeConverters` (ISO 8601 string format)
///
/// ## Usage
///
/// ```dart
/// final dateField = ShadcnDatePickerField(
///   id: 'birthdate',
///   title: 'Date of Birth',
///   description: 'Select your birth date',
///   defaultValue: DateTime.now(),
///   validators: [
///     form.Validator(
///       validator: (results) {
///         final date = results.getAsRaw<DateTime>('birthdate');
///         return date != null && date.isBefore(DateTime.now());
///       },
///       reason: 'Birth date must be in the past',
///     ),
///   ],
/// );
/// ```
class ShadcnDatePickerField extends Field {
  @override
  final DateTime? defaultValue;

  ShadcnDatePickerField({
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
        if (value is DateTime) return value.toIso8601String();
        if (value == null) return '';
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is DateTime) return [value.toIso8601String()];
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is DateTime) return true;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// Date picker field using ShadCN Flutter's DatePicker component.
///
/// Displays a date picker that allows users to select a date.
/// Supports both popover and dialog modes.
///
/// Value type: `DateTime`
/// Converter: `DateTimeConverters`
///
/// Example:
/// ```dart
/// form.Field(
///   id: 'birthdate',
///   title: 'Date of Birth',
///   description: 'Select your birth date',
///   fieldBuilder: (ctx) => ShadcnDatePickerWidget(context: ctx),
/// )
/// ```
class ShadcnDatePickerWidget extends form.StatefulFieldWidget {
  const ShadcnDatePickerWidget({super.key, required super.context});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final value = ctx.getValue<DateTime>();
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

        // Date Picker Widget
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
          child: shadcn.DatePicker(
            key: ValueKey('datepicker_${ctx.field.id}'),
            value: value,
            mode: shadcn.PromptMode.popover,
            onChanged: (newValue) {
              if (newValue != null) {
                ctx.setValue<DateTime>(newValue);
              }
            },
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
      final results = form.FormResults.getResults(
        controller: context.controller,
      );
      context.field.onChange!(results);
    }
  }
}
