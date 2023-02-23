import "package:frenchscape/frenchscape.dart";

T random<T>(List<T> e) {
  return e[Random().nextInt(e.length)];
}

class ExerciseManager extends ChangeNotifier {
  ExerciseManager({
    required this.collection,
    required this.vocabularies,
  }) {
    update();
  }

  final Collection collection;
  final List<Vocabulary> vocabularies;
  final _random = Random();

  late Widget exercise;

  HashSet<Vocabulary> last = HashSet();

  void update() {
    final exercises = [
      translateExercise,
    ];

    exercise = exercises[_random.nextInt(exercises.length)]();
    notifyListeners();
  }

  HashSet<Vocabulary> take(int amount, {int changing = 1}) {
    HashSet<Vocabulary> newWords = HashSet.from(
        (vocabularies.where((v) => !last.contains(v)).toList()
              ..shuffle(_random))
            .take(changing));
    last = HashSet.from(
        (vocabularies.where((voc) => !newWords.contains(voc)).toList()
              ..shuffle(_random))
            .take(amount - changing)
            .followedBy(newWords));
    return last;
  }

  Widget translateExercise() {
    return TranslateExercise(collection: collection, vocabulary: take(1).first);
  }
}

class LearnPage extends StatelessWidget {
  LearnPage({
    super.key,
    required this.collection,
  }) : vocabularies = vocabularyBox
            .query(Vocabulary_.collection.equals(collection.id))
            .build()
            .find();

  final Collection collection;
  final List<Vocabulary> vocabularies;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseManager(
        collection: collection,
        vocabularies: vocabularies,
      ),
      child: const LearnView(),
    );
  }
}

class LearnView extends StatelessWidget {
  const LearnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning Vocabulary"),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Consumer<ExerciseManager>(
                        builder: (context, manager, _) => manager.exercise,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TranslateExercise extends StatefulWidget {
  const TranslateExercise({
    super.key,
    required this.collection,
    required this.vocabulary,
  });

  final Collection collection;
  final Vocabulary vocabulary;

  @override
  State<TranslateExercise> createState() => _TranslateExerciseState();
}

class _TranslateExerciseState extends State<TranslateExercise> {
  static const List<String> errorTexts = [
    "Almost got it, keep going!",
    "Nope that's not it.",
    "Please try again",
    "Are you sure?",
    "Please try one more time",
    "Wrong.",
    "Nope that's wrong",
    "Yeah - Kinda - Nope",
    "Not even close",
    "Aw hell naw"
  ];

  String? errorText;

  final answer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final manager = Provider.of<ExerciseManager>(context);

    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          "Please translate into ${langs[widget.collection.root].name}",
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 30),
        Card(
          color: theme.colorScheme.primary,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.vocabulary.foreignD,
              style: theme.textTheme.headlineMedium!
                  .copyWith(color: theme.colorScheme.surface),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: answer,
          onChanged: (_) {
            if (errorText != null) {
              setState(() => errorText = null);
            }
          },
          decoration: InputDecoration(
            hintText: langs[widget.collection.root].full,
            errorText: errorText,
            border: const OutlineInputBorder(),
            suffix: ElevatedButton(
              child: const Text("Next"),
              onPressed: () async {
                if (errorText == null) {
                  if (isCorrect(answer.text)) {
                    await showDialog(
                      builder: (_) => const SuccessDialog(),
                      barrierDismissible: false,
                      context: context,
                    );
                    answer.text = "";
                    manager.update();
                  } else {
                    setState(() {
                      errorText = random(errorTexts);
                    });
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  isCorrect(String answer) {
    return widget.vocabulary.rootD.toLowerCase() == answer.toLowerCase().trim();
  }
}

class SuccessDialog extends StatelessWidget {
  static const List<String> successTexts = [
    "WOW!",
    "Great Job!",
    "Well Done!",
    "Great!",
    "Stark Brudi!",
    "Insane!",
    "Magnificent!",
    "Fabulous!",
    "Yeah!",
    "Just like that!",
    "Keep going!",
  ];

  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(random(successTexts), style: theme.textTheme.headlineLarge)
              .animate()
              .move(
                delay: 200.ms,
                duration: 2000.ms,
                begin: const Offset(-40, 0),
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 5),
          Text("You solved this puzzle", style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          FilledButton(
            child: const Text("Next"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ).animate().move(
                delay: 200.ms,
                duration: 2000.ms,
                begin: const Offset(40, 0),
                curve: Curves.elasticOut,
              ),
        ],
      ),
    ).animate().scale();
  }
}
