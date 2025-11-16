import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeData = AppThemes.getTheme(themeState.currentTheme);

    return MaterialApp(
      title: 'Melody Stream',
      theme: themeData,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}