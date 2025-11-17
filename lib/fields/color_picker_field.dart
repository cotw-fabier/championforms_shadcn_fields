import 'package:flutter/material.dart' as material;
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/championforms_themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../converters/color_option_converters.dart';

/// Field definition for ShadCN Color Picker.
///
/// A custom field that displays a color picker widget using ShadCN Flutter's
/// ColorInput component. The field stores a FieldOption where:
/// - value: hex string (#RRGGBB or #AARRGGBB)
/// - label: color name/description
/// - additionalData: the actual Color object
///
/// ## Usage
///
/// ```dart
/// final colorField = ColorPickerField(
///   id: 'theme_color',
///   title: 'Theme Color',
///   description: 'Choose your preferred theme color',
///   defaultValue: ColorOptionConverters.fromColor(Colors.blue),
/// );
/// ```
///
/// ## Accessing Values
///
/// ```dart
/// // Get the FieldOption
/// final option = results.getAsRaw<form.FieldOption>('theme_color');
///
/// // Extract the Color object
/// final color = ColorOptionConverters.extractColor(option);
///
/// // Get the hex string
/// final hex = results.grab('theme_color').asString();
/// ```
class ColorPickerField extends form.Field {
  /// Popover vs dialog mode for the picker
  final PromptMode? mode;

  /// Live updates while dragging color sliders
  final ValueChanged<ColorDerivative>? onChanging;

  /// Show alpha/opacity controls
  final bool? showAlpha;

  /// HSV, HSL, RGB picker mode
  final ColorPickerMode? initialMode;

  /// Enable screen color sampling (eyedropper)
  final bool? enableEyeDropper;

  /// Popup alignment relative to the trigger
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for the popup
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Internal padding for the popover
  final EdgeInsetsGeometry? popoverPadding;

  /// Shown when no color selected
  final material.Widget? placeholder;

  /// Title for dialog mode
  final material.Widget? dialogTitle;

  /// Show color history panel
  final bool showHistory;

  /// Show label with hex value
  final bool? showLabel;

  @override
  final form.FieldOption? defaultValue;

  ColorPickerField({
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
    this.mode,
    this.onChanging,
    this.showAlpha,
    this.initialMode,
    this.enableEyeDropper,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.placeholder,
    this.dialogTitle,
    this.showHistory = false,
    this.showLabel,
    this.defaultValue,
  });

  @override
  ColorPickerField copyWith({
    String? id,
    material.Widget? icon,
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
    material.Widget Function(
      material.BuildContext,
      form.Field,
      form.FormController,
      form.FieldColorScheme,
      material.Widget,
    )? fieldLayout,
    material.Widget Function(
      material.BuildContext,
      form.Field,
      form.FormController,
      form.FieldColorScheme,
      material.Widget,
    )? fieldBackground,
    PromptMode? mode,
    ValueChanged<ColorDerivative>? onChanging,
    bool? showAlpha,
    ColorPickerMode? initialMode,
    bool? enableEyeDropper,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    material.Widget? placeholder,
    material.Widget? dialogTitle,
    bool? showHistory,
    bool? showLabel,
    form.FieldOption? defaultValue,
  }) {
    return ColorPickerField(
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
      mode: mode ?? this.mode,
      onChanging: onChanging ?? this.onChanging,
      showAlpha: showAlpha ?? this.showAlpha,
      initialMode: initialMode ?? this.initialMode,
      enableEyeDropper: enableEyeDropper ?? this.enableEyeDropper,
      popoverAlignment: popoverAlignment ?? this.popoverAlignment,
      popoverAnchorAlignment: popoverAnchorAlignment ?? this.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? this.popoverPadding,
      placeholder: placeholder ?? this.placeholder,
      dialogTitle: dialogTitle ?? this.dialogTitle,
      showHistory: showHistory ?? this.showHistory,
      showLabel: showLabel ?? this.showLabel,
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

/// ShadCN Color Picker field for ChampionForms.
///
/// Provides a color selection interface using ShadCN Flutter's ColorInput
/// component with support for both RGB and RGBA colors.
///
/// Features:
/// - Popover mode for compact color input
/// - Dialog mode for detailed color selection
/// - Optional alpha channel support
/// - Color preview with hex display
///
/// Value Type: FieldOption (with Color in additionalData)
/// Display Format: Color preview swatch with hex value
///
/// Example:
/// ```dart
/// form.Field(
///   id: 'theme_color',
///   title: 'Theme Color',
///   description: 'Choose your preferred theme color',
///   fieldBuilder: (ctx) => ShadcnColorPickerWidget(context: ctx),
/// )
/// ```
class ShadcnColorPickerWidget extends form.StatefulFieldWidget {
  const ShadcnColorPickerWidget({required super.context, super.key});

  @override
  material.Widget buildWithTheme(
    material.BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final field = ctx.field as ColorPickerField;

    // Get current field option and extract Color from additionalData
    final fieldOption = ctx.getValue<form.FieldOption?>();
    final colorValue = ColorOptionConverters.extractColor(fieldOption) ?? material.Colors.blue;

    // Convert Flutter Color to ShadCN ColorDerivative
    final colorDerivative = ColorDerivative.fromColor(colorValue);

    return material.Column(
      key: material.ValueKey('colorpicker_col_${ctx.field.id}'),
      crossAxisAlignment: material.CrossAxisAlignment.start,
      children: [
        ColorInput(
          key: material.ValueKey('colorpicker_${ctx.field.id}'),
          value: colorDerivative,
          promptMode: field.mode,
          onChanging: field.onChanging,
          showAlpha: field.showAlpha,
          initialMode: field.initialMode,
          enableEyeDropper: field.enableEyeDropper,
          popoverAlignment: field.popoverAlignment,
          popoverAnchorAlignment: field.popoverAnchorAlignment,
          popoverPadding: field.popoverPadding,
          placeholder: field.placeholder,
          dialogTitle: field.dialogTitle,
          showHistory: field.showHistory,
          showLabel: field.showLabel,
          onChanged: ctx.field.disabled
              ? null
              : (newColor) {
                  // Convert ColorDerivative to Flutter Color, then wrap in FieldOption
                  final color = newColor.toColor();
                  final option = ColorOptionConverters.fromColor(color);
                  ctx.setValue<form.FieldOption?>(option);
                },
        ),
      ],
    );
  }

  @override
  void onValueChanged(dynamic oldValue, dynamic newValue) {
    // Trigger onChange callback if provided
    if (context.field.onChange != null) {
      final results = form.FormResults.getResults(controller: context.controller);
      context.field.onChange!(results);
    }
  }
}
