import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stash_app_mobile/util/observable.dart';
import 'package:theme_manager/theme_manager.dart';

import '../../Controler/screens/settings_controller.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> implements Observer {
  bool isSelected = false;
  BrightnessPreference brightnessPreference = BrightnessPreference.system;

  void toggleSwitch(bool value) {
    setState(() {
      isSelected = !isSelected;
    });
  }

  final _settingsController = SettingsController();

  @override
  void initState() {
    super.initState();
    _settingsController.addListener(this);
    brightnessPreference = ThemeManager.of(context).state.brightnessPreference;
  }

  @override
  void dispose() {
    _settingsController.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: ListView(
          children: [
            // Segmented button with 3 theme options
            SegmentedButton<BrightnessPreference>(
              segments: const <ButtonSegment<BrightnessPreference>>[
                ButtonSegment<BrightnessPreference>(
                  value: BrightnessPreference.light,
                  label: Text('Light'),
                  icon: Icon(Icons.wb_sunny),
                ),
                ButtonSegment<BrightnessPreference>(
                  value: BrightnessPreference.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment<BrightnessPreference>(
                  value: BrightnessPreference.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.brightness_3),
                ),
              ],
              selected: <BrightnessPreference>{brightnessPreference},
              onSelectionChanged: (Set<BrightnessPreference> newSelection) {
                setState(() {
                  brightnessPreference = newSelection.first;
                  ThemeManager.of(context).setBrightness(newSelection.first);
                });
              },
            ),

            // Logout button
            ElevatedButton(
              onPressed: () {
                // Navigate to the login page
                Navigator.push(context, CupertinoPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text('Logout'),
            ),
            ListTile(
              title: const Text("Title"),
              subtitle: Text(isSelected ? "Selected" : 'Not Selected'),
              trailing: Switch(
                value: isSelected,
                onChanged: toggleSwitch,
                activeColor: Colors.orange,
              ),
            ),
          ],
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

  @override
  void update(ObserverEvent event) {
    switch (event) {
      default:
        print("default event");
        break;
    }
  }
}