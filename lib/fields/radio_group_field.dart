import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A radio group field using ShadCN Flutter's RadioGroup component.
///
/// This field represents a group of radio buttons where only one option can be selected.
/// The value is stored as a List<FieldOption> with max 1 item (single-select mode).
///
/// ## Usage
///
/// ```dart
/// final genderField = RadioGroupField(
///   id: 'gender',
///   title: 'Gender',
///   description: 'Select your gender',
///   options: [
///     form.FieldOption(label: 'Male', value: 'male'),
///     form.FieldOption(label: 'Female', value: 'female'),
///     form.FieldOption(label: 'Other', value: 'other'),
///   ],
///   defaultValue: [], // Empty list = no selection
/// );
/// ```
class RadioGroupField extends form.OptionSelect {
  RadioGroupField({
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
    super.multiselect = false, // Radio groups are always single-select
  });
}

/// A radio group field widget using ShadCN Flutter's RadioGroup component.
///
/// This field represents a group of radio buttons where only one option can be selected.
/// The value is stored as a List<FieldOption> with max 1 item (single-select mode).
///
/// Features:
/// - Uses ShadCN Flutter's RadioGroup and RadioItem components
/// - Stores List<FieldOption> values (single-item list for radio buttons)
/// - Automatically triggers onChange callbacks
/// - Matches checkbox/switch/select pattern
///
/// Example:
/// ```dart
/// RadioGroupField(
///   id: 'gender',
///   title: 'Gender',
///   description: 'Select your gender',
///   options: [
///     form.FieldOption(label: 'Male', value: 'male'),
///     form.FieldOption(label: 'Female', value: 'female'),
///   ],
/// )
/// ```
class ShadcnRadioGroupWidget extends form.StatefulFieldWidget {
  const ShadcnRadioGroupWidget({
    required super.context,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get options from the OptionSelect field
    final field = ctx.field as form.OptionSelect;
    final options = field.options ?? [];

    // OptionSelect stores as List, even in single-select mode
    final value = ctx.getValue<List<form.FieldOption>>();
    final selectedOption = (value != null && value.isNotEmpty) ? value.first : null;

    return Column(
      key: ValueKey('radiogroup_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shadcn.RadioGroup<String>(
          key: ValueKey('radiogroup_${ctx.field.id}'),
          value: selectedOption?.value,
          onChanged: ctx.field.disabled
              ? null
              : (newValue) {
                  // Find the FieldOption that matches the selected value
                  final newOption = options.firstWhere(
                    (opt) => opt.value == newValue,
                    orElse: () => form.FieldOption(value: newValue, label: newValue),
                  );
                  // Store as single-item list
                  ctx.setValue<List<form.FieldOption>>([newOption]);
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: shadcn.RadioItem<String>(
                  value: option.value,
                  trailing: Text(option.label),
                ),
              );
            }).toList(),
          ),
        ),
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
