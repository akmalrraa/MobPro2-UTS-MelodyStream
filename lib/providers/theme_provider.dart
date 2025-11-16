import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppTheme { mainTheme, pastelBlue, pastelGreen, pastelPurple, pastelPink }

class ThemeState {
  final AppTheme currentTheme;

  ThemeState({required this.currentTheme});

  ThemeState copyWith({AppTheme? currentTheme}) {
    return ThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(currentTheme: AppTheme.mainTheme));

  void changeTheme(AppTheme theme) {
    state = state.copyWith(currentTheme: theme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

class AppThemes {
  static ThemeData getTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.mainTheme:
        return _mainTheme;
      case AppTheme.pastelBlue:
        return _pastelBlueTheme;
      case AppTheme.pastelGreen:
        return _pastelGreenTheme;
      case AppTheme.pastelPurple:
        return _pastelPurpleTheme;
      case AppTheme.pastelPink:
        return _pastelPinkTheme;
    }
  }

  static TextStyle poppins({double fontSize = 16, FontWeight fontWeight = FontWeight.normal, Color? color}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle inter({double fontSize = 16, FontWeight fontWeight = FontWeight.normal, Color? color}) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // MAIN THEME
  static final ThemeData _mainTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter', // Default font
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6366F1),
      secondary: Color(0xFF8B5CF6),
      background: Color(0xFF0F172A),
      surface: Color(0xFF1E293B),
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      displayLarge: poppins(fontSize: 32, fontWeight: FontWeight.w700),
      displayMedium: poppins(fontSize: 24, fontWeight: FontWeight.w600),
      displaySmall: poppins(fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: poppins(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: poppins(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: poppins(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: inter(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: inter(fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: inter(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: inter(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: inter(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: inter(fontSize: 10, fontWeight: FontWeight.w400),
    ),
  );

  // PASTEL BLUE THEME
  static final ThemeData _pastelBlueTheme = _mainTheme.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF87CEEB),
      secondary: Color(0xFFB6E2FF),
      background: Color(0xFF1E2A3A),
      surface: Color(0xFF2A3A4A),
      onBackground: Color(0xFFE8F4FF),
      onSurface: Color(0xFFE8F4FF),
    ),
    scaffoldBackgroundColor: const Color(0xFF1E2A3A),
  );

  // PASTEL GREEN THEME
  static final ThemeData _pastelGreenTheme = _mainTheme.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF98FB98),
      secondary: Color(0xFFC1E1C1),
      background: Color(0xFF1A2A1A),
      surface: Color(0xFF2A3A2A),
      onBackground: Color(0xFFF0FFF0),
      onSurface: Color(0xFFF0FFF0),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A2A1A),
  );

  // PASTEL PURPLE THEME
  static final ThemeData _pastelPurpleTheme = _mainTheme.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD8BFD8),
      secondary: Color(0xFFE6E6FA),
      background: Color(0xFF2A1A2A),
      surface: Color(0xFF3A2A3A),
      onBackground: Color(0xFFF8F0FF),
      onSurface: Color(0xFFF8F0FF),
    ),
    scaffoldBackgroundColor: const Color(0xFF2A1A2A),
  );

  // PASTEL PINK THEME
  static final ThemeData _pastelPinkTheme = _mainTheme.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFB6C1),
      secondary: Color(0xFFFFD1DC),
      background: Color(0xFF2A1A1A),
      surface: Color(0xFF3A2A2A),
      onBackground: Color(0xFFFFF0F5),
      onSurface: Color(0xFFFFF0F5),
    ),
    scaffoldBackgroundColor: const Color(0xFF2A1A1A),
  );

  // Helper methods
  static String getThemeName(AppTheme theme) {
    switch (theme) {
      case AppTheme.mainTheme:
        return 'Main Theme';
      case AppTheme.pastelBlue:
        return 'Pastel Blue';
      case AppTheme.pastelGreen:
        return 'Pastel Green';
      case AppTheme.pastelPurple:
        return 'Pastel Purple';
      case AppTheme.pastelPink:
        return 'Pastel Pink';
    }
  }

  static List<Color> getThemeGradient(AppTheme theme) {
    switch (theme) {
      case AppTheme.mainTheme:
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case AppTheme.pastelBlue:
        return [const Color(0xFF87CEEB), const Color(0xFFB6E2FF)];
      case AppTheme.pastelGreen:
        return [const Color(0xFF98FB98), const Color(0xFFC1E1C1)];
      case AppTheme.pastelPurple:
        return [const Color(0xFFD8BFD8), const Color(0xFFE6E6FA)];
      case AppTheme.pastelPink:
        return [const Color(0xFFFFB6C1), const Color(0xFFFFD1DC)];
    }
  }

  static List<Color> getBackgroundGradient(AppTheme theme) {
    switch (theme) {
      case AppTheme.mainTheme:
        return [const Color(0xFF0F172A), const Color(0xFF1E293B)];
      case AppTheme.pastelBlue:
        return [const Color(0xFF1E2A3A), const Color(0xFF2A3A4A)];
      case AppTheme.pastelGreen:
        return [const Color(0xFF1A2A1A), const Color(0xFF2A3A2A)];
      case AppTheme.pastelPurple:
        return [const Color(0xFF2A1A2A), const Color(0xFF3A2A3A)];
      case AppTheme.pastelPink:
        return [const Color(0xFF2A1A1A), const Color(0xFF3A2A2A)];
    }
  }
}