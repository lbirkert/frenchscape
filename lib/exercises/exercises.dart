import "package:frenchscape/frenchscape.dart";

export "translate.dart";
export "success.dart";

T randomElement<T>(List<T> e) {
  return e[Random().nextInt(e.length)];
}

class ExerciseComponent {
  const ExerciseComponent(this.exercise, this.widget);

  final Exercise exercise;
  final Widget widget;
}

final List<ExerciseCreator> exerciseCreators = [
  TranslateExercise.create,
];

class ExerciseManager extends ChangeNotifier {
  ExerciseManager({
    required this.context,
    required this.collection,
    List<Vocabulary>? vocabularies,
    Training? training,
  })  : selector = VocabularySelector(vocabularies ?? collection.vocabularies),
        training = training ?? Training.late() {
    startTraining();
    update();
  }

  final BuildContext context;

  final Collection collection;
  final VocabularySelector selector;
  final Training training;

  late DateTime exerciseStarted;
  late ExerciseComponent component;

  void update() {
    if (selector.vocabularies.isEmpty) {
      // TODO: start next round

      training.finished = true;

      stopTraining();
    }

    component = randomElement(exerciseCreators)(collection, selector);
    notifyListeners();
    startExercise();
  }

  void startExercise() {
    exerciseStarted = DateTime.now();
  }

  void stopExercise() {
    component.exercise.duration = DateTime.now().difference(exerciseStarted);
    training.exercises.add(component.exercise);
  }

  void startTraining() {
    training.collection.target = collection;
    training.start = DateTime.now();
  }

  void stopTraining() {
    training.end = DateTime.now();

    trainingBox.put(training);

    Navigator.of(context).pop(training);
  }
}

class VocabularySelector {
  VocabularySelector(List<Vocabulary> vocabularies)
      : _vocabularies = vocabularies,
        vocabularies = [...vocabularies];

  /// Should not be modified
  final List<Vocabulary> _vocabularies;

  final List<Vocabulary> vocabularies;
  final _random = Random();

  Vocabulary take() {
    if (vocabularies.isEmpty) {
      return randomElement(_vocabularies);
    }

    vocabularies.shuffle(_random);
    return vocabularies.removeAt(0);
  }
}

typedef ExerciseCreator = ExerciseComponent Function(
  Collection collection,
  VocabularySelector selector,
);
