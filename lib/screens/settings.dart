import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:stash_app_mobile/functions/storage.dart';
import 'package:theme_manager/theme_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final brightnessPreference =
        ThemeManager.of(context).state.brightnessPreference;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  brightnessPreference.isSystem ? Colors.red : Colors.blue,
                ),
                onPressed: () => ThemeManager.of(context)
                    .setBrightness(BrightnessPreference.system),
                child: const Text('System'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  brightnessPreference.isSystem ? Colors.red : Colors.blue,
                ),
                onPressed: () => ThemeManager.of(context)
                    .setBrightness(BrightnessPreference.light),
                child: const Text('Light'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  brightnessPreference.isSystem ? Colors.red : Colors.blue,
                ),
                onPressed: () => ThemeManager.of(context)
                    .setBrightness(BrightnessPreference.dark),
                child: const Text('Dark'),
              ),
              ElevatedButton(onPressed: () => (removeKey("url")), child: const Text('remove key')),
            ],
          ),
        ),
      ),



        floatingActionButton: FloatingActionButton(
        onPressed: () {
          ThemePickerDialog.show(context, (preference) {
            ThemeManager.of(context).setBrightness(preference);
          });
        },
        child: ThemeBuilder(
          builder: (context, themeState) {
            switch (themeState.brightnessPreference) {
              case BrightnessPreference.light:
                return const Icon(Icons.wb_sunny);
              case BrightnessPreference.dark:
                return const Icon(Icons.brightness_3);
              default:
                return const Icon(Icons.brightness_auto);
            }
          },
        ),
      ),
    );
  }
}