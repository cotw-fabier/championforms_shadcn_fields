import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays a toggle button using ShadCN Flutter's Toggle component.
///
/// This field stores a FieldOption when toggled, null when not toggled.
/// The FieldOption approach allows custom labels and metadata for the toggled state.
///
/// ## Usage
///
/// ```dart
/// final toggleField = ToggleField(
///   id: 'dark_mode',
///   title: 'Dark Mode',
///   description: 'Enable dark mode theme',
///   checkedOption: form.FieldOption(label: 'Dark Mode On', value: 'dark'),
///   defaultValue: null, // not toggled by default
/// );
/// ```
class ToggleField extends form.Field {
  /// The FieldOption to store when toggle is pressed.
  /// Defaults to FieldOption(label: 'Toggled', value: 'true')
  final form.FieldOption? checkedOption;

  @override
  final form.FieldOption? defaultValue;

  /// Custom icon widget
  @override
  final Widget? icon;

  ToggleField({
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
    this.checkedOption,
    this.defaultValue,
    this.icon,
  });

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults

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
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// A toggle field widget using ShadCN Flutter's Toggle component.
///
/// This field represents a toggle button that can be pressed or unpressed.
/// The value is stored as a FieldOption when toggled, null when not toggled.
///
/// Features:
/// - Uses ShadCN Flutter's Toggle component
/// - Supports title and description
/// - Stores FieldOption values (null when not toggled)
/// - Automatically triggers onChange callbacks
/// - Can display custom label on the toggle button
/// - Customizable toggled option
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'dark_mode',
///   title: 'Dark Mode',
///   description: 'Enable dark mode theme',
///   fieldBuilder: (ctx) => ShadcnToggleWidget(context: ctx),
/// )
/// ```
class ShadcnToggleWidget extends form.StatefulFieldWidget {
  /// The FieldOption to store when toggle is pressed.
  /// Defaults to FieldOption(label: 'Toggled', value: 'true')
  final form.FieldOption? checkedOption;

  const ShadcnToggleWidget({
    required super.context,
    this.checkedOption,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Get validation errors
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    // Cast to ToggleField to access custom properties
    final field = ctx.field as ToggleField;

    // Use provided checkedOption or default
    final defaultToggled = form.FieldOption(label: 'Toggled', value: 'true');
    final activeOption = checkedOption ?? defaultToggled;

    // Get current value - FieldOption when toggled, null when not toggled
    final value = ctx.getValue<form.FieldOption?>();
    final isToggled = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (if present) with error styling
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

        // Toggle button
        shadcn.Toggle(
          value: isToggled,
          onChanged: ctx.field.disabled
              ? null
              : (newValue) {
                  ctx.setValue<form.FieldOption?>(newValue ? activeOption : null);
                },
          child: field.icon ?? Text(ctx.field.title ?? 'Toggle'),
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
      final results = form.FormResults.getResults(controller: context.controller);
      context.field.onChange!(results);
    }
  }
}
