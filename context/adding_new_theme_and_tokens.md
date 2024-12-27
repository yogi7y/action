# Guide: Adding New Component Themes

This guide outlines the process of adding new component themes to maintain consistency and follow established patterns in the codebase.

## Overview

1. Create base semantic token class
2. Create theme variants (light/dark)
3. Update base theme class
4. Initialize in theme classes
5. Follow key guidelines

## 1. Create Base Semantic Token Class

Always start by defining the base semantic token class in `lib/src/design_system/themes/base/semantics/`

```dart
@immutable
abstract class NewComponentTokens {
  const NewComponentTokens({
    required this.background,
    required this.text,
    required this.border,
  });

  final Color background;
  final Color text;
  final Color border;
}
```

Key points:

- Use clear, semantic property names
- Make class abstract and immutable
- Use final properties instead of getters

## 2. Create Theme Variants

Prefer using existing primitive tokens. The name will be specified like `surface/background` etc. and see if it is present and use that.
In case a primitive token is not available, then directly add the colour value.

### Light Theme

Create in `lib/src/design_system/themes/light/semantics/new_component.dart`:

```dart
@immutable
class LightNewComponentDefaultTokens extends LightBaseTheme implements NewComponentTokens {
  LightNewComponentDefaultTokens({required super.primitiveTokens})
      : background = primitiveTokens.neutral.shade100,
        text = primitiveTokens.neutral.shade700,
        border = primitiveTokens.neutral.shade200;

  @override
  final Color background;
  @override
  final Color text;
  @override
  final Color border;
}

// Additional variants as needed
@immutable
class LightNewComponentSelectedTokens extends LightBaseTheme implements NewComponentTokens {
  // Follow same pattern as above
}
```

### Dark Theme

Create in `lib/src/design_system/themes/dark/semantics/new_component.dart`:

```dart
@immutable
class DarkNewComponentDefaultTokens extends DarkBaseTheme implements NewComponentTokens {
  DarkNewComponentDefaultTokens({required super.primitiveTokens})
      : background = const Color(0xFF172554),
        text = const Color(0xFF60A5FA),
        border = primitiveTokens.neutral.shade800;

  @override
  final Color background;
  @override
  final Color text;
  @override
  final Color border;
}

// Additional variants as needed
```

## 3. Update Base Theme Class

Add the new component tokens to `lib/src/design_system/themes/base/theme.dart`:

```dart
@immutable
abstract class AppTheme extends BaseTheme {
  const AppTheme({
    // ... existing parameters
    required this.newComponentDefault,
    required this.newComponentSelected,
  });

  // ... existing fields
  final NewComponentTokens newComponentDefault;
  final NewComponentTokens newComponentSelected;
}
```

## 4. Initialize in Theme Classes

### Light Theme

Update `lib/src/design_system/themes/light/light_theme.dart`:

```dart
@immutable
class LightTheme extends LightBaseTheme implements AppTheme {
  LightTheme({required super.primitiveTokens})
      : newComponentDefault = LightNewComponentDefaultTokens(primitiveTokens: primitiveTokens),
        newComponentSelected = LightNewComponentSelectedTokens(primitiveTokens: primitiveTokens),
        // ... other initializations
}
```

### Dark Theme

Update `lib/src/design_system/themes/dark/dark_theme.dart`:

```dart
@immutable
class DarkTheme extends DarkBaseTheme implements AppTheme {
  DarkTheme({required super.primitiveTokens})
      : newComponentDefault = DarkNewComponentDefaultTokens(primitiveTokens: primitiveTokens),
        newComponentSelected = DarkNewComponentSelectedTokens(primitiveTokens: primitiveTokens),
        // ... other initializations
}
```

## Key Guidelines

### 1. Reference Existing Components

- Look at `Checkbox`, `Status`, `Button` implementations for patterns
- Follow similar file structure and naming conventions
- Review existing components for best practices

### 2. Color Values

- Use exact color values from design
- Use primitive tokens when appropriate (like neutral shades)
- Include opacity values if specified in design
- Double-check all color values match design exactly

### 3. Properties vs Getters

- Always use final properties initialized in constructor
- Avoid getters for color values
- Initialize all values in constructor

### 4. Immutability

- Mark all classes with @immutable
- Use final for all properties
- Ensure proper const constructors

### 5. Documentation

- Add comments for complex tokens
- Document any special color handling
- Explain any deviations from standard patterns

## Example Usage

```dart
final _colors = ref.watch(appThemeProvider);

Container(
  color: _colors.newComponentDefault.background,
  child: Text(
    'Example',
    style: TextStyle(color: _colors.newComponentDefault.text),
  ),
)
```

## Common Mistakes to Avoid

1. Using getters instead of final properties
2. Missing @immutable annotation
3. Not using primitive tokens where appropriate
4. Incorrect color values that don't match design
5. Forgetting to initialize variants in theme classes
6. Not following existing naming patterns
