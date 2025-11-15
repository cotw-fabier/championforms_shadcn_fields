# ShadCN Fields Example

Example app demonstrating the integration of ShadCN Flutter UI components with ChampionForms.

## About

This example showcases all 21 ShadCN Flutter form fields registered with ChampionForms, including:

- **Text Input Fields**: text_input, text_area, formatted_input, phone_input, autocomplete, input_otp
- **Selection Fields**: checkbox, switch, toggle, radio_group, radio_card, select, multiselect, item_picker
- **Numeric & Special Fields**: chip_input, number_input, slider, star_rating, date_picker, time_picker, color_picker

## Features

- 4 demo screens showcasing different field types
- Form validation examples
- Form submission with results display
- Multi-platform support (iOS, Android, Web, macOS, Windows)

## Running the Example

### Prerequisites

- Flutter SDK (^3.11.0)
- Platform-specific requirements:
  - **iOS**: Xcode and CocoaPods
  - **Android**: Android Studio or Android SDK
  - **macOS**: Xcode
  - **Windows**: Visual Studio 2022 with C++ development tools
  - **Web**: Chrome browser

### Run on Different Platforms

```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific platforms:
flutter run -d chrome              # Web
flutter run -d macos               # macOS
flutter run -d windows             # Windows
flutter run -d <device-id>         # iOS/Android (use `flutter devices` to list)
```

### Build for Production

```bash
# Web
flutter build web

# iOS
flutter build ios

# Android
flutter build apk       # or 'flutter build appbundle'

# macOS
flutter build macos

# Windows
flutter build windows
```

## Project Structure

```
lib/
├── main.dart                      # App entry point with navigation
└── screens/
    ├── text_fields_demo.dart      # Text input field demonstrations
    ├── selection_fields_demo.dart # Selection field demonstrations
    ├── numeric_fields_demo.dart   # Numeric input demonstrations
    └── special_fields_demo.dart   # ShadCN fields registry overview
```

## Learn More

- [ChampionForms Documentation](https://github.com/fabier/championforms)
- [ShadCN Flutter Documentation](https://shadcn-flutter.marionauta.com/)
- [Flutter Documentation](https://docs.flutter.dev/)
