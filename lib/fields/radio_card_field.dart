import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A radio card field using ShadCN Flutter's RadioCard component.
///
/// This field provides a card-based radio selection interface where only one
/// option can be selected. The value is stored as a List<FieldOption> with max 1 item.
///
/// ## Usage
///
/// ```dart
/// final planField = RadioCardField(
///   id: 'plan',
///   title: 'Select Plan',
///   options: [
///     form.FieldOption(label: '8-core CPU', value: 'plan1', hintText: '32 GB RAM'),
///     form.FieldOption(label: '6-core CPU', value: 'plan2', hintText: '24 GB RAM'),
///     form.FieldOption(label: '4-core CPU', value: 'plan3', hintText: '16 GB RAM'),
///   ],
///   defaultValue: [], // Empty list = no selection
/// );
/// ```
class RadioCardField extends form.OptionSelect {
  /// Spacing for wrapped items.
  final double? wrapSpacing;

  /// Spacing between rows when wrapping.
  final double? runGap;

  RadioCardField({
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
    this.wrapSpacing,
    this.runGap,
  });
}

/// Radio Card field - Radio selection with card UI
///
/// Uses ShadCN Flutter's RadioCard and RadioGroup components to provide
/// a card-based radio selection interface. Values are stored as List<FieldOption>
/// with max 1 item (single-select mode).
///
/// Features:
/// - Uses ShadCN Flutter's RadioCard component
/// - Stores List<FieldOption> values (single-item list for radio cards)
/// - Automatically triggers onChange callbacks
/// - Matches checkbox/switch/select pattern
///
/// Example usage:
/// ```dart
/// RadioCardField(
///   id: 'plan',
///   title: 'Select Plan',
///   options: [
///     form.FieldOption(label: '8-core CPU', value: 'plan1', hintText: '32 GB RAM'),
///     form.FieldOption(label: '6-core CPU', value: 'plan2', hintText: '24 GB RAM'),
///   ],
/// )
/// ```
class ShadcnRadioCardWidget extends form.StatefulFieldWidget {
  const ShadcnRadioCardWidget({required super.context, super.key});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get options from the RadioCardField
    final field = ctx.field as RadioCardField;
    final options = field.options ?? [];

    // OptionSelect stores as List, even in single-select mode
    final value = ctx.getValue<List<form.FieldOption>>();
    final selectedOption = (value != null && value.isNotEmpty)
        ? value.first
        : null;

    return Column(
      key: ValueKey('radiocard_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shadcn.RadioGroup<String>(
          key: ValueKey('radiocard_${ctx.field.id}'),
          value: selectedOption?.value,
          onChanged: ctx.field.disabled
              ? null
              : (newValue) {
                  // Find the FieldOption that matches the selected value
                  final newOption = options.firstWhere(
                    (opt) => opt.value == newValue,
                    orElse: () =>
                        form.FieldOption(value: newValue, label: newValue),
                  );
                  // Store as single-item list
                  ctx.setValue<List<form.FieldOption>>([newOption]);
                },
          child: Wrap(
            spacing: field.wrapSpacing ?? 12,
            runSpacing: field.runGap ?? 12,
            children: options.map((option) {
              return shadcn.RadioCard<String>(
                value: option.value,
                child: shadcn.Basic(
                  title: Text(option.label),
                  content: option.hintText != null
                      ? Text(option.hintText!)
                      : null,
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
      final results = form.FormResults.getResults(
        controller: context.controller,
      );
      context.field.onChange!(results);
    }
  }
}
