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
          collection.vocabularies.add(Vocabulary(
            root: root.text,
            foreign: foreign.text,
          ));

          collection.vocabularies.applyToDb();

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
                      decoration: InputDecoration(
                        hintText: "${collection.root.flag} Root",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: foreign,
                      decoration: InputDecoration(
                        hintText:
                            "${collection.foreign.flag} Foreign (Translation)",
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
