import "package:frenchscape/frenchscape.dart";

class VocabularyCreatePage extends StatelessWidget {
  VocabularyCreatePage({
    required this.collection,
    super.key,
  });

  final Collection collection;

  final TextEditingController foreign = TextEditingController();
  final TextEditingController root = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Vocabulary")),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Create"),
        onPressed: () {
          vocabularyBox.put(Vocabulary(
            collection: collection.id,
            root: root.text,
            foreign: foreign.text,
          ));

          Navigator.pop(context, true);
        },
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
                    TextField(
                      controller: root,
                      decoration: const InputDecoration(
                        hintText: "Root",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: foreign,
                      decoration: const InputDecoration(
                        hintText: "Foreign (Translation)",
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
