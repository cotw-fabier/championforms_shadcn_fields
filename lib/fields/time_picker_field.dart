import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/themes.dart';
import 'package:championforms/models/field_types/formfieldclass.dart';
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays a time picker widget.
///
/// Allows users to select a time using ShadCN Flutter's TimePicker component.
/// Supports both popover and dialog modes for time selection.
///
/// Value type: `shadcn.TimeOfDay` (from shadcn_flutter package)
/// Converter: `TimeConverters` (HH:mm string format)
///
/// ## Usage
///
/// ```dart
/// final timeField = ShadcnTimePickerField(
///   id: 'appointment_time',
///   title: 'Appointment Time',
///   description: 'Select a time for your appointment',
///   defaultValue: shadcn.TimeOfDay(hour: 9, minute: 0),
///   validators: [
///     form.Validator(
///       validator: (results) {
///         final time = results.getAsRaw<shadcn.TimeOfDay>('appointment_time');
///         return time != null && time.hour >= 9 && time.hour < 17;
///       },
///       reason: 'Appointment must be between 9 AM and 5 PM',
///     ),
///   ],
/// );
/// ```
class ShadcnTimePickerField extends Field {
  @override
  final shadcn.TimeOfDay? defaultValue;

  ShadcnTimePickerField({
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
        if (value is shadcn.TimeOfDay) {
          return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
        }
        if (value == null) return '';
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is shadcn.TimeOfDay) {
          return ['${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}'];
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

/// Time picker field using ShadCN Flutter's TimePicker component.
///
/// Displays a time picker that allows users to select a time.
/// Supports both popover and dialog modes.
///
/// Value type: `shadcn.TimeOfDay` (from shadcn_flutter package)
/// Converter: `TimeConverters`
///
/// Example:
/// ```dart
/// form.Field(
///   id: 'appointment_time',
///   title: 'Appointment Time',
///   description: 'Select a time for your appointment',
///   fieldBuilder: (ctx) => ShadcnTimePickerWidget(context: ctx),
/// )
/// ```
class ShadcnTimePickerWidget extends form.StatefulFieldWidget {
  const ShadcnTimePickerWidget({required super.context});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final value = ctx.getValue<shadcn.TimeOfDay>() ?? shadcn.TimeOfDay.now();
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

        // Time Picker Widget
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
          child: shadcn.TimePicker(
            key: ValueKey('timepicker_${ctx.field.id}'),
            value: value,
            mode: shadcn.PromptMode.popover,
            onChanged: (newValue) {
              // Update the time value
              if (newValue != null) {
                ctx.setValue<shadcn.TimeOfDay>(newValue);
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
      final results = form.FormResults.getResults(controller: context.controller);
      context.field.onChange!(results);
    }
  }
}
