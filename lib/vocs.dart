import "main.dart";

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

  @Transient()
  bool? selected;

  VocCol({
    this.id = 0,
    required this.lang,
    required this.name,
    required this.description,
    required this.author,
  });
}

class VocLang {
  const VocLang(this.flag, this.name);

  final String flag;
  final String name;

  Widget avatar(BuildContext context) {
    return CircleAvatar(
      child: Text(flag)
    );
  }

  Widget full(BuildContext context) {
    return Text("$flag $name");
  }
}

const langs = [
  VocLang("\u{1F1E9}\u{1F1EA}", "German"),
  VocLang("\u{1F1FA}\u{1F1F8}", "English"),
  VocLang("\u{1F1EB}\u{1F1F7}", "French"),
  VocLang("\u{1F1EA}\u{1F1F8}", "Spanish"),
];

class VocPage extends StatefulWidget {
  const VocPage({super.key});

  @override
  State<VocPage> createState() => _VocPageState();
}

class _VocPageState extends State<VocPage> {
  List<VocCol> colls = vocColBox.getAll();

  @override
  Widget build(BuildContext context) {
    List<VocCol> selected = colls.where((c) => c.selected ?? false).toList();

    return Stack(children: [
      ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        separatorBuilder: (BuildContext context, int i) => i==0 ? const SizedBox(height: 20) : const Divider(),
        itemCount: colls.length + 1,
        itemBuilder: (BuildContext context, int i) {
          return i == 0 ? _header(context, selected) : _listItem(context, i - 1);
        }
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton.extended(
          icon: selected.isEmpty ? const Icon(Icons.add) : const Icon(Icons.school),
          label: selected.isEmpty ? const Text("New") : const Text("Start training"),
          onPressed: () async {
            if(selected.isEmpty) {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const VocNewPage()));
              setState(() {
                colls = vocColBox.getAll();
              });
            }
          }
        )
      )
    ]);
  }

  Widget _header(BuildContext context, List<VocCol> selected) {
    List<Widget> actionRow = [];

    if(colls.isNotEmpty) {
      actionRow.add(
        FilledButton(
          child: selected.isEmpty ? const Text("Select all") : const Text("Deselect all"),
          onPressed: () {
            setState(() {
              for(final el in colls) {
                el.selected = selected.isEmpty;
              }
            });
          }
        )
      );
    }

    if(selected.isNotEmpty) {
      actionRow.add(const SizedBox(width: 10));

      actionRow.add(
        FilledButton(
          child: const Text("Delete selected"),
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Delete selected"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text("Do you really want to delete ${selected.length} vocabulary collection(s)?"),
                        const SizedBox(height: 20),
                        const Text("Collection(s) to be deleted:"),
                        ...selected.map((c) => Text("- ${c.name}")),
                        const SizedBox(height: 20),
                        const Text("This action cannot be undone!"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    OutlinedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FilledButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        setState(() {
                          vocColBox.removeMany(selected.map<int>((c) => c.id).toList());
                          
                          for(final el in selected) {
                            colls.remove(el);
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        )
      );
    }

    return Column(
      children: [
        Text('Vocabulary', style: Theme.of(context).textTheme.headlineLarge!),
        const SizedBox(height: 10),
        const Text('Tap the New Button to create a new Vocabulary collection.', textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: actionRow
        )
      ]
    );
  }

  Widget _listItem(BuildContext context, int i) {
    final collection = colls[i];
    
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (DismissDirection direction) async {
        if(direction == DismissDirection.startToEnd) {
          setState(() {
            collection.selected = !(collection.selected ?? false);
          });
          return false;
        } else {
          bool dismiss = false;
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete '${collection.name}'"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("Do you really want to delete '${collection.name}'?"),
                      const SizedBox(height: 20),
                      const Text("This action cannot be undone!"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  OutlinedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FilledButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      dismiss = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
          return dismiss;
        }
      },
      onDismissed: (DismissDirection direction) {
        setState(() {
          vocColBox.remove(collection.id);
          colls.removeAt(i);
        });
      },
      secondaryBackground: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      background: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          collection.selected ?? false ? Icons.check_box_outline_blank : Icons.check_box,
          color: Colors.white,
        ),
      ),
      child: Card(
        child: ListTile(
          leading: langs[collection.lang].avatar(context),
          title: Text(collection.name, style: Theme.of(context).textTheme.titleLarge!),
          subtitle: collection.description.isEmpty ? const Text("No description provided") : Text(collection.description),
          trailing: Checkbox(
            value: collection.selected ?? false,
            onChanged: (bool? value) {
              setState(() {
                collection.selected = value;
              });
            },
          ),
        ),
      ),
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

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final authorController = TextEditingController();

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
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder()
                          )
                        ),
                        Positioned(
                          right: 5,
                          child: DropdownButton(
                            value: selectedLang,
                            items: langs.asMap().entries.map<DropdownMenuItem<int>>((entry) => 
                              DropdownMenuItem<int>(value: entry.key, child: entry.value.full(context))).toList(),
                            onChanged: (int? value) => setState(() => selectedLang = value!),
                            underline: const SizedBox() 
                          ),
                        )
                      ]
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: authorController,
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
                          onPressed: () {
                            vocColBox.put(VocCol(
                              lang: selectedLang,
                              name: nameController.text,
                              description: descriptionController.text,
                              author: authorController.text,
                            ));
                            Navigator.pop(context, true);
                          }
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
