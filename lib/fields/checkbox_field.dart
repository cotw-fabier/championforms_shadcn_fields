import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays checkbox groups using ShadCN Flutter's Checkbox component.
///
/// This field stores a List<FieldOption> for multiselect checkbox groups.
/// Each checkbox can be independently toggled.
///
/// ## Usage
///
/// ```dart
/// final checkboxField = CheckboxField(
///   id: 'preferences',
///   title: 'Select Your Preferences',
///   description: 'Choose one or more options',
///   options: [
///     form.FieldOption(label: 'Email Notifications', value: 'email'),
///     form.FieldOption(label: 'SMS Notifications', value: 'sms'),
///     form.FieldOption(label: 'Push Notifications', value: 'push'),
///   ],
///   defaultValue: [], // none checked by default
/// );
/// ```
class CheckboxField extends form.OptionSelect {
  /// Widget displayed before checkbox square
  @override
  final Widget? leading;

  /// Size of checkbox square in logical pixels
  final double? size;

  /// Spacing between checkbox and leading/trailing
  final double? gap;

  /// Background color when unchecked
  final Color? backgroundColor;

  /// Color when checked
  final Color? activeColor;

  /// Border color when unchecked
  final Color? borderColor;

  /// Corner radius of checkbox
  final BorderRadiusGeometry? borderRadius;

  CheckboxField({
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
    required super.options,
    super.defaultValue,
    super.multiselect,
    this.leading,
    this.size,
    this.gap,
    this.backgroundColor,
    this.activeColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  CheckboxField copyWith({
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
    List<form.FieldOption>? options,
    List<form.FieldOption>? defaultValue,
    bool? multiselect,
    Widget? leading,
    double? size,
    double? gap,
    Color? backgroundColor,
    Color? activeColor,
    Color? borderColor,
    BorderRadiusGeometry? borderRadius,
  }) {
    return CheckboxField(
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
      options: options ?? this.options,
      defaultValue: defaultValue ?? this.defaultValue,
      multiselect: multiselect ?? this.multiselect,
      leading: leading ?? this.leading,
      size: size ?? this.size,
      gap: gap ?? this.gap,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

/// A checkbox group widget using ShadCN Flutter's Checkbox component.
///
/// This widget displays multiple checkboxes where each can be independently toggled.
/// The value is stored as a List<FieldOption> containing all selected options.
///
/// Features:
/// - Uses ShadCN Flutter's Checkbox component
/// - Supports multiple checkbox selections
/// - Supports title and description
/// - Stores List<FieldOption> for selected checkboxes
/// - Automatically triggers onChange callbacks
///
/// Example:
/// ```dart
/// CheckboxField(
///   id: 'preferences',
///   title: 'Notification Preferences',
///   description: 'Select your preferred notification methods',
///   options: [
///     form.FieldOption(label: 'Email', value: 'email'),
///     form.FieldOption(label: 'SMS', value: 'sms'),
///   ],
/// )
/// ```
class ShadcnCheckboxWidget extends form.StatefulFieldWidget {
  const ShadcnCheckboxWidget({required super.context, super.key});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get options from the OptionSelect field
    final field = ctx.field as CheckboxField;
    final options = field.options ?? [];

    return Column(
      key: ValueKey('checkbox_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render each checkbox option
        ...options.map((option) {
          // Check if this specific option is selected
          final isSelected = ctx.isOptionSelected(option.value);
          final checkboxState = isSelected
              ? shadcn.CheckboxState.checked
              : shadcn.CheckboxState.unchecked;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: shadcn.Checkbox(
              key: ValueKey('checkbox_${ctx.field.id}_${option.value}'),
              state: checkboxState,
              onChanged: ctx.field.disabled
                  ? null
                  : (newState) {
                      // Toggle this option's selection
                      ctx.toggleValue(option);
                    },
              trailing: Text(option.label),
              leading: field.leading,
              size: field.size,
              gap: field.gap,
              backgroundColor: field.backgroundColor,
              activeColor: field.activeColor,
              borderColor: field.borderColor,
              borderRadius: field.borderRadius,
            ),
          );
        }),
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
