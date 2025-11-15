# ChampionForms ShadCN Fields - Implementation Plan

## Overview
This library brings the collection of fields available in ShadCN_Flutter into ChampionForms so you can utilize all of the latest fields from this library in Champion Forms.

## Architecture

### Project Structure
```
lib/
├── championforms_shadcn_fields.dart    # Main export file
├── fields/                             # Individual field implementations
│   ├── autocomplete_field.dart
│   ├── checkbox_field.dart
│   ├── chip_input_field.dart
│   ├── color_picker_field.dart
│   ├── date_picker_field.dart
│   ├── formatted_input_field.dart
│   ├── input_otp_field.dart
│   ├── item_picker_field.dart
│   ├── multiselect_field.dart
│   ├── number_input_field.dart
│   ├── phone_input_field.dart
│   ├── radio_card_field.dart
│   ├── radio_group_field.dart
│   ├── select_field.dart
│   ├── slider_field.dart
│   ├── star_rating_field.dart
│   ├── switch_field.dart
│   ├── text_area_field.dart
│   ├── text_input_field.dart
│   ├── time_picker_field.dart
│   └── toggle_field.dart
├── converters/                         # Type converters
│   ├── slider_converters.dart
│   ├── color_converters.dart
│   ├── date_time_converters.dart
│   └── rating_converters.dart
└── registry.dart                       # Central field registry
```

## Implementation Pattern

Each field will follow this pattern:

### 1. Field Widget Structure
```dart
import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// Description of the field
class ShadcnFieldNameWidget extends form.StatefulFieldWidget<form.Field> {
  const ShadcnFieldNameWidget({required super.context});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final value = ctx.getValue<ValueType>() ?? defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (if present)
        if (ctx.field.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(ctx.field.title!, style: theme.titleTextStyle),
          ),

        // ShadCN Widget
        shadcn.WidgetName(
          value: value,
          onChanged: (newValue) => ctx.setValue(newValue),
          // Additional properties
        ),

        // Description (if present)
        if (ctx.field.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(ctx.field.description!, style: theme.hintTextStyle),
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
```

### 2. Converter Implementation (if needed)
```dart
class FieldNameConverters implements form.FieldConverters {
  @override
  String Function(dynamic value) get asStringConverter => (value) {
    if (value is CustomType) return value.toString();
    if (value == null) return "";
    throw TypeError();
  };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
    if (value is CustomType) return [value.toString()];
    if (value == null) return [];
    throw TypeError();
  };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
    if (value is CustomType) return true;
    if (value == null) return false;
    throw TypeError();
  };

  @override
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter => null;
}
```

### 3. Registration Pattern
```dart
// In registry.dart
class ShadcnFieldRegistry {
  static void registerAll() {
    form.FormFieldRegistry.register<form.Field>(
      'shadcn_field_name',
      (ctx) => ShadcnFieldNameWidget(context: ctx),
      converters: FieldNameConverters(), // if custom converter needed
    );
  }
}
```

## Field Implementation Details

### Group 1: Text Input Fields
1. **Text Input** - Basic text field using ShadCN TextField
   - Value Type: `String`
   - Converter: `TextFieldConverters` (built-in)

2. **Text Area** - Multi-line text input
   - Value Type: `String`
   - Converter: `TextFieldConverters` (built-in)

3. **Formatted Input** - Text input with formatting
   - Value Type: `String`
   - Converter: `TextFieldConverters` (built-in)

4. **Phone Input** - Phone number input with formatting
   - Value Type: `String`
   - Converter: `TextFieldConverters` (built-in)

5. **Input OTP** - One-time password input
   - Value Type: `String`
   - Converter: `TextFieldConverters` (built-in)

### Group 2: Selection Fields
6. **Checkbox** - Single checkbox
   - Value Type: `bool`
   - Converter: Custom (CheckboxState → bool)

7. **Switch** - Toggle switch
   - Value Type: `bool`
   - Converter: Custom (bool)

8. **Toggle** - Toggle button
   - Value Type: `bool`
   - Converter: Custom (bool)

9. **Radio Group** - Radio button group
   - Value Type: `String` or `FieldOption`
   - Converter: `TextFieldConverters` or custom

10. **Radio Card** - Radio selection with card UI
    - Value Type: `String` or `FieldOption`
    - Converter: `TextFieldConverters` or custom

11. **Select** - Dropdown select
    - Value Type: `String` or `FieldOption`
    - Converter: `TextFieldConverters` or custom

12. **Multi Select** - Multi-selection dropdown
    - Value Type: `List<FieldOption>`
    - Converter: `MultiselectFieldConverters` (built-in)

13. **Item Picker** - Item picker widget
    - Value Type: `String` or `FieldOption`
    - Converter: `TextFieldConverters` or custom

### Group 3: Input Enhancement Fields
14. **AutoComplete** - Autocomplete text field
    - Value Type: `String`
    - Converter: `TextFieldConverters` (built-in)

15. **Chip Input** - Tag/chip input
    - Value Type: `List<String>`
    - Converter: Custom

### Group 4: Numeric Fields
16. **Number Input** - Numeric input with controls
    - Value Type: `num` (int or double)
    - Converter: `NumericFieldConverters` (built-in)

17. **Slider** - Slider for numeric values
    - Value Type: `double` or `SliderValue`
    - Converter: Custom (SliderConverters)

18. **Star Rating** - Star rating input
    - Value Type: `int`
    - Converter: `NumericFieldConverters` (built-in)

### Group 5: Date/Time Fields
19. **Date Picker** - Date selection
    - Value Type: `DateTime`
    - Converter: Custom (DateTimeConverters)

20. **Time Picker** - Time selection
    - Value Type: `TimeOfDay` or `DateTime`
    - Converter: Custom (TimeConverters)

### Group 6: Special Fields
21. **Color Picker** - Color selection
    - Value Type: `Color`
    - Converter: Custom (ColorConverters)

## Implementation Strategy

### Phase 1: Setup (Agent 0)
- Update pubspec.yaml with dependencies
- Create project structure
- Set up central registry

### Phase 2: Implement Fields by Group (Agents 1-6)
Each agent will implement 3-4 fields from a group:

**Agent 1: Text Input Fields**
- Text Input
- Text Area
- Formatted Input
- Phone Input

**Agent 2: Selection Fields Part 1**
- Checkbox
- Switch
- Toggle
- Radio Group

**Agent 3: Selection Fields Part 2**
- Radio Card
- Select
- Multi Select
- Item Picker

**Agent 4: Input Enhancement & Numeric Fields**
- AutoComplete
- Chip Input
- Number Input
- Slider

**Agent 5: Special Fields**
- Star Rating
- Date Picker
- Time Picker
- Input OTP

**Agent 6: Color Picker**
- Color Picker (complex field requiring special attention)

### Phase 3: Integration (Agent 7)
- Update central registry with all fields
- Create comprehensive documentation
- Add usage examples

## Dependencies

Required packages in pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  championforms: ^0.6.0  # or appropriate version
  shadcn_flutter: ^latest
```

## Registry Usage

Users will initialize the registry in their main.dart:
```dart
import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';

void main() {
  // Register all ShadCN fields with ChampionForms
  ShadcnFieldRegistry.registerAll();

  runApp(MyApp());
}
```

Then use fields in forms:
```dart
import 'package:championforms/championforms.dart' as form;
import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';

form.Form(
  controller: controller,
  fields: [
    form.TextField(
      id: 'name',
      title: 'Full Name',
      fieldBuilder: (ctx) => ShadcnTextInputWidget(context: ctx),
    ),
    form.TextField(
      id: 'rating',
      title: 'Rate Us',
      fieldBuilder: (ctx) => ShadcnStarRatingWidget(context: ctx),
    ),
  ],
)
```

## Testing Strategy

Each field implementation should include:
1. Basic value setting and getting
2. Value conversion tests
3. Integration with FormController
4. onChange callback triggering
5. Validation integration

## Documentation Requirements

For each field:
1. API documentation
2. Usage example
3. Available properties
4. Value type and converter used
5. Screenshot/preview (if applicable)

## Success Criteria

✅ All 21 fields implemented following ChampionForms patterns
✅ All fields registered in central registry
✅ All fields have appropriate converters
✅ Complete documentation with examples
✅ Package is importable and usable in a ChampionForms project

## Implementation Status: COMPLETE

All 21 fields have been successfully implemented, tested, and documented. The package is ready for use.

## Notes

- Focus on creating clean, reusable implementations
- Follow ChampionForms best practices from the documentation
- Ensure proper type safety with converters
- Keep implementations simple and maintainable
- Document any deviations from standard patterns
