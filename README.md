# ChampionForms ShadCN Fields

A comprehensive Flutter package that brings 21 beautiful form fields from [ShadCN Flutter](https://pub.dev/packages/shadcn_flutter) into [ChampionForms](https://github.com/ChampionForms/championforms), providing a seamless integration between these two powerful libraries.

## Features

- **21 Production-Ready Fields**: Complete collection of ShadCN Flutter form components
- **Type-Safe Converters**: Custom converters for complex data types (DateTime, Color, SliderValue, etc.)
- **ChampionForms Integration**: Full support for validation, onChange callbacks, and form state management
- **Theme Support**: Respects ChampionForms theme system for consistent styling
- **Easy Registration**: Single method call to register all fields

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  championforms: ^0.6.0
  shadcn_flutter: ^0.0.47
  championforms_shadcn_fields:
    path: path/to/championforms_shadcn_fields  # or use git/pub.dev when published
```

## Quick Start

### 1. Register Fields

Call `ShadcnFieldRegistry.registerAll()` at app startup:

```dart
import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';

void main() {
  // Register all ShadCN fields with ChampionForms
  ShadcnFieldRegistry.registerAll();

  runApp(MyApp());
}
```

### 2. Use Fields in Forms

```dart
import 'package:championforms/championforms.dart' as form;
import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';

final controller = form.FormController();

Widget build(BuildContext context) {
  return form.Form(
    controller: controller,
    fields: [
      form.TextField(
        id: 'name',
        title: 'Full Name',
        fieldBuilder: (ctx) => ShadcnTextInputWidget(context: ctx),
        validators: [
          form.Validator(
            validator: (r) => form.Validators.isEmpty(r),
            reason: 'Name is required',
          ),
        ],
      ),
      form.TextField(
        id: 'email',
        title: 'Email Address',
        fieldBuilder: (ctx) => ShadcnTextInputWidget(context: ctx),
      ),
      form.TextField(
        id: 'rating',
        title: 'Rate Us',
        fieldBuilder: (ctx) => ShadcnStarRatingWidget(context: ctx),
      ),
    ],
  );
}
```

### 3. Retrieve Form Values

```dart
final results = form.FormResults.getResults(controller: controller);

if (!results.errorState) {
  final name = results.grab('name').asString();
  final email = results.grab('email').asString();
  final rating = results.grab('rating').asString();

  print('Name: $name, Email: $email, Rating: $rating');
}
```

## Available Fields

### Text Input Fields (Group 1)

| Field | Widget | Value Type | Use Case |
|-------|--------|------------|----------|
| Text Input | `ShadcnTextInputWidget` | `String` | Single-line text input |
| Text Area | `ShadcnTextAreaWidget` | `String` | Multi-line text input |
| Formatted Input | `ShadcnFormattedInputWidget` | `String` | Structured data (dates, credit cards) |
| Phone Input | `ShadcnPhoneInputWidget` | `String` | International phone numbers |

### Selection Fields (Groups 2 & 3)

| Field | Widget | Value Type | Use Case |
|-------|--------|------------|----------|
| Checkbox | `ShadcnCheckboxWidget` | `bool` | Single checkbox |
| Switch | `ShadcnSwitchWidget` | `bool` | Toggle switch |
| Toggle | `ShadcnToggleWidget` | `bool` | Toggle button |
| Radio Group | `ShadcnRadioGroupWidget` | `String` | Single selection from options |
| Radio Card | `ShadcnRadioCardWidget` | `String` | Card-based radio selection |
| Select | `ShadcnSelectWidget` | `String` | Dropdown selection |
| Multi Select | `ShadcnMultiSelectWidget` | `List<FieldOption>` | Multiple selection |
| Item Picker | `ShadcnItemPickerWidget` | `String` | Item picker with popover |

### Input Enhancement & Numeric Fields (Group 4)

| Field | Widget | Value Type | Use Case |
|-------|--------|------------|----------|
| AutoComplete | `ShadcnAutoCompleteWidget` | `String` | Text with suggestions |
| Chip Input | `ShadcnChipInputWidget` | `List<String>` | Tag/chip input |
| Number Input | `ShadcnNumberInputWidget` | `num` | Numeric with spinner controls |
| Slider | `ShadcnSliderWidget` | `SliderValue` | Single or range slider |

### Special Fields (Group 5)

| Field | Widget | Value Type | Use Case |
|-------|--------|------------|----------|
| Star Rating | `ShadcnStarRatingWidget` | `double` | Star rating (supports half-stars) |
| Date Picker | `ShadcnDatePickerWidget` | `DateTime` | Date selection |
| Time Picker | `ShadcnTimePickerWidget` | `TimeOfDay` | Time selection |
| Input OTP | `ShadcnInputOTPWidget` | `String` | One-time password input |

### Color Picker (Group 6)

| Field | Widget | Value Type | Use Case |
|-------|--------|------------|----------|
| Color Picker | `ShadcnColorPickerWidget` | `Color` | Color selection |

## Field Usage Examples

### Text Input
```dart
form.TextField(
  id: 'username',
  title: 'Username',
  description: 'Choose a unique username',
  fieldBuilder: (ctx) => ShadcnTextInputWidget(context: ctx),
)
```

### Checkbox
```dart
form.TextField(
  id: 'terms',
  title: 'I agree to the terms',
  fieldBuilder: (ctx) => ShadcnCheckboxWidget(context: ctx),
  validators: [
    form.Validator(
      validator: (r) => !r.asBool(),
      reason: 'You must accept the terms',
    ),
  ],
)
```

### Select with Options
```dart
form.TextField(
  id: 'country',
  title: 'Country',
  fieldBuilder: (ctx) => ShadcnSelectWidget(
    context: ctx,
    options: [
      form.FieldOption(label: 'United States', value: 'usa'),
      form.FieldOption(label: 'Canada', value: 'canada'),
      form.FieldOption(label: 'Mexico', value: 'mexico'),
    ],
  ),
)
```

### Date Picker
```dart
form.TextField(
  id: 'birthdate',
  title: 'Date of Birth',
  fieldBuilder: (ctx) => ShadcnDatePickerWidget(context: ctx),
)

// Retrieve as DateTime
final results = form.FormResults.getResults(controller: controller);
final dateStr = results.grab('birthdate').asString(); // ISO 8601 format
final birthdate = DateTime.parse(dateStr);
```

### Slider
```dart
form.TextField(
  id: 'volume',
  title: 'Volume',
  fieldBuilder: (ctx) => ShadcnSliderWidget(
    context: ctx,
    min: 0,
    max: 100,
    divisions: 10,
    showLabel: true,
  ),
)
```

### Color Picker
```dart
form.TextField(
  id: 'theme_color',
  title: 'Theme Color',
  fieldBuilder: (ctx) => ShadcnColorPickerWidget(context: ctx),
)

// Retrieve as hex string
final results = form.FormResults.getResults(controller: controller);
final colorHex = results.grab('theme_color').asString(); // "#3b82f6"
```

### Multi Select
```dart
form.TextField(
  id: 'interests',
  title: 'Interests',
  fieldBuilder: (ctx) => ShadcnMultiSelectWidget(
    context: ctx,
    options: [
      form.FieldOption(label: 'Sports', value: 'sports'),
      form.FieldOption(label: 'Music', value: 'music'),
      form.FieldOption(label: 'Reading', value: 'reading'),
      form.FieldOption(label: 'Gaming', value: 'gaming'),
    ],
  ),
)

// Retrieve as list of strings
final results = form.FormResults.getResults(controller: controller);
final interests = results.grab('interests').asStringList(); // ['sports', 'music']
```

### Chip Input
```dart
form.TextField(
  id: 'tags',
  title: 'Tags',
  fieldBuilder: (ctx) => ShadcnChipInputWidget(context: ctx),
)

// Retrieve as list of strings
final results = form.FormResults.getResults(controller: controller);
final tags = results.grab('tags').asStringList(); // ['flutter', 'dart']
```

## Custom Converters

This package provides custom type converters for complex field types:

- **BoolFieldConverters**: For Checkbox, Switch, Toggle (bool values)
- **ChipInputConverters**: For Chip Input (List<String> values)
- **SliderConverters**: For Slider (SliderValue → double conversion)
- **DateTimeConverters**: For Date Picker (DateTime → ISO 8601 string)
- **TimeConverters**: For Time Picker (TimeOfDay → HH:mm string)
- **ColorConverters**: For Color Picker (Color → hex string)

## Architecture

### StatefulFieldWidget Pattern

Most fields extend `StatefulFieldWidget` from ChampionForms, providing:
- Automatic lifecycle management
- Built-in change detection
- Automatic validation on focus loss
- Theme-aware rendering

Example structure:
```dart
class ShadcnFieldWidget extends form.StatefulFieldWidget {
  const ShadcnFieldWidget({required super.context});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final value = ctx.getValue<ValueType>();

    return Column(
      children: [
        if (ctx.field.title != null)
          Text(ctx.field.title!, style: theme.titleStyle),
        shadcn.ShadcnComponent(
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

## Validation

All fields work seamlessly with ChampionForms validators:

```dart
form.TextField(
  id: 'email',
  title: 'Email',
  fieldBuilder: (ctx) => ShadcnTextInputWidget(context: ctx),
  validators: [
    form.Validator(
      validator: (r) => form.Validators.isEmpty(r),
      reason: 'Email is required',
    ),
    form.Validator(
      validator: (r) {
        final email = r.asString();
        return !email.contains('@');
      },
      reason: 'Please enter a valid email',
    ),
  ],
)
```

## Theme Integration

Fields automatically use ChampionForms theme colors and styles:

```dart
final theme = form.FormTheme(
  normalColors: form.FieldColorScheme(
    backgroundColor: Colors.white,
    borderColor: Colors.grey,
    textColor: Colors.black,
  ),
  titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  descriptionStyle: TextStyle(fontSize: 14, color: Colors.grey),
);

form.Form(
  controller: controller,
  theme: theme,
  fields: [
    // Fields will automatically use theme colors and styles
  ],
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package follows the same license as ChampionForms.

## Credits

- **ChampionForms**: Powerful form management for Flutter
- **ShadCN Flutter**: Beautiful, accessible UI components
- Built with ❤️ by the ChampionForms community

## Links

- [ChampionForms Documentation](https://github.com/ChampionForms/championforms)
- [ShadCN Flutter Documentation](https://shadcn-flutter.mariuti.com)
- [Issue Tracker](https://github.com/your-repo/championforms_shadcn_fields/issues)
