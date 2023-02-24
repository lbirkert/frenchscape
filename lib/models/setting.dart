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

  @Transient()
  static ThemeMode get appearance {
    return {
          "dark": ThemeMode.dark,
          "light": ThemeMode.light,
        }[settingBox.get(1)?.value] ??
        ThemeMode.system;
  }

  @Transient()
  static set appearance(ThemeMode mode) {
    String value =
        {ThemeMode.dark: "dark", ThemeMode.light: "light"}[mode] ?? "system";

    themeNotifier.value = mode;

    settingBox.put(Setting(id: 1, value: value));
  }

  @Transient()
  static Color get colorSchemeSeed {
    return Color(int.parse(
        settingBox.get(2)?.value ?? Colors.deepPurple.value.toString()));
  }

  @Transient()
  static set colorSchemeSeed(Color seed) {
    colorSchemeSeedNotifier.value = seed;

    settingBox.put(Setting(id: 2, value: seed.value.toString()));
  }
}
