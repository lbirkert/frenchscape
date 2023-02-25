import "package:frenchscape/frenchscape.dart";

class VocabulariesPage extends StatelessWidget {
  const VocabulariesPage({
    required this.collection,
    super.key,
  });

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPool<Vocabulary, int>(
        identify: (c) => c.id,
        matches: matches,
        fetch: () => collection.vocabularies,
      ),
      child: VocabulariesView(collection: collection),
    );
  }

  bool matches(SearchEntry<Vocabulary, int> entry, String query) {
    query = query.toLowerCase();

    return entry.value.foreignD.toLowerCase().contains(query) ||
        entry.value.rootD.toLowerCase().contains(query);
  }
}

class VocabulariesView extends StatelessWidget {
  const VocabulariesView({
    required this.collection,
    super.key,
  });

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (constraints.maxWidth > 400) const Text("Vocabularies"),
                if (constraints.maxWidth > 400) const SizedBox(width: 20),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth > 400 ? 300 : 400),
                    child: SearchBar<Vocabulary, int>(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body:
          SafeArea(child: SearchList<Vocabulary, int>(itemBuilder: _listItem)),
      floatingActionButton: Consumer<SearchPool<Vocabulary, int>>(
        builder: (context, searchPool, _) => FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("New"),
          onPressed: () async {
            if (await navigator.push(
                  MaterialPageRoute(
                    builder: (_) =>
                        VocabularyCreatePage(collection: collection),
                  ),
                ) ??
                false) {
              searchPool.update();
            }
          },
        ),
      ),
    );
  }

  Widget _listItem(
    BuildContext context,
    SearchPool searchPool,
    SearchEntry<Vocabulary, int> entry,
    int i,
  ) {
    final vocabulary = entry.value;
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
        return await showDialog<bool?>(
          builder: (_) => const ConfirmDialog(
            title: "Delete",
            description: "Are you sure?\n\nThis action cannot be undone!",
          ),
          context: context,
        );
      },
      onDismissed: (_) {
        collection.vocabularies.remove(vocabulary);
        collection.vocabularies.applyToDb();
        vocabularyBox.remove(vocabulary.id);
        searchPool.update();
      },
      child: ListTile(
        title: Text(vocabulary.rootD),
        subtitle: Text(vocabulary.foreignD),
        leading: collection.root.avatar(context),
      ),
    );
  }
}
