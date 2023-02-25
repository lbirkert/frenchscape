import "package:frenchscape/frenchscape.dart";

class TranslateExercise extends StatefulWidget {
  const TranslateExercise({
    super.key,
    required this.collection,
    required this.vocabulary,
    required this.task,
  });

  final Collection collection;
  final Vocabulary vocabulary;
  final Task task;

  @override
  State<TranslateExercise> createState() => _TranslateExerciseState();

  static ExerciseComponent create(
    Collection collection,
    VocabularySelector selector,
  ) {
    Vocabulary vocabulary = selector.take();

    Task task = Task(answers: []);
    task.vocabulary.target = vocabulary;

    Exercise exercise = Exercise();
    exercise.type = ExerciseType.translate;
    exercise.tasks.add(task);

    return ExerciseComponent(
      exercise,
      TranslateExercise(
        collection: collection,
        vocabulary: vocabulary,
        task: task,
      ),
    );
  }

  // TODO: generify
  bool isCorrect(String answer) {
    task.answers.add(answer);

    return vocabulary.rootD.toLowerCase().trim() == answer.toLowerCase().trim();
  }
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
    final manager = Provider.of<ExerciseManager>(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          "Please translate into ${widget.collection.root.name}",
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
            hintText: widget.collection.root.full,
            errorText: errorText,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffix: ElevatedButton(
              child: const Text("Next"),
              onPressed: () async {
                if (errorText == null && answer.text.isNotEmpty) {
                  if (widget.isCorrect(answer.text)) {
                    manager.stopExercise();
                    await showDialog(
                      builder: (_) => const SuccessDialog(),
                      barrierDismissible: false,
                      context: context,
                    );
                    answer.text = "";
                    manager.update();
                  } else {
                    setState(() => errorText = randomElement(errorTexts));
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
