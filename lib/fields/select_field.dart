import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A select field using ShadCN Flutter's Select/MultiSelect component.
///
/// This field provides a dropdown selection interface that can handle both
/// single and multiple selections based on the `multiselect` parameter.
/// Values are stored as FieldOption (single-select) or List<FieldOption> (multi-select).
///
/// ## Usage
///
/// ```dart
/// // Single-select mode
/// final fruitField = ShadcnSelectField(
///   id: 'fruit',
///   title: 'Select a Fruit',
///   options: [
///     form.FieldOption(label: 'Apple', value: 'apple'),
///     form.FieldOption(label: 'Banana', value: 'banana'),
///     form.FieldOption(label: 'Cherry', value: 'cherry'),
///   ],
///   multiselect: false,
///   defaultValue: null,
/// );
///
/// // Multi-select mode
/// final fruitsField = ShadcnSelectField(
///   id: 'fruits',
///   title: 'Select Fruits',
///   options: [
///     form.FieldOption(label: 'Apple', value: 'apple'),
///     form.FieldOption(label: 'Banana', value: 'banana'),
///   ],
///   multiselect: true,
///   defaultValue: [],
/// );
/// ```
class ShadcnSelectField extends form.OptionSelect {
  /// Full constraint control for popover/constraints.
  final BoxConstraints? popoverConstraints;

  ShadcnSelectField({
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
    this.popoverConstraints,
  });
}

/// Select/MultiSelect widget using ShadCN Flutter's Select or MultiSelect component.
///
/// This widget conditionally renders either a Select (single-select) or
/// MultiSelect (multi-select) component based on the field's `multiselect` parameter.
/// Values are stored as FieldOption (single) or List<FieldOption> (multi).
///
/// Features:
/// - Conditional rendering based on multiselect mode
/// - Single-select uses shadcn.Select with FieldOption storage
/// - Multi-select uses shadcn.MultiSelect with List<FieldOption> storage
/// - Automatically triggers onChange callbacks
/// - Supports all FieldOption properties (label, value, hintText)
///
/// Example:
/// ```dart
/// ShadcnSelectField(
///   id: 'fruit',
///   title: 'Select a Fruit',
///   options: [
///     form.FieldOption(label: 'Apple', value: 'apple'),
///     form.FieldOption(label: 'Banana', value: 'banana'),
///   ],
///   multiselect: false,
/// )
/// ```
class ShadcnSelectWidget extends form.StatefulFieldWidget {
  const ShadcnSelectWidget({
    required super.context,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get options from the ShadcnSelectField
    final field = ctx.field as ShadcnSelectField;
    final options = field.options ?? [];

    // Check if multiselect mode is enabled
    final isMultiselect = field.multiselect;

    return Column(
      key: ValueKey('select_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMultiselect)
          _buildSingleSelect(ctx, options, field)
        else
          _buildMultiSelect(ctx, options, field),
      ],
    );
  }

  /// Build single-select dropdown using shadcn.Select
  Widget _buildSingleSelect(
    form.FieldBuilderContext ctx,
    List<form.FieldOption> options,
    ShadcnSelectField field,
  ) {
    // OptionSelect stores as List, even in single-select mode
    final value = ctx.getValue<List<form.FieldOption>>();
    final selectedOption = (value != null && value.isNotEmpty) ? value.first : null;

    return shadcn.Select<String>(
      key: ValueKey('select_${ctx.field.id}'),
      value: selectedOption?.value,
      onChanged: ctx.field.disabled
          ? null
          : (newValue) {
              if (newValue == null) {
                // Set to empty list (no selection)
                ctx.setValue<List<form.FieldOption>>([]);
              } else {
                // Find the FieldOption that matches the selected value
                final newOption = options.firstWhere(
                  (opt) => opt.value == newValue,
                  orElse: () => form.FieldOption(value: newValue, label: newValue),
                );
                // Store as single-item list
                ctx.setValue<List<form.FieldOption>>([newOption]);
              }
            },
      itemBuilder: (context, item) {
        // Find the option to display its label
        final option = options.firstWhere(
          (opt) => opt.value == item,
          orElse: () => form.FieldOption(value: item, label: item),
        );
        return Text(option.label);
      },
      placeholder: ctx.field.description != null
          ? Text(ctx.field.description!)
          : const Text('Select an option'),
      popupConstraints: field.popoverConstraints ?? const BoxConstraints(maxHeight: 300, maxWidth: 400),
      popup: shadcn.SelectPopup(
        items: shadcn.SelectItemList(
          children: options.map((option) {
            return shadcn.SelectItemButton<String>(
              value: option.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option.label),
                  if (option.hintText != null)
                    Text(
                      option.hintText!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build multi-select dropdown using shadcn.MultiSelect
  Widget _buildMultiSelect(
    form.FieldBuilderContext ctx,
    List<form.FieldOption> options,
    ShadcnSelectField field,
  ) {
    final value = ctx.getValue<List<form.FieldOption>>();

    // Convert List of FieldOption to Iterable of String for the MultiSelect widget
    final selectedValues = value?.map((option) => option.value).toList();

    return shadcn.MultiSelect<String>(
      key: ValueKey('multiselect_${ctx.field.id}'),
      value: selectedValues,
      onChanged: ctx.field.disabled
          ? null
          : (newValues) {
              // Convert Iterable<String> back to List<FieldOption>
              if (newValues == null || newValues.isEmpty) {
                ctx.setValue<List<form.FieldOption>>([]);
              } else {
                final selectedOptions = newValues.map((val) {
                  return options.firstWhere(
                    (opt) => opt.value == val,
                    orElse: () => form.FieldOption(value: val, label: val),
                  );
                }).toList();
                ctx.setValue<List<form.FieldOption>>(selectedOptions);
              }
            },
      itemBuilder: (context, item) {
        // Find the option to display its label in the chip
        final option = options.firstWhere(
          (opt) => opt.value == item,
          orElse: () => form.FieldOption(value: item, label: item),
        );
        return shadcn.MultiSelectChip(
          value: item,
          child: Text(option.label),
        );
      },
      placeholder: ctx.field.description != null
          ? Text(ctx.field.description!)
          : const Text('Select options'),
      constraints: field.popoverConstraints ?? const BoxConstraints(minWidth: 200),
      popup: shadcn.SelectPopup(
        items: shadcn.SelectItemList(
          children: options.map((option) {
            return shadcn.SelectItemButton<String>(
              value: option.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option.label),
                  if (option.hintText != null)
                    Text(
                      option.hintText!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
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
