import 'package:flutter/material.dart' as material;
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/championforms_themes.dart';
import 'package:championforms/models/file_model.dart';
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
/// final colorField = ShadcnColorPickerField(
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
class ShadcnColorPickerField extends form.Field {
  @override
  final form.FieldOption? defaultValue;

  ShadcnColorPickerField({
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
    this.defaultValue,
  });

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
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
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
    // Get current field option and extract Color from additionalData
    final fieldOption = ctx.getValue<form.FieldOption?>();
    final colorValue = ColorOptionConverters.extractColor(fieldOption) ?? material.Colors.blue;

    // Convert Flutter Color to ShadCN ColorDerivative
    final colorDerivative = ColorDerivative.fromColor(colorValue);

    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    return material.Column(
      crossAxisAlignment: material.CrossAxisAlignment.start,
      children: [
        // Title (if present)
        if (ctx.field.title != null)
          material.Padding(
            padding: const material.EdgeInsets.only(bottom: 8.0),
            child: material.Text(
              ctx.field.title!,
              style: theme.titleStyle?.copyWith(
                color: hasError ? errorColors.titleColor : null,
              ),
            ),
          ),

        // Color Input with popover mode
        material.Container(
          decoration: material.BoxDecoration(
            border: hasError
                ? material.Border.all(
                    color: errorColors.borderColor,
                    width: errorColors.borderSize.toDouble(),
                  )
                : null,
            borderRadius: hasError ? errorColors.borderRadius : null,
          ),
          child: ColorInput(
            key: material.ValueKey('colorpicker_${ctx.field.id}'),
            value: colorDerivative,
            promptMode: PromptMode.popover,
            showLabel: true,
            onChanged: (newColor) {
              // Convert ColorDerivative to Flutter Color, then wrap in FieldOption
              final color = newColor.toColor();
              final option = ColorOptionConverters.fromColor(color);
              ctx.setValue<form.FieldOption?>(option);
            },
          ),
        ),

        // Description (if present)
        if (ctx.field.description != null)
          material.Padding(
            padding: const material.EdgeInsets.only(top: 4.0),
            child: material.Text(
              ctx.field.description!,
              style: theme.descriptionStyle,
            ),
          ),

        // Error messages
        if (hasError)
          ...errors.map((error) => material.Padding(
                padding: const material.EdgeInsets.only(top: 8.0),
                child: material.Text(
                  error.reason,
                  style: material.TextStyle(
                    color: errorColors.textColor,
                    fontSize: 12.0,
                  ),
                ),
              )),
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
