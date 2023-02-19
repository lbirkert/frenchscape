import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import "package:objectbox/objectbox.dart";
import 'package:flutter/material.dart';
 
import 'objectbox.g.dart';

// Annotate a Dart class to create a box
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

class ObjectBox {
  /// The Store of this app.
  late final Store store;
  
  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "store"));
    return ObjectBox._create(store);
  }
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
