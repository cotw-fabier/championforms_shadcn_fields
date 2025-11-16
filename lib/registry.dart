import 'package:championforms/championforms_themes.dart';
import 'fields/color_picker_field.dart';
import 'fields/text_input_field.dart';
import 'fields/text_area_field.dart';
import 'fields/formatted_input_field.dart';
import 'fields/phone_input_field.dart';
import 'fields/checkbox_field.dart';
import 'fields/switch_field.dart';
import 'fields/toggle_field.dart';
import 'fields/radio_group_field.dart';
import 'fields/radio_card_field.dart';
import 'fields/select_field.dart';
import 'fields/item_picker_field.dart';
import 'fields/autocomplete_field.dart';
import 'fields/chip_input_field.dart';
import 'fields/number_input_field.dart';
import 'fields/slider_field.dart';
import 'fields/star_rating_field.dart';
import 'fields/date_picker_field.dart';
import 'fields/time_picker_field.dart';
import 'fields/input_otp_field.dart';

/// Central registry for all ShadCN Flutter field implementations.
///
/// Call [ShadcnFieldRegistry.registerAll] to register all available fields
/// with the ChampionForms field registry.
///
/// Example:
/// ```dart
/// void main() {
///   ShadcnFieldRegistry.registerAll();
///   runApp(MyApp());
/// }
/// ```
class ShadcnFieldRegistry {
  /// Register all ShadCN Flutter fields with ChampionForms.
  ///
  /// This should be called once during app initialization, before any forms
  /// are created.
  static void registerAll() {
    // Text Input Fields - Group 1
    FormFieldRegistry.register<ShadcnTextInputField>(
      'shadcn_text_input',
      (ctx) => ShadcnTextInputWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnTextAreaField>(
      'shadcn_text_area',
      (ctx) => ShadcnTextAreaWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnFormattedInputField>(
      'shadcn_formatted_input',
      (ctx) {
        final field = ctx.field as ShadcnFormattedInputField;
        return ShadcnFormattedInputWidget(
          context: ctx,
          parts: field.parts,
          separator: field.separator,
        );
      },
    );

    FormFieldRegistry.register<ShadcnPhoneInputField>(
      'shadcn_phone_input',
      (ctx) => ShadcnPhoneInputWidget(context: ctx),
    );

    // Selection Fields - Group 2
    FormFieldRegistry.register<ShadcnCheckboxField>(
      'shadcn_checkbox',
      (ctx) => ShadcnCheckboxWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnSwitchField>(
      'shadcn_switch',
      (ctx) {
        final field = ctx.field as ShadcnSwitchField;
        return ShadcnSwitchWidget(
          context: ctx,
          labelOnLeft: field.labelOnLeft,
        );
      },
    );

    FormFieldRegistry.register<ShadcnToggleField>(
      'shadcn_toggle',
      (ctx) => ShadcnToggleWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnRadioGroupField>(
      'shadcn_radio_group',
      (ctx) => ShadcnRadioGroupWidget(context: ctx),
    );

    // Selection Fields - Group 3
    FormFieldRegistry.register<ShadcnRadioCardField>(
      'shadcn_radio_card',
      (ctx) => ShadcnRadioCardWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnSelectField>(
      'shadcn_select',
      (ctx) => ShadcnSelectWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnItemPickerField>(
      'shadcn_item_picker',
      (ctx) => ShadcnItemPickerWidget(context: ctx),
    );

    // Input Enhancement & Numeric Fields - Group 4
    FormFieldRegistry.register<ShadcnAutoCompleteField>(
      'shadcn_autocomplete',
      (ctx) => ShadcnAutoCompleteWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnChipInputField>(
      'shadcn_chip_input',
      (ctx) => ShadcnChipInputWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnNumberInputField>(
      'shadcn_number_input',
      (ctx) => ShadcnNumberInputWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnSliderField>(
      'shadcn_slider',
      (ctx) => ShadcnSliderWidget(context: ctx),
    );

    // Special Fields - Group 5
    FormFieldRegistry.register<ShadcnStarRatingField>(
      'shadcn_star_rating',
      (ctx) => ShadcnStarRatingWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnDatePickerField>(
      'shadcn_date_picker',
      (ctx) => ShadcnDatePickerWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnTimePickerField>(
      'shadcn_time_picker',
      (ctx) => ShadcnTimePickerWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnInputOTPField>(
      'shadcn_input_otp',
      (ctx) => ShadcnInputOTPWidget(context: ctx),
    );

    FormFieldRegistry.register<ShadcnColorPickerField>(
      'shadcn_color_picker',
      (ctx) => ShadcnColorPickerWidget(context: ctx),
    );
  }
}
