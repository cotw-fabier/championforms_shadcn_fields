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
/// final checkboxField = ShadcnCheckboxField(
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
class ShadcnCheckboxField extends form.OptionSelect {
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

  ShadcnCheckboxField({
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
/// ShadcnCheckboxField(
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
    final field = ctx.field as ShadcnCheckboxField;
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
