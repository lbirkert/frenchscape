import "package:frenchscape/frenchscape.dart";

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(collection.nameD)),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
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
                            const SizedBox(width: 10),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () async {
                                final delete = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => const ConfirmDialog(
                                    title: "Delete",
                                    description:
                                        "Are you sure?\n\nThis action cannot be undone!",
                                  ),
                                );

                                if (delete ?? false) {
                                  collectionBox.remove(collection.id);
                                  navigator.pop(true);
                                }
                              },
                            )
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
