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

final theme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
  )
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
  )
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  themeNotifier = ValueNotifier<ThemeMode>(Setting.appearance);

  runApp(const FrenchscapeApp());
}

class FrenchscapeApp extends StatelessWidget {
  const FrenchscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: currentMode,
          home: const Frenchscape()
        );
      }
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
