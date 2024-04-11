import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stash_app_mobile/functions/storage.dart';
import 'package:theme_manager/theme_manager.dart';

import 'login.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: ListView(
        children: [
                // segmented button with 3 options
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
          ),

          // logout button
          ElevatedButton(
            onPressed: () {
              // navigate to the login page
              Navigator.push(context, CupertinoPageRoute(builder: (context) => const LoginPage()));
              // remove the token from the storage
              //removeKey('url');
            },
            child: const Text('Logout'),
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
}