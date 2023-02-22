import "package:frenchscape/frenchscape.dart";

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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

class _SettingsPageState extends State<SettingsPage> {
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
                Text("Settings",
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 10),
                const Text("Configure this application"),
                const SizedBox(height: 40),
                Text("Appearance",
                    style: Theme.of(context).textTheme.headlineMedium),
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
                        ],
                      ),
                    ),
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.dark,
                      child: Row(
                        children: const [
                          Icon(Icons.dark_mode),
                          SizedBox(width: 10),
                          Text("Dark"),
                        ],
                      ),
                    ),
                    DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.light,
                      child: Row(
                        children: const [
                          Icon(Icons.light_mode),
                          SizedBox(width: 10),
                          Text("Light"),
                        ],
                      ),
                    )
                  ],
                  onChanged: (ThemeMode? appearance) {
                    setState(() {
                      Setting.appearance = appearance!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                BlockPicker(
                  availableColors: colors,
                  pickerColor: Setting.colorSchemeSeed,
                  onColorChanged: (Color c) {
                    Setting.colorSchemeSeed = c;
                  },
                ),
                Text("About",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                const Text("Learn more about this project"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      child: const Text("Github"),
                      onPressed: () async {
                        final uri = Uri.parse(
                            "https://github.com/KekOnTheWorld/frenchscape");
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                        child: const Text("Licenses"),
                        onPressed: () => showLicensePage(context: context))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
