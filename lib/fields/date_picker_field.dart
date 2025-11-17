import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:intl/intl.dart';

/// WARNING: This field is currently bugged in the upstream library
/// This causes unforeseen behavior. Waiting for ShadCN_Flutter to issue a fix.
/// A custom field that displays a date picker widget.
///
/// Allows users to select a date or date range using ShadCN Flutter's DatePicker
/// or DateRangePicker component.
///
/// The field stores a FieldOption where:
/// - For single date: value = ISO 8601 string, additionalData = DateTime
/// - For date range: value = "start ISO / end ISO", additionalData = shadcn.DateTimeRange
///
/// ## Usage
///
/// ```dart
/// // Single date picker
/// final dateField = DatePickerField(
///   id: 'birthdate',
///   title: 'Date of Birth',
///   description: 'Select your birth date',
///   isRangeSelector: false,
///   defaultValue: ShadcnDatePickerWidget.fromDateTime(DateTime.now()),
/// );
///
/// // Date range picker
/// final rangeField = DatePickerField(
///   id: 'event_dates',
///   title: 'Event Dates',
///   isRangeSelector: true,
///   defaultValue: null,
/// );
/// ```
class DatePickerField extends form.Field {
  /// Whether this picker selects a date range (true) or single date (false)
  final bool isRangeSelector;

  /// Popover vs dialog mode for the picker
  final shadcn.PromptMode? mode;

  /// Custom placeholder widget shown when no date is selected
  final Widget? placeholder;

  /// Initial calendar view period (month, year, decade)
  final shadcn.CalendarView? initialView;

  /// Popup alignment relative to the trigger
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for the popup
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Internal padding for the popover
  final EdgeInsetsGeometry? popoverPadding;

  /// Dialog title widget (for dialog mode)
  final Widget? dialogTitle;

  /// Calendar layout style (grid, list, compact)
  final shadcn.CalendarViewType? initialViewType;

  /// Custom date cell state builder
  final shadcn.DateStateBuilder? stateBuilder;

  @override
  final form.FieldOption? defaultValue;

  DatePickerField({
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
    this.isRangeSelector = false,
    this.mode,
    this.placeholder,
    this.initialView,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.initialViewType,
    this.stateBuilder,
    this.defaultValue,
  });

  @override
  DatePickerField copyWith({
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
    bool? isRangeSelector,
    shadcn.PromptMode? mode,
    Widget? placeholder,
    shadcn.CalendarView? initialView,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    Widget? dialogTitle,
    shadcn.CalendarViewType? initialViewType,
    shadcn.DateStateBuilder? stateBuilder,
    form.FieldOption? defaultValue,
  }) {
    return DatePickerField(
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
      isRangeSelector: isRangeSelector ?? this.isRangeSelector,
      mode: mode ?? this.mode,
      placeholder: placeholder ?? this.placeholder,
      initialView: initialView ?? this.initialView,
      popoverAlignment: popoverAlignment ?? this.popoverAlignment,
      popoverAnchorAlignment: popoverAnchorAlignment ?? this.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? this.popoverPadding,
      dialogTitle: dialogTitle ?? this.dialogTitle,
      initialViewType: initialViewType ?? this.initialViewType,
      stateBuilder: stateBuilder ?? this.stateBuilder,
      defaultValue: defaultValue ?? this.defaultValue,
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
    if (value is form.FieldOption) {
      // For date ranges, split the "start / end" string
      if (value.value.contains(' / ')) {
        return value.value.split(' / ');
      }
      return [value.value];
    }
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

  // Helper method to extract DateTime from FieldOption
  static DateTime? extractDateTime(form.FieldOption? option) {
    return option?.additionalData as DateTime?;
  }

  // Helper method to extract DateTimeRange from FieldOption
  static shadcn.DateTimeRange? extractDateTimeRange(form.FieldOption? option) {
    return option?.additionalData as shadcn.DateTimeRange?;
  }

  // Helper method to create FieldOption from DateTime
  static form.FieldOption fromDateTime(DateTime date) {
    return form.FieldOption(
      value: date.toIso8601String(),
      label: DateFormat('yyyy-MM-dd').format(date),
      additionalData: date,
    );
  }

  // Helper method to create FieldOption from DateTimeRange
  static form.FieldOption fromDateTimeRange(shadcn.DateTimeRange range) {
    return form.FieldOption(
      value:
          '${range.start.toIso8601String()} / ${range.end.toIso8601String()}',
      label:
          '${DateFormat('yyyy-MM-dd').format(range.start)} - ${DateFormat('yyyy-MM-dd').format(range.end)}',
      additionalData: range,
    );
  }

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final field = ctx.field as DatePickerField;
    final fieldOption = ctx.getValue<form.FieldOption?>();

    return Column(
      key: ValueKey('datepicker_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!field.isRangeSelector)
          _buildSingleDatePicker(ctx, fieldOption)
        else
          _buildDateRangePicker(ctx, fieldOption),
      ],
    );
  }

  Widget _buildSingleDatePicker(
    form.FieldBuilderContext ctx,
    form.FieldOption? fieldOption,
  ) {
    final field = ctx.field as DatePickerField;
    final value = extractDateTime(fieldOption);

    return shadcn.DatePicker(
      key: ValueKey('datepicker_${ctx.field.id}'),
      value: value,
      mode: field.mode,
      placeholder: field.placeholder,
      initialView: field.initialView,
      popoverAlignment: field.popoverAlignment,
      popoverAnchorAlignment: field.popoverAnchorAlignment,
      popoverPadding: field.popoverPadding,
      dialogTitle: field.dialogTitle,
      initialViewType: field.initialViewType,
      stateBuilder: field.stateBuilder,
      onChanged: ctx.field.disabled
          ? null
          : (newValue) {
              if (newValue != null) {
                final option = fromDateTime(newValue);
                debugPrint(option.toString());
                ctx.setValue<form.FieldOption?>(option);
              }
            },
    );
  }

  Widget _buildDateRangePicker(
    form.FieldBuilderContext ctx,
    form.FieldOption? fieldOption,
  ) {
    final field = ctx.field as DatePickerField;
    final value = extractDateTimeRange(fieldOption);

    return shadcn.DateRangePicker(
      key: ValueKey('daterangepicker_${ctx.field.id}'),
      value: value,
      mode: field.mode ?? shadcn.PromptMode.popover,
      placeholder: field.placeholder,
      initialView: field.initialView,
      popoverAlignment: field.popoverAlignment,
      popoverAnchorAlignment: field.popoverAnchorAlignment,
      popoverPadding: field.popoverPadding,
      dialogTitle: field.dialogTitle,
      initialViewType: field.initialViewType,
      stateBuilder: field.stateBuilder,
      onChanged: ctx.field.disabled
          ? null
          : (newValue) {
              if (newValue != null) {
                final option = fromDateTimeRange(newValue);
                debugPrint(option.additionalData.toString());
                ctx.setValue<form.FieldOption?>(option);
              }
            },
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
