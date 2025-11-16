import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// WARNING: This field is currently bugged in the upstream library
/// This causes unforeseen behavior. Waiting for ShadCN_Flutter to issue a fix.
/// A custom field that displays a time picker widget.
///
/// Allows users to select a time using ShadCN Flutter's TimePicker component.
/// Supports both popover and dialog modes for time selection.
///
/// The field stores a FieldOption where:
/// - value: HH:mm string format
/// - label: HH:mm string format
/// - additionalData: shadcn.TimeOfDay object
///
/// ## Usage
///
/// ```dart
/// final timeField = ShadcnTimePickerField(
///   id: 'appointment_time',
///   title: 'Appointment Time',
///   description: 'Select a time for your appointment',
///   defaultValue: ShadcnTimePickerWidget.fromTimeOfDay(shadcn.TimeOfDay(hour: 9, minute: 0)),
/// );
/// ```
class ShadcnTimePickerField extends form.Field {
  @override
  final form.FieldOption? defaultValue;

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
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter =>
      null;
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
  const ShadcnTimePickerWidget({required super.context, super.key});

  // Helper method to extract TimeOfDay from FieldOption
  static shadcn.TimeOfDay? extractTimeOfDay(form.FieldOption? option) {
    return option?.additionalData as shadcn.TimeOfDay?;
  }

  // Helper method to create FieldOption from TimeOfDay
  static form.FieldOption fromTimeOfDay(shadcn.TimeOfDay time) {
    final hourStr = time.hour.toString().padLeft(2, '0');
    final minStr = time.minute.toString().padLeft(2, '0');
    final timeStr = '$hourStr:$minStr';
    return form.FieldOption(
      value: timeStr,
      label: timeStr,
      additionalData: time,
    );
  }

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final fieldOption = ctx.getValue<form.FieldOption?>();
    final value = extractTimeOfDay(fieldOption);

    return Column(
      key: ValueKey('timepicker_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shadcn.TimePicker(
          key: ValueKey('timepicker_${ctx.field.id}'),
          value: value,
          mode: shadcn.PromptMode.popover,
          onChanged: ctx.field.disabled
              ? null
              : (newValue) {
                  if (newValue != null) {
                    final option = fromTimeOfDay(newValue);
                    ctx.setValue<form.FieldOption?>(option);
                  }
                },
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
