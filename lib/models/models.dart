import "package:frenchscape/frenchscape.dart";

export "collection.dart";
export "vocabulary.dart";
export "setting.dart";
export "language.dart";
export "training.dart";
export "exercise.dart";
export "task.dart";

export "package:objectbox/objectbox.dart";

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

late ObjectBox objectbox;

late Box<Setting> settingBox;

late Box<Collection> collectionBox;
late Box<Vocabulary> vocabularyBox;

late Box<Training> trainingBox;
late Box<Exercise> exerciseBox;
late Box<Task> taskBox;

late ValueNotifier<ThemeMode> themeNotifier;
late ValueNotifier<Color> colorSchemeSeedNotifier;

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store) {
    objectbox = this;

    settingBox = store.box<Setting>();

    collectionBox = store.box<Collection>();
    vocabularyBox = store.box<Vocabulary>();

    trainingBox = store.box<Training>();
    exerciseBox = store.box<Exercise>();
    taskBox = store.box<Task>();

    themeNotifier = ValueNotifier(Setting.appearance);
    colorSchemeSeedNotifier = ValueNotifier(Setting.colorSchemeSeed);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: path.join(docsDir.path, "store"));
    return ObjectBox._create(store);
  }
}
