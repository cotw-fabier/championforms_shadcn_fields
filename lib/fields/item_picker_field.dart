import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/field_types/formfieldclass.dart';
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// An item picker field using ShadCN Flutter's ItemPicker component.
///
/// This field provides an item selection interface with popover or dialog mode.
/// Only one option can be selected. The value is stored as a FieldOption object.
///
/// ## Usage
///
/// ```dart
/// final countryField = ItemPickerField(
///   id: 'country',
///   title: 'Select Country',
///   options: [
///     form.FieldOption(label: 'United States', value: 'usa', hintText: 'North America'),
///     form.FieldOption(label: 'United Kingdom', value: 'uk', hintText: 'Europe'),
///     form.FieldOption(label: 'Japan', value: 'japan', hintText: 'Asia'),
///   ],
///   defaultValue: form.FieldOption(label: 'United States', value: 'usa', hintText: 'North America'),
/// );
/// ```
class ItemPickerField extends Field {
  /// List of options to display in the item picker.
  final List<form.FieldOption> options;

  @override
  final form.FieldOption? defaultValue;

  ItemPickerField({
    required super.id,
    required this.options,
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

  @override
  ItemPickerField copyWith({
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
      Field,
      form.FormController,
      form.FieldColorScheme,
      Widget,
    )? fieldLayout,
    Widget Function(
      BuildContext,
      Field,
      form.FormController,
      form.FieldColorScheme,
      Widget,
    )? fieldBackground,
    List<form.FieldOption>? options,
    form.FieldOption? defaultValue,
  }) {
    return ItemPickerField(
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
    );
  }

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults using OptionSelectConverters pattern

  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is form.FieldOption) return value.label;
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
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// Item Picker field - Item picker widget
///
/// Uses ShadCN Flutter's ItemPicker component to provide an item selection
/// interface with popover or dialog mode. Values are stored as FieldOption.
///
/// Example usage:
/// ```dart
/// form.TextField(
///   id: 'country',
///   title: 'Select Country',
///   fieldBuilder: (ctx) => ShadcnItemPickerWidget(
///     context: ctx,
///     options: [
///       form.FieldOption(label: 'United States', value: 'usa', hintText: 'North America'),
///       form.FieldOption(label: 'United Kingdom', value: 'uk', hintText: 'Europe'),
///       form.FieldOption(label: 'Japan', value: 'japan', hintText: 'Asia'),
///     ],
///   ),
/// )
/// ```
class ShadcnItemPickerWidget extends form.StatefulFieldWidget {
  const ShadcnItemPickerWidget({
    required super.context,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get field and options from ItemPickerField
    final field = ctx.field as ItemPickerField;
    final options = field.options;

    final selectedOption = ctx.getValue<form.FieldOption?>();
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
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

        // Item Picker Component
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
          child: shadcn.ItemPicker<form.FieldOption>(
            key: ValueKey('itempicker_${ctx.field.id}'),
            items: shadcn.ItemList(options),
            mode: shadcn.PromptMode.popover,
            title: Text(ctx.field.title ?? 'Select an item'),
            builder: (context, item) {
              return shadcn.ItemPickerOption(
                value: item,
                label: Text(item.label),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if (item.hintText != null)
                        Text(
                          item.hintText!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            value: selectedOption,
            placeholder: ctx.field.description != null
                ? Text(ctx.field.description!)
                : const Text('Select an item'),
            onChanged: (newOption) {
              ctx.setValue<form.FieldOption?>(newOption);
            },
          ),
        ),

        // Description (only show if there's a selection)
        if (ctx.field.description != null && selectedOption != null)
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
                    fontSize: 12,
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
