import "package:frenchscape/frenchscape.dart";

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
        }[settingBox.get(1)?.value] ??
        ThemeMode.system;
  }

  static set appearance(ThemeMode mode) {
    String value =
        {ThemeMode.dark: "dark", ThemeMode.light: "light"}[mode] ?? "system";

    themeNotifier.value = mode;

    settingBox.put(Setting(id: 1, value: value));
  }

  static Color get colorSchemeSeed {
    return Color(int.parse(
        settingBox.get(2)?.value ?? Colors.deepPurple.value.toString()));
  }

  static set colorSchemeSeed(Color seed) {
    colorSchemeSeedNotifier.value = seed;

    settingBox.put(Setting(id: 2, value: seed.value.toString()));
  }
}
