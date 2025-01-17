import "package:flutter/material.dart";
import "package:tackle_time/utils/constants/border_radius.dart";
import "package:tackle_time/utils/constants/open_color.dart";
import "package:tackle_time/utils/constants/text_theme.dart";
import "package:flutter/services.dart";

/*

Theme order:

- Main Theme
- ElevatedButton
- FilledButton
- OutlinedButton
- TextButton
- FloatingActionButton
- Appbar
- Card
- InputDecoration
- TextSelection

 */

class AppTheme {

  AppTheme._();

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: "Satoshi",
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: OpenColor.blue600,
      brightness: Brightness.light,
      primary: OpenColor.blue600,
      primaryFixed: OpenColor.blue400,
      secondary: OpenColor.green600,
      secondaryFixed: OpenColor.green300,
      onSurfaceVariant: OpenColor.gray600,
      onSurface: OpenColor.gray700,
      surface: Colors.white,
      surfaceBright: Colors.white,
      surfaceDim: OpenColor.gray50,
      surfaceContainer: OpenColor.gray100,
      surfaceContainerHigh: OpenColor.gray200,
      surfaceContainerHighest: OpenColor.gray300,
      outline: OpenColor.gray400,
      outlineVariant: OpenColor.gray300,
      error: OpenColor.red600,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      surfaceTint: OpenColor.gray500.withValues(alpha: 0.3),
    ),
    textTheme: AppTextTheme.theme,
    elevatedButtonTheme: AppElevatedButtonTheme.theme,
    filledButtonTheme: AppFilledButtonTheme.theme,
    outlinedButtonTheme: AppOutlinedButtonTheme.theme,
    textButtonTheme: AppTextButtonTheme.theme,
    appBarTheme: AppAppBarTheme.theme,
    floatingActionButtonTheme: AppFloatingActionButtonTheme.theme,
    cardTheme: AppCardTheme.theme,
    inputDecorationTheme: AppInputDecorationTheme.theme,
    textSelectionTheme: AppTextSelectionTheme.theme,
    switchTheme: AppSwitchTheme.theme
  );

}

class AppElevatedButtonTheme {

  AppElevatedButtonTheme._();

  static final theme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius)
      )
  );

}

class AppFilledButtonTheme {

  AppFilledButtonTheme._();

  static final theme = FilledButtonThemeData(
      style: FilledButton.styleFrom(
          elevation: 0,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius)
      )
  );

}

class AppOutlinedButtonTheme {

  AppOutlinedButtonTheme._();

  static final theme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          side: const BorderSide(color: OpenColor.gray400, width: 1),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius)
      )
  );

}

class AppTextButtonTheme {

  AppTextButtonTheme._();

  static final theme = TextButtonThemeData(
      style: TextButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius)
      )
  );

}

class AppFloatingActionButtonTheme {

  AppFloatingActionButtonTheme._();

  static final theme = FloatingActionButtonThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.defaultBorderRadius)
  );

}

class AppAppBarTheme {

  AppAppBarTheme._();

  static const theme = AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: OpenColor.gray50,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      // Status bar color
      statusBarColor: Colors.transparent,

      // Status bar brightness (optional)
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ),
  );

}

class AppCardTheme {

  AppCardTheme._();

  static final theme = CardTheme(
    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.largeBorderRadius),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent
  );

}

class AppInputDecorationTheme {

  AppInputDecorationTheme._();

  static final theme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: AppBorderRadius.defaultBorderRadius
    )
  );
}

class AppTextSelectionTheme {

  AppTextSelectionTheme._();

  static const theme = TextSelectionThemeData(
    cursorColor: OpenColor.blue400,
    selectionColor: OpenColor.blue100,
    selectionHandleColor: OpenColor.blue400
  );

}

class AppSwitchTheme {

  AppSwitchTheme._();

  static final theme = SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return OpenColor.blue400;
      }
      return OpenColor.gray800;
    }),
    thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return OpenColor.blue800;
      }
      return OpenColor.gray500;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return OpenColor.blue400;
      }
      return OpenColor.gray800;
    }),
  );

}