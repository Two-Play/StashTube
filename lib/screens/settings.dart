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

  bool t = false;

  @override
  Widget build(BuildContext context) {
    final brightnessPreference =
        ThemeManager.of(context).state.brightnessPreference;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SettingsList(
sections: [
          SettingsSection(
            //margin: EdgeInsetsDirectional.all(50),
            title: Text('Brightness'),
            tiles: [
              // switch tile witch switch between true and false on taping
              SettingsTile.switchTile(
                title: Text('Dark Mode'),
                leading: Icon(Icons.nightlight_round),
                onToggle: (bool value) {
                  //t = !t;
                  setState(() {
                    t = value;
                  });
                  print(t);
                }, initialValue: t,
              ),
              CustomSettingsTile(child:
              // segment button with 3 options
              SegmentedButton(
                segments: [
                  ButtonSegment(
                    label: Text('Light'),
                    value: BrightnessPreference.light,
                  ),
                  ButtonSegment(
                    label: Text('System'),
                    value: BrightnessPreference.system,
                  ),
                  ButtonSegment(
                    label: Text('Dark'),
                    value: BrightnessPreference.dark,
                  ),
                ], selected: {brightnessPreference},
                onSelectionChanged: (Set<BrightnessPreference> value) {

                  setState(() {
                    // set the value of the segment button
                    ThemeManager.of(context).setBrightness(value.first);
                  });
                },
              )
              ),


            ],
          ),
        ],
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