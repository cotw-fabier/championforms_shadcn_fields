# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package that integrates 21 ShadCN Flutter UI components as form fields for ChampionForms. It provides a bridge between ShadCN Flutter's component library and ChampionForms' form management system.

**Key Dependencies:**
- `championforms` (v0.6.0+) - Form management framework
- `shadcn_flutter` (v0.0.47) - UI component library
- Flutter SDK ^3.11.0-88.0.dev

## Development Commands

### Build & Analysis
```bash
# Get dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run analysis without info-level messages
flutter analyze --no-fatal-infos

# Run tests
flutter test
```

## Architecture

### Three-Layer Integration Pattern

1. **ShadCN Flutter Layer**: UI components from `shadcn_flutter` package
2. **Field Widget Layer**: Wrapper widgets that extend `StatefulFieldWidget` or `StatefulWidget`
3. **ChampionForms Layer**: Integration via `FormFieldRegistry` with custom converters

### Core Components

**`lib/registry.dart`**: Central registration point. The `ShadcnFieldRegistry.registerAll()` method registers all 21 fields with ChampionForms' `FormFieldRegistry`. This must be called at app startup before any forms are created.

**`lib/fields/`**: Contains 21 field widget implementations. Each field follows one of two patterns:

1. **StatefulFieldWidget Pattern** (19 fields): Extends `form.StatefulFieldWidget` for automatic lifecycle management, change detection, and validation. Used by most fields.

2. **Custom State Pattern** (2 fields): `chip_input_field.dart` and `number_input_field.dart` extend `StatefulWidget` directly with custom `State` classes because they need complex internal state management (ChipEditingController, NumberInputController). These manually handle FormController listener integration.

**`lib/converters/`**: Custom type converters that implement `form.FieldConverters` interface. Required for non-string value types:
- `OptionSelectConverters` - For single FieldOption values (Checkbox, Switch, Toggle, RadioGroup, RadioCard, Select, ItemPicker)
- `MultiselectFieldConvertersImpl` - For List<FieldOption> (MultiSelect)
- `ChipInputOptionConverters` - For List<FieldOption> (ChipInput tags/chips)
- `ColorOptionConverters` - For FieldOption with Color in additionalData (ColorPicker)
- `StarRatingOptionConverters` - For FieldOption with double rating in additionalData (StarRating)
- `SliderConverters` - For SliderValue → double
- `DateTimeConverters` - For DateTime → ISO 8601 string
- `TimeConverters` - For TimeOfDay → HH:mm string
- `ChipInputConverters` - DEPRECATED, use ChipInputOptionConverters
- `ColorConverters` - DEPRECATED, use ColorOptionConverters
- `BoolFieldConverters` - DEPRECATED, use OptionSelectConverters

**`lib/converters/_converter_helpers.dart`**: Concrete implementations of mixin-based converters (TextFieldConvertersImpl, NumericFieldConvertersImpl, MultiselectFieldConvertersImpl) needed because mixins cannot be instantiated directly.

### Field Implementation Pattern

Most fields follow this structure:

```dart
class ShadcnFieldWidget extends form.StatefulFieldWidget {
  const ShadcnFieldWidget({required super.context});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final value = ctx.getValue<T>();

    return Column(
      children: [
        if (ctx.field.title != null)
          Text(ctx.field.title!, style: theme.titleStyle),
        shadcn.Component(
          value: value,
          onChanged: (newValue) => ctx.setValue(newValue),
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

### Important Type Mappings

Fields that require options (Select, MultiSelect, RadioGroup, etc.) accept `List<form.FieldOption>` but internally convert to ShadCN Flutter's expected types:
- ShadCN Select expects `Iterable<String>`
- ChampionForms provides `List<FieldOption>` with `label` and `value` properties
- Conversion happens in field implementation using `options.map((o) => o.value)`

TimeOfDay has namespace collision:
- ShadCN Flutter has its own `TimeOfDay` class
- Always qualify as `shadcn.TimeOfDay` vs Flutter's material `TimeOfDay`

FormTheme properties:
- Use `theme.titleStyle` (NOT `titleTextStyle`)
- Use `theme.descriptionStyle` (NOT `descriptionTextStyle`)
- Use `theme.hintStyle` (NOT `hintTextStyle`)

## Adding New Fields

When adding a new field:

1. **Create field widget** in `lib/fields/<name>_field.dart`:
   - Extend `form.StatefulFieldWidget` if possible
   - Implement `buildWithTheme()` with ShadCN component
   - Override `onValueChanged()` for onChange callbacks
   - Use `ctx.getValue<T>()` and `ctx.setValue()` for value management

2. **Create converter** (if custom type) in `lib/converters/<name>_converters.dart`:
   - Implement `form.FieldConverters` interface
   - Define `asStringConverter`, `asStringListConverter`, `asBoolConverter`
   - Return `null` for `asFileListConverter` if not file-related
   - Always throw `TypeError()` for invalid type conversions

3. **Register in `lib/registry.dart`**:
   ```dart
   FormFieldRegistry.register<form.Field>(
     'shadcn_field_name',
     (ctx) => ShadcnFieldWidget(context: ctx, ...),
     converters: FieldNameConverters(), // if custom converter
   );
   ```

4. **Export in `lib/championforms_shadcn_fields.dart`**:
   ```dart
   export 'fields/<name>_field.dart';
   export 'converters/<name>_converters.dart'; // if applicable
   ```

## Value Type Reference

| Widget | Value Type | Converter | Notes |
|--------|------------|-----------|-------|
| Text inputs | `String` | TextFieldConvertersImpl | Text, TextArea, Formatted, Phone, AutoComplete, InputOTP |
| Boolean fields | `FieldOption?` | OptionSelectConverters | Checkbox, Switch, Toggle - null when unchecked |
| Selection fields | `FieldOption?` | OptionSelectConverters | RadioGroup, RadioCard, Select, ItemPicker |
| MultiSelect | `List<FieldOption>` | MultiselectFieldConvertersImpl | Multiple selections stored as list |
| ChipInput | `List<FieldOption>` | ChipInputOptionConverters | Tags/chips with labels and metadata |
| NumberInput | `num` | NumericFieldConvertersImpl | int or double |
| Slider | `SliderValue` | SliderConverters | Converts to double |
| StarRating | `FieldOption?` | StarRatingOptionConverters | Rating value in additionalData |
| DatePicker | `DateTime` | DateTimeConverters | ISO 8601 string |
| TimePicker | `shadcn.TimeOfDay` | TimeConverters | HH:mm string |
| ColorPicker | `FieldOption?` | ColorOptionConverters | Color in additionalData, hex in value |

## Common Patterns

### Fields with Options (Single Selection)
```dart
// Widget constructor accepts options
ShadcnSelectWidget(
  context: ctx,
  options: [
    form.FieldOption(label: 'Display', value: 'stored_value'),
  ],
)

// In buildWithTheme() - retrieve and store FieldOption
final selectedOption = ctx.getValue<form.FieldOption?>();

// Pass value string to ShadCN component for display
shadcn.Select<String>(
  value: selectedOption?.value,
  options: widget.options.map((opt) {
    return shadcn.SelectOption(value: opt.value, child: Text(opt.label));
  }).toList(),
  onChanged: (newValue) {
    // Find the complete FieldOption from options list
    final newOption = widget.options.firstWhere((o) => o.value == newValue);
    // Store the entire FieldOption object
    ctx.setValue<form.FieldOption?>(newOption);
  },
)
```

### Boolean Fields with FieldOption
```dart
class ShadcnCheckboxWidget extends form.StatefulFieldWidget {
  final form.FieldOption? checkedOption;

  const ShadcnCheckboxWidget({
    required super.context,
    this.checkedOption,
    super.key,
  });

  @override
  Widget buildWithTheme(...) {
    // Default option if not provided
    final defaultChecked = form.FieldOption(label: 'Checked', value: 'true');
    final activeOption = checkedOption ?? defaultChecked;

    // Retrieve FieldOption (null = unchecked)
    final value = ctx.getValue<form.FieldOption?>();
    final isChecked = value != null;

    return Checkbox(
      checked: isChecked,
      onChanged: (checked) {
        // Store activeOption when checked, null when unchecked
        ctx.setValue<form.FieldOption?>(checked ? activeOption : null);
      },
    );
  }
}
```

### Special Value Fields with additionalData
```dart
// Color Picker - stores Color in additionalData
import '../converters/color_option_converters.dart';

final fieldOption = ctx.getValue<form.FieldOption?>();
final currentColor = ColorOptionConverters.extractColor(fieldOption) ?? Colors.blue;

onChanged: (Color newColor) {
  final option = ColorOptionConverters.fromColor(newColor);
  ctx.setValue<form.FieldOption?>(option);
}

// Star Rating - stores double in additionalData
import '../converters/star_rating_option_converters.dart';

final fieldOption = ctx.getValue<form.FieldOption?>();
final currentRating = StarRatingOptionConverters.extractRating(fieldOption) ?? 0.0;

onChanged: (double newRating) {
  final option = StarRatingOptionConverters.fromRating(newRating);
  ctx.setValue<form.FieldOption?>(option);
}
```

### Theme Integration
```dart
// Access colors via ctx.colors (auto-selected for field state)
Container(
  decoration: BoxDecoration(
    border: Border.all(color: ctx.colors.borderColor),
    color: ctx.colors.backgroundColor,
  ),
)

// Access text styles via theme parameter
Text(ctx.field.title!, style: theme.titleStyle)
```

### Validation
Fields automatically work with ChampionForms validators. No special handling needed in field implementation - validators are applied by the framework.

## Documentation Location

- ChampionForms custom field docs: `/Users/fabier/Documents/code/championforms/docs/custom-fields/`
- ShadCN Flutter component examples: `/Users/fabier/Documents/libraries/shadcn_flutter/docs/lib/pages/docs/components/`

## Breaking Changes v1.0.0

Version 1.0.0 introduces significant breaking changes to improve consistency and leverage ChampionForms' FieldOption system.

### Value Type Changes

**12 fields now store `FieldOption` instead of primitive types:**

1. **Boolean fields** (Checkbox, Switch, Toggle):
   - **Before:** `bool` (true/false)
   - **After:** `FieldOption?` (null = unchecked, FieldOption = checked)
   - **Reason:** Allow custom labels and metadata for checked/unchecked states

2. **Selection fields** (RadioGroup, RadioCard, Select, ItemPicker):
   - **Before:** `String` (stored only the value)
   - **After:** `FieldOption?` (stores complete option object)
   - **Reason:** Preserve label, hintText, and additionalData

3. **Chip Input:**
   - **Before:** `List<String>` (chip values only)
   - **After:** `List<FieldOption>` (chips with labels and metadata)
   - **Reason:** Allow chips with display labels different from stored values, plus additional metadata

4. **Color Picker:**
   - **Before:** `Color` object
   - **After:** `FieldOption?` with Color in `additionalData`
   - **Reason:** Allow color presets with labels

5. **Star Rating:**
   - **Before:** `double` rating value
   - **After:** `FieldOption?` with rating in `additionalData`
   - **Reason:** Allow rating categories with labels

### Converter Changes

- `BoolFieldConverters` → `OptionSelectConverters` (deprecated)
- `ChipInputConverters` → `ChipInputOptionConverters` (deprecated)
- `ColorConverters` → `ColorOptionConverters` (deprecated)
- `NumericFieldConvertersImpl` → `StarRatingOptionConverters` (for star rating)
- `TextFieldConvertersImpl` → `OptionSelectConverters` (for selection fields)
- `TextFieldConvertersImpl` → `MultiselectFieldConvertersImpl` (for multiselect)

### Migration Guide

**For Boolean Fields:**
```dart
// Before
results.grab('checkbox').asBool() // true/false
results.getAsRaw<bool>('checkbox')

// After
results.grab('checkbox').asBool() // still works! (true if FieldOption present, false if null)
results.grab('checkbox').asString() // returns label
results.getAsRaw<form.FieldOption>('checkbox')
results.grab('checkbox').asMultiselect('true') // get the specific option
```

**For Selection Fields:**
```dart
// Before
results.grab('select').asString() // returns stored value

// After
results.grab('select').asString() // returns label
results.grab('select').asRaw<form.FieldOption>()?.value // get value
results.grab('select').asMultiselect('option_value') // get specific option by value
```

**For Chip Input:**
```dart
// Before
final chips = results.getAsRaw<List<String>>('tags'); // ["hello", "world"]
results.grab('tags').asStringList() // ["hello", "world"]

// After
final chipOptions = results.getAsRaw<List<form.FieldOption>>('tags');
results.grab('tags').asString() // returns comma-separated labels: "Hello World, Lorem"
results.grab('tags').asStringList() // returns list of values: ["hello", "lorem"]
results.grab('tags').asMultiselectList() // returns List<FieldOption>

// Widget usage - suggestions now accept FieldOptions
ShadcnChipInputWidget(
  context: ctx,
  suggestions: [
    form.FieldOption(label: 'Hello World', value: 'hello'),
    form.FieldOption(label: 'Lorem Ipsum', value: 'lorem'),
  ],
)
```

**For Color Picker:**
```dart
// Before
final color = results.getAsRaw<Color>('color');

// After
final fieldOption = results.getAsRaw<form.FieldOption>('color');
final color = ColorOptionConverters.extractColor(fieldOption);
```

**For Star Rating:**
```dart
// Before
final rating = results.getAsRaw<double>('rating');

// After
final fieldOption = results.getAsRaw<form.FieldOption>('rating');
final rating = StarRatingOptionConverters.extractRating(fieldOption);
```

### Why These Changes?

1. **Consistency:** All selection/choice fields now use the same FieldOption pattern
2. **Richer data:** Store labels, hints, and custom metadata alongside values
3. **FormResults compatibility:** Leverage `asMultiselectList()` and `asMultiselect()` methods
4. **Future-proof:** Easier to extend with additional metadata without breaking changes

## Known Quirks

- The `championforms` dependency uses a path reference for local development. Change to pub.dev or git reference before publishing.
- Fields that need complex state management (chip_input, number_input) cannot use StatefulFieldWidget due to `createState()` conflict with abstract `buildWithTheme()` method.
- Flutter analyze will show ~14 info messages about doc comments and optional parameters - these are non-critical.
