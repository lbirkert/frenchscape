import "frenchscape.dart";

const textTheme = TextTheme(
  headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
  headlineMedium: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
  headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
  titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBox.create();

  runApp(const FrenchscapeApp());
}

class FrenchscapeApp extends StatelessWidget {
  const FrenchscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: colorSchemeSeedNotifier,
      builder: (_, Color seed, __) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Inter',
              textTheme: textTheme,
              colorSchemeSeed: seed),
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              fontFamily: 'Inter',
              textTheme: textTheme,
              colorSchemeSeed: seed),
          themeMode: currentMode,
          home: const Frenchscape(),
        ),
      ),
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
      body: [
        const CollectionsPage(),
        const SettingsPage(),
        const InsightsPage()
      ][currentPageIndex],
    );
  }
}
