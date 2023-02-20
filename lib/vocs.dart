import "package:objectbox/objectbox.dart";
import 'package:flutter/material.dart';

@Entity()
class Voc {
  @Id()
  int id;

  int col;

  String foreign;
  String translation;
  String notes;

  Voc({
    this.id = 0,
    required this.col,
    required this.foreign,
    required this.translation,
    required this.notes,
  });
}

@Entity()
class VocCol {
  @Id() 
  int id;

  int lang;

  String name;
  String description;
  String author;

  VocCol({
    this.id = 0,
    required this.lang,
    required this.name,
    required this.description,
    required this.author,
  });
}

class VocLang extends StatelessWidget {
  const VocLang({ super.key, required this.flag, required this.name });

  final String flag;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text("$flag $name");
  }
}

// 🇯🇵 🇰🇷 🇩🇪 🇨🇳 🇺🇸 🇫🇷 🇪🇸 🇮🇹 🇷🇺 🇬🇧
const langs = [
  VocLang(flag: "\u{1F1E9}\u{1F1EA}", name: "German"),
  VocLang(flag: "\u{1F1FA}\u{1F1F8}", name: "English"),
  VocLang(flag: "\u{1F1EB}\u{1F1F7}", name: "French"),
  VocLang(flag: "\u{1F1EA}\u{1F1F8}", name: "Spanish"),
];

class VocPage extends StatefulWidget {
  const VocPage({super.key});

  @override
  State<VocPage> createState() => _VocPageState();
}

class _VocPageState extends State<VocPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(children: [
        Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Vocabulary', style: Theme.of(context).textTheme.headlineLarge!),
            const SizedBox(height: 10),
            const Text('Tap the New Button to create a new Vocabulary collection.', textAlign: TextAlign.center)
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
              padding: const EdgeInsets.all(20),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New Vocabulary Set", style: Theme.of(context).textTheme.headlineLarge!),
                    const SizedBox(height: 10),
                    const Text("Create a new Vocabulary Set"),
                    const SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Title",
                            border: OutlineInputBorder()
                          )
                        ),
                        Positioned(
                          right: 5,
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
