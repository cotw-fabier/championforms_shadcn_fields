import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays switch groups using ShadCN Flutter's Switch component.
///
/// This field stores a List<FieldOption> for multiselect switch groups.
/// Each switch can be independently toggled.
///
/// ## Usage
///
/// ```dart
/// final switchField = SwitchField(
///   id: 'preferences',
///   title: 'Select Your Preferences',
///   description: 'Choose one or more options',
///   options: [
///     form.FieldOption(label: 'Email Notifications', value: 'email'),
///     form.FieldOption(label: 'SMS Notifications', value: 'sms'),
///     form.FieldOption(label: 'Push Notifications', value: 'push'),
///   ],
///   defaultValue: [], // none checked by default
///   labelOnLeft: false, // labels appear on the right (trailing)
/// );
/// ```
class SwitchField extends form.OptionSelect {
  /// Whether labels should appear on the left (leading) or right (trailing) of the switch.
  /// Defaults to false (labels on the right).
  final bool labelOnLeft;

  /// Spacing between switch and labels
  final double? gap;

  /// Color when switched on
  final Color? activeColor;

  /// Color when switched off
  final Color? inactiveColor;

  /// Thumb color when on
  final Color? activeThumbColor;

  /// Thumb color when off
  final Color? inactiveThumbColor;

  /// Corner radius
  final BorderRadiusGeometry? borderRadius;

  SwitchField({
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
    this.labelOnLeft = false,
    this.gap,
    this.activeColor,
    this.inactiveColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.borderRadius,
  });

  @override
  SwitchField copyWith({
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
    bool? labelOnLeft,
    double? gap,
    Color? activeColor,
    Color? inactiveColor,
    Color? activeThumbColor,
    Color? inactiveThumbColor,
    BorderRadiusGeometry? borderRadius,
  }) {
    return SwitchField(
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
      labelOnLeft: labelOnLeft ?? this.labelOnLeft,
      gap: gap ?? this.gap,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      activeThumbColor: activeThumbColor ?? this.activeThumbColor,
      inactiveThumbColor: inactiveThumbColor ?? this.inactiveThumbColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

/// A switch group widget using ShadCN Flutter's Switch component.
///
/// This widget displays multiple switches where each can be independently toggled.
/// The value is stored as a List<FieldOption> containing all selected options.
///
/// Features:
/// - Uses ShadCN Flutter's Switch component
/// - Supports multiple switch selections
/// - Stores List<FieldOption> for selected switches
/// - Automatically triggers onChange callbacks
/// - Configurable label position (leading or trailing)
///
/// Example:
/// ```dart
/// SwitchField(
///   id: 'preferences',
///   title: 'Notification Preferences',
///   description: 'Select your preferred notification methods',
///   options: [
///     form.FieldOption(label: 'Email', value: 'email'),
///     form.FieldOption(label: 'SMS', value: 'sms'),
///   ],
///   labelOnLeft: false,
/// )
/// ```
class ShadcnSwitchWidget extends form.StatefulFieldWidget {
  /// Whether labels should appear on the left (leading) or right (trailing) of the switch.
  /// Defaults to false (labels on the right).
  final bool labelOnLeft;

  const ShadcnSwitchWidget({
    required super.context,
    this.labelOnLeft = false,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get options from the OptionSelect field
    final field = ctx.field as SwitchField;
    final options = field.options ?? [];

    return Column(
      key: ValueKey('switch_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render each switch option
        ...options.map((option) {
          // Check if this specific option is selected
          final isSelected = ctx.isOptionSelected(option.value);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: shadcn.Switch(
              key: ValueKey('switch_${ctx.field.id}_${option.value}'),
              value: isSelected,
              onChanged: ctx.field.disabled
                  ? null
                  : (newValue) {
                      // Toggle this option's selection
                      ctx.toggleValue(option);
                    },
              // Position label based on labelOnLeft parameter
              leading: labelOnLeft ? Text(option.label) : null,
              trailing: !labelOnLeft ? Text(option.label) : null,
              gap: field.gap,
              activeColor: field.activeColor,
              inactiveColor: field.inactiveColor,
              activeThumbColor: field.activeThumbColor,
              inactiveThumbColor: field.inactiveThumbColor,
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
      final results = form.FormResults.getResults(controller: context.controller);
      context.field.onChange!(results);
    }
  }
}
