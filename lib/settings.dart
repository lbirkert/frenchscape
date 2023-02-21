import "main.dart";

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import "package:flutter/material.dart";
import "package:objectbox/objectbox.dart";
import 'package:url_launcher/url_launcher.dart';

@Entity()
class Setting {
  @Id(assignable: true)
  int id;

  String value;
 
  Setting({
    this.id = 0,
    required this.value,
  });

  static ThemeMode get appearance {
    return {
      "dark": ThemeMode.dark,
      "light": ThemeMode.light,
    }[settingBox.get(1)?.value] ?? ThemeMode.system;
  }

  static set appearance(ThemeMode mode) {
    String value = {
      ThemeMode.dark: "dark",
      ThemeMode.light: "light"
    }[mode] ?? "system";

    themeNotifier.value = mode;

    settingBox.put(Setting(id: 1, value: value));
  }

  static Color get colorSchemeSeed {
    return Color(int.parse(
      settingBox.get(2)?.value ?? Colors.deepPurple.value.toString()
    ));
  }

  static set colorSchemeSeed(Color seed) {
    colorSchemeSeedNotifier.value = seed;

    settingBox.put(Setting(id: 2, value: seed.value.toString()));
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({ super.key });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
];

class _SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Settings", style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 10),
                const Text("Configure this application"),
                const SizedBox(height: 40),
                
                Text("Appearance", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                const Text("Options that control how this app looks"),
                const SizedBox(height: 20),
                
                DropdownButton(
                  value: Setting.appearance,
                  items: [
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.system,
                      child: Row(
                        children: const [
                          Icon(Icons.brightness_medium),
                          SizedBox(width: 10),
                          Text("System default"),
                        ]
                      )
                    ),
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.dark,
                      child: Row(
                        children: const [
                          Icon(Icons.dark_mode),
                          SizedBox(width: 10),
                          Text("Dark"),
                        ]
                      )
                    ),
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.light,
                      child: Row(
                        children: const [
                          Icon(Icons.light_mode),
                          SizedBox(width: 10),
                          Text("Light"),
                        ]
                      )
                    )
                  ],
                  onChanged: (ThemeMode? appearance) {
                    setState(() {
                      Setting.appearance = appearance!;
                    });
                  }
                ),
                const SizedBox(height: 10),
                BlockPicker(
                  availableColors: colors,
                  pickerColor: Setting.colorSchemeSeed,
                  onColorChanged: (Color c) {
                    Setting.colorSchemeSeed = c; 
                  },
                ),
                const SizedBox(height: 30),
                
                Text("About", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                const Text("Learn more about this project"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      child: const Text("Github"),
                      onPressed: () async {
                        final uri = Uri.parse("https://github.com/KekOnTheWorld/frenchscape");
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      }
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      child: const Text("Licenses"),
                      onPressed: () => showLicensePage(context: context)
                    )
                  ]
                )
              ]
            )
          )
        )
      )
    );
  }
}
