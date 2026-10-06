// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../common/constants/app_constants.dart';
import '../../domain/repos/prefs_repo.dart';
import '../di/injectable.dart';
import '../utils/app_util.dart';
import 'theme_colors.dart';

class AppTheme {
  AppTheme._();

  static String currentTheme() {
    var prefRepo = getIt<PrefsRepo>();
    return getThemeModeString(prefRepo.getThemeMode());
  }

  static ThemeData _build({
    required Color scaffold,
    required ColorScheme scheme,
    required Color appBar,
    required double appBarElevation,
    required Color navBackground,
    required Color navForeground,
    required CardThemeData card,
    required Color dialog,
  }) {
    const family = AppConstants.kFontFamily;
    return ThemeData(
      scaffoldBackgroundColor: scaffold,
      fontFamily: family,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: appBar,
        foregroundColor: Colors.white,
        elevation: appBarElevation,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navBackground,
        indicatorColor: ThemeColors.accent,
        elevation: 3,
        iconTheme: WidgetStateProperty.all(IconThemeData(color: navForeground)),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(color: navForeground, fontFamily: family),
        ),
      ),
      cardTheme: card,
      dialogTheme: DialogThemeData(
        backgroundColor: dialog,
        surfaceTintColor: dialog,
      ),
    );
  }

  static ThemeData lightTheme() => _build(
        scaffold: ThemeColors.lightGray,
        scheme: const ColorScheme.light(
        primary: ThemeColors.primary,
        onPrimary: Colors.white,
        primaryContainer: ThemeColors.primary,
        secondary: ThemeColors.primary1,
        onSecondary: Colors.white,
        secondaryContainer: ThemeColors.accent1,
        tertiary: ThemeColors.accent2,
        onTertiary: Colors.white,
        tertiaryContainer: ThemeColors.accent3,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceVariant: ThemeColors.backgroundGrey,
        onSurfaceVariant: ThemeColors.mediumGrey,
        background: ThemeColors.lightGray,
        onBackground: Colors.black,
        error: ThemeColors.error,
        onError: Colors.white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        outline: ThemeColors.primary,
        outlineVariant: ThemeColors.lightGrey,
        shadow: ThemeColors.shadow,
        surfaceTint: ThemeColors.primary,
        inverseSurface: Colors.black,
        onInverseSurface: Colors.white,
        inversePrimary: ThemeColors.primaryDark2,
        scrim: Color(0x52000000),
      ),
        appBar: ThemeColors.primary,
        appBarElevation: 3,
        navBackground: Colors.white,
        navForeground: ThemeColors.primary,
        card: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 2,
        ),
        dialog: Colors.white,
      );

  static ThemeData darkTheme() => _build(
        scaffold: Colors.black,
        scheme: const ColorScheme.dark(
        primary: ThemeColors.primary2,
        onPrimary: ThemeColors.primaryDark1,
        primaryContainer: ThemeColors.primaryDark,
        secondary: ThemeColors.accent1,
        onSecondary: ThemeColors.primaryDark1,
        secondaryContainer: ThemeColors.primaryDark2,
        tertiary: ThemeColors.accent3,
        onTertiary: Colors.black,
        tertiaryContainer: ThemeColors.primary3,
        surface: ThemeColors.primaryDark,
        onSurface: Colors.white,
        surfaceVariant: ThemeColors.primaryDark1,
        onSurfaceVariant: ThemeColors.accent1,
        background: ThemeColors.primaryDark2,
        onBackground: Colors.white,
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        outline: ThemeColors.primaryDark1,
        outlineVariant: ThemeColors.primaryDark,
        shadow: Colors.black,
        surfaceTint: ThemeColors.primary2,
        inverseSurface: Colors.white,
        onInverseSurface: ThemeColors.primaryDark1,
        inversePrimary: ThemeColors.accent1,
        scrim: Color(0x52000000),
      ),
        appBar: ThemeColors.primaryDark2,
        appBarElevation: 1,
        navBackground: ThemeColors.primaryDark,
        navForeground: Colors.white,
        card: CardThemeData(
          color: ThemeColors.primaryDark1,
          surfaceTintColor: ThemeColors.primaryDark1,
          shadowColor: ThemeColors.primaryDark,
        ),
        dialog: ThemeColors.primaryDark,
      );
}
