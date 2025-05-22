import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/localization_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final localizationService = context.watch<LocalizationService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.getString('settings')),
      ),
      body: ListView(
        children: [
          // Karanlık mod ayarı
          SwitchListTile(
            title: Text(localizationService.getString('dark_mode')),
            value: themeService.isDarkMode,
            onChanged: (value) => themeService.toggleDarkMode(),
            secondary: Icon(themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          Divider(),
          // Tema seçimi
          ListTile(
            title: Text(localizationService.getString('theme')),
            leading: Icon(Icons.color_lens),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: List.generate(themeService.themes.length, (index) {
                final theme = themeService.themes[index];
                return ChoiceChip(
                  label: Text(theme.name),
                  selected: themeService.selectedThemeIndex == index,
                  onSelected: (selected) {
                    if (selected) {
                      themeService.setTheme(index);
                    }
                  },
                );
              }),
            ),
          ),
          Divider(),
          // Dil seçimi
          ListTile(
            title: Text(localizationService.getString('language')),
            leading: Icon(Icons.language),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: localizationService.supportedLocales.map((locale) {
                return ChoiceChip(
                  label: Text(localizationService.getLanguageName(locale.languageCode)),
                  selected: localizationService.currentLocale.languageCode == locale.languageCode,
                  onSelected: (selected) {
                    if (selected) {
                      localizationService.setLocale(locale);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
} 