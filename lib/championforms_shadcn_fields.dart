library championforms_shadcn_fields;

/// ChampionForms integration for ShadCN Flutter UI components.
///
/// This library provides 21 form fields built on top of ShadCN Flutter's
/// component library, making them available for use with ChampionForms.
///
/// ## Usage
///
/// 1. Register all fields at app startup:
/// ```dart
/// import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';
///
/// void main() {
///   ShadcnFieldRegistry.registerAll();
///   runApp(MyApp());
/// }
/// ```
///
/// 2. Use fields in your forms:
/// ```dart
/// import 'package:championforms/championforms.dart' as form;
/// import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';
///
/// form.Form(
///   controller: controller,
///   fields: [
///     form.TextField(
///       id: 'name',
///       title: 'Full Name',
///       fieldBuilder: (ctx) => ShadcnTextInputWidget(context: ctx),
///     ),
///   ],
/// )
/// ```

export 'registry.dart';

// Converter Implementations
export 'converters/_converter_helpers.dart';
export 'converters/optionselect_converters.dart';

// Text Input Fields - Group 1
export 'fields/text_input_field.dart';
export 'fields/text_area_field.dart';
export 'fields/formatted_input_field.dart';
export 'fields/phone_input_field.dart';

// Selection Fields - Group 2
export 'fields/checkbox_field.dart';
export 'fields/switch_field.dart';
export 'fields/toggle_field.dart';
export 'fields/radio_group_field.dart';
export 'converters/bool_converters.dart';

// Selection Fields - Group 3
export 'fields/radio_card_field.dart';
export 'fields/select_field.dart';
export 'fields/item_picker_field.dart';

// Input Enhancement & Numeric Fields - Group 4
export 'fields/autocomplete_field.dart';
export 'fields/chip_input_field.dart';
export 'fields/number_input_field.dart';
export 'fields/slider_field.dart';
export 'converters/chip_input_converters.dart'; // DEPRECATED
export 'converters/chip_input_option_converters.dart';
export 'converters/slider_converters.dart';

// Special Fields - Group 5
export 'fields/star_rating_field.dart';
export 'fields/date_picker_field.dart';
export 'fields/time_picker_field.dart';
export 'fields/input_otp_field.dart';
export 'converters/date_time_converters.dart';
export 'converters/time_converters.dart';
export 'converters/star_rating_option_converters.dart';

// Color Picker
export 'fields/color_picker_field.dart';
export 'converters/color_converters.dart';
export 'converters/color_option_converters.dart';
