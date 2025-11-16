import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return IconButton(
      icon: Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.onBackground),
      onPressed: () {
        _showThemeDialog(context, themeState.currentTheme, themeNotifier);
      },
      tooltip: 'Change Theme',
    );
  }

  void _showThemeDialog(BuildContext context, AppTheme currentTheme, ThemeNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.palette_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Choose Theme',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                context,
                'Main Theme',
                AppTheme.mainTheme,
                currentTheme,
                notifier,
                const Color(0xFF6366F1),
              ),
              _buildThemeOption(
                context,
                'Pastel Blue',
                AppTheme.pastelBlue,
                currentTheme,
                notifier,
                const Color(0xFF87CEEB),
              ),
              _buildThemeOption(
                context,
                'Pastel Green',
                AppTheme.pastelGreen,
                currentTheme,
                notifier,
                const Color(0xFF98FB98),
              ),
              _buildThemeOption(
                context,
                'Pastel Purple',
                AppTheme.pastelPurple,
                currentTheme,
                notifier,
                const Color(0xFFD8BFD8),
              ),
              _buildThemeOption(
                context,
                'Pastel Pink',
                AppTheme.pastelPink,
                currentTheme,
                notifier,
                const Color(0xFFFFB6C1),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String name,
    AppTheme theme,
    AppTheme currentTheme,
    ThemeNotifier notifier,
    Color color,
  ) {
    final isSelected = currentTheme == theme;
    final gradientColors = AppThemes.getThemeGradient(theme);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: isSelected 
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              )
            : null,
        color: isSelected ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: color, width: 2) : Border.all(color: Colors.transparent),
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_rounded, color: color)
            : null,
        onTap: () {
          notifier.changeTheme(theme);
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}