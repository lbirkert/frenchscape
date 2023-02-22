import "package:frenchscape/frenchscape.dart";

class CollectionCreatePage extends StatefulWidget {
  const CollectionCreatePage({super.key});

  @override
  State<CollectionCreatePage> createState() => _CollectionCreatePageState();
}

class _CollectionCreatePageState extends State<CollectionCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Vocabulary Collection")),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: CollectionDetails(
                      builder: (context, details) => [
                        FilledButton(
                          child: const Text("Create"),
                          onPressed: () {
                            collectionBox.put(Collection(
                              lang: details.lang.value,
                              name: details.name.text,
                              description: details.description.text,
                              author: details.author.text,
                            ));

                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
