export "models/collection.dart";
export "models/vocabulary.dart";
export "models/setting.dart";
export "models/language.dart";
export "objectbox.g.dart";

export "package:objectbox/objectbox.dart";

import "models/collection.dart";
import "models/vocabulary.dart";
import "models/setting.dart";

import "objectbox.g.dart";

import "package:flutter/material.dart";
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

late ObjectBox objectbox;

late Box<Collection> collectionBox;
late Box<Setting> settingBox;
late Box<Vocabulary> vocabularyBox;

late ValueNotifier<ThemeMode> themeNotifier;
late ValueNotifier<Color> colorSchemeSeedNotifier;

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store) {
    objectbox = this;

    vocabularyBox = store.box<Vocabulary>();
    collectionBox = store.box<Collection>();
    settingBox = store.box<Setting>();

    themeNotifier = ValueNotifier(Setting.appearance);
    colorSchemeSeedNotifier = ValueNotifier(Setting.colorSchemeSeed);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: path.join(docsDir.path, "store"));
    return ObjectBox._create(store);
  }
}
