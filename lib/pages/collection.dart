import "package:frenchscape/frenchscape.dart";

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(collection.nameD)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.school),
        label: const Text("Learn"),
        onPressed: () {
          if (collection.vocabularies.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LearnPage(
                  create: (context) =>
                      ExerciseManager(context: context, collection: collection),
                ),
              ),
            );
          }
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                child: Column(
                  children: [
                    ElevatedButton(
                      child: const Text("Manage Vocabularies"),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                VocabulariesPage(collection: collection),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CollectionDetails(
                      name: collection.name,
                      description: collection.description,
                      author: collection.author,
                      root: collection.root,
                      foreign: collection.foreign,
                      builder: (_, details) => [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () async {
                                if (await ConfirmDialog.ask(
                                  context: context,
                                  title: "Delete",
                                  description:
                                      "Are you sure?\n\nThis action cannot be undone!",
                                )) {
                                  vocabularyBox
                                      .query(Vocabulary_.collection
                                          .equals(collection.id))
                                      .build()
                                      .remove();
                                  collectionBox.remove(collection.id);
                                  navigator.pop(true);
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            FilledButton(
                              child: const Text("Save"),
                              onPressed: () {
                                collection.name = details.name.text;
                                collection.root = details.root.value;
                                collection.foreign = details.foreign.value;
                                collection.description =
                                    details.description.text;
                                collection.author = details.author.text;
                                collectionBox.put(collection);
                                navigator.pop(true);
                              },
                            ),
                          ],
                        ),
                      ],
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
