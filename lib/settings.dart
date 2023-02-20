import "main.dart";

import "package:flutter/material.dart";
import "package:objectbox/objectbox.dart";

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
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({ super.key });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Text("Settings", style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 10),
                const Text("Configure this application"),
                const SizedBox(height: 30),
                Text("Appearance", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
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
                )
              ]
            )
          )
        )
      )
    );
  }
}
