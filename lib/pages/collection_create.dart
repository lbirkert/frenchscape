import "package:frenchscape/frenchscape.dart";

class CollectionCreatePage extends StatelessWidget {
  const CollectionCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Vocabulary Collection")),
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
                    CollectionDetails(
                      builder: (context, details) => [
                        FilledButton(
                          child: const Text("Create"),
                          onPressed: () {
                            collectionBox.put(Collection(
                              root: details.root.value,
                              foreign: details.foreign.value,
                              name: details.name.text,
                              description: details.description.text,
                              author: details.author.text,
                            ));

                            Navigator.pop(context, true);
                          },
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
