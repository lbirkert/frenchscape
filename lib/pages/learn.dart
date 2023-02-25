import "package:frenchscape/frenchscape.dart";

T random<T>(List<T> e, [Random? random]) {
  return e[(random ?? Random()).nextInt(e.length)];
}

class LearnPage extends StatelessWidget {
  const LearnPage({
    super.key,
    required this.create,
  });

  final ExerciseManager Function(BuildContext context) create;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: create,
      child: const LearnView(),
    );
  }
}

class LearnView extends StatelessWidget {
  const LearnView({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<ExerciseManager>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.stop_circle),
          onPressed: () async {
            if (await ConfirmDialog.ask(
              context: context,
              title: "Stop training",
              description: "Do you really want to stop this training?",
              confirm: "Stop",
            )) {
              manager.stopTraining();
            }
          },
        ),
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
                      child: manager.component.widget,
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
