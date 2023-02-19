import "vocs.dart";

import 'package:flutter/material.dart';
import "package:objectbox/objectbox.dart";


late ObjectBox objectbox;
late Box<Voc> vocBox; 
late Box<VocCol> vocColBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();
  vocBox = objectbox.store.box<Voc>();
  vocColBox = objectbox.store.box<VocCol>();
      
  var theme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
    )
  );

  runApp(FrenchscapeApp(theme: theme));
}

class FrenchscapeApp extends StatelessWidget {
  const FrenchscapeApp({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const Frenchscape()
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
            const VocPage(),
            Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text('Page 2'),
            ),
            Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Page 3'),
            ),
          ][currentPageIndex]
    );
  }
}

// TODO: rename to Vocabulary
class VocPage extends StatefulWidget {
  const VocPage({super.key});

  @override
  State<VocPage> createState() => _VocPageState();
}

class _VocPageState extends State<VocPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Stack(children: [
        Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Vocabulary', style: Theme.of(context).textTheme.headlineLarge!),
            const Text('Tap the New Button to create a new Vocabulary Set.')
          ],
        )),
        Positioned(
          bottom: 0,
          left: 0,
          child: FloatingActionButton.extended(
            label: const Text("New"),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const VocNewPage();
              }));
            }
          )
        )
      ])
    );
  }
}

class VocNewPage extends StatefulWidget {
  const VocNewPage({ super.key });
  
  @override
  State<VocNewPage> createState() => _VocNewPageState();
}

class _VocNewPageState extends State<VocNewPage> {
  int selectedLang = 0; 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints viewport) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 450, minHeight: viewport.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New Vocabulary Set", style: Theme.of(context).textTheme.headlineLarge!),
                    const Text("Create a new Vocabulary Set"),
                    const SizedBox(height: 40),
                    Stack(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Title",
                            border: OutlineInputBorder()
                          )
                        ),
                        Positioned(
                          right: 5,
                          top: 4,
                          child: DropdownButton(
                            value: selectedLang,
                            items: langs.asMap().entries.map<DropdownMenuItem<int>>((entry) => 
                              DropdownMenuItem<int>(value: entry.key, child: entry.value)).toList(),
                            onChanged: (int? value) => setState(() => selectedLang = value!),
                            underline: const SizedBox() 
                          ),
                        )
                      ]
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Author",
                        border: OutlineInputBorder(),
                      )
                    ),

                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          child: const Text("Create"),
                          onPressed: () {}
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          child: const Text("Back"),
                          onPressed: () {
                            Navigator.pop(context);
                          }
                        )
                      ]
                    )
                  ]
                )
              )
            )
          )
        )
      )
    );
  }
}
