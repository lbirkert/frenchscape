import "package:frenchscape/frenchscape.dart";

class InsightsPage extends StatefulWidget {
  const InsightsPage({
    super.key,
  });

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    final trainings = trainingBox.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Insights"),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: trainings.length,
          itemBuilder: (
            context,
            int i,
          ) =>
              _listItem(context, trainings[i], i),
        ),
      ),
    );
  }

  Widget _listItem(
    BuildContext context,
    Training training,
    int i,
  ) {
    final navigator = Navigator.of(context);

    if (training.collection.target == null) {
      setState(() => trainingBox.remove(training.id));
      return const SizedBox();
    }

    final Collection collection = training.collection.target!;
    final List<Exercise> exercises = training.exercises;
    final List<Task> tasks = exercises.expand((e) => e.tasks).toList();
    final List<Vocabulary> failed = tasks
        .where((t) => t.answers.length > 1 && t.vocabulary.target != null)
        .map((t) => t.vocabulary.target!)
        .toList();

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete),
      ),
      confirmDismiss: (_) async {
        return await ConfirmDialog.ask(
          context: context,
          title: "Delete",
          description: "Are you sure?\n\nThis action cannot be undone!",
        );
      },
      onDismissed: (_) {
        setState(() => trainingBox.remove(training.id));
      },
      child: ListTile(
        title: Text(
          "${training.start.toString()} | ${collection.name}",
        ),
        subtitle: Text(
          "${exercises.length} Exercise${exercises.length != 1 ? 's' : ''} | ${tasks.length - failed.length} / ${tasks.length} Tasks",
        ),
        leading: collection.root.avatar(context),
        onTap: failed.isEmpty
            ? null
            : () async {
                if (await ConfirmDialog.ask(
                  context: context,
                  title: "Retry failed",
                  description:
                      "Do you really want to retry with only the failed vocabulary?",
                )) {
                  await navigator.push(
                    MaterialPageRoute(
                      builder: (_) => LearnPage(
                        create: (context) => ExerciseManager(
                          context: context,
                          collection: collection,
                          vocabularies: failed,
                        ),
                      ),
                    ),
                  );

                  setState(() {});
                }
              },
      ),
    );
  }
}
