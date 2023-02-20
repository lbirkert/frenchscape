import "vocs.dart";
import "settings.dart";
import "insights.dart";

import 'package:flutter/material.dart';
import "package:objectbox/objectbox.dart";
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';

late ObjectBox objectbox;
late Box<Voc> vocBox; 
late Box<VocCol> vocColBox;
late Box<Setting> settingBox;

class ObjectBox {
  late final Store store;
  
  ObjectBox._create(this.store) {
    vocBox = store.box<Voc>();
    vocColBox = store.box<VocCol>();
    settingBox = store.box<Setting>();
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: path.join(docsDir.path, "store"));
    return ObjectBox._create(store);
  }
}

late ValueNotifier<ThemeMode> themeNotifier;
late ValueNotifier<Color> colorSchemeSeedNotifier;

const textTheme = TextTheme(
  headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
  headlineMedium: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
);

final theme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  textTheme: textTheme
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'Inter',
  textTheme: textTheme
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  themeNotifier = ValueNotifier<ThemeMode>(Setting.appearance);
  colorSchemeSeedNotifier = ValueNotifier<Color>(Setting.colorSchemeSeed);

  runApp(const FrenchscapeApp());
}

class FrenchscapeApp extends StatelessWidget {
  const FrenchscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: colorSchemeSeedNotifier,
      builder: (_, Color seed, __) =>
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.copyWith(
                colorScheme: ColorScheme.fromSeed(seedColor: seed)
              ),
              darkTheme: darkTheme.copyWith(
                colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)
              ),
              themeMode: currentMode,
              home: const Frenchscape()
            )
      )
    );
  }
}

class Frenchscape extends StatefulWidget {
  const Frenchscape({super.key});

  @override
  State<Frenchscape> createState() => _FrenchscapeState();
}

class _FrenchscapeState extends State<Frenchscape> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.school_outlined),
            label: 'Vocs',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.analytics),
            icon: Icon(Icons.analytics_outlined),
            label: 'Insights',
          ),
        ],
      ),
      body: SafeArea(child: [
        const VocPage(),
        const SettingsPage(),
        const InsightsPage()
      ][currentPageIndex])
    );
  }
}
