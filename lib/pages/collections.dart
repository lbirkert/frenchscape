import "package:frenchscape/frenchscape.dart";

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPool<Collection, int>(
        identify: (c) => c.id,
        matches: matches,
        fetch: fetch,
      ),
      child: const CollectionsView(),
    );
  }

  static bool matches(SearchEntry<Collection, int> entry, String query) {
    query = query.toLowerCase();
    return entry.value.nameD.toLowerCase().contains(query) ||
        entry.value.descriptionD.toLowerCase().contains(query) ||
        entry.value.authorD.toLowerCase().contains(query);
  }

  static List<Collection> fetch() {
    return collectionBox.getAll();
  }
}

class CollectionsView extends StatelessWidget {
  const CollectionsView({super.key});

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
                if (constraints.maxWidth > 400) const Text("Collections"),
                if (constraints.maxWidth > 400) const SizedBox(width: 20),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth > 400 ? 300 : 400),
                    child: SearchBar<Collection, int>(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body:
          SafeArea(child: SearchList<Collection, int>(itemBuilder: _listItem)),
      floatingActionButton: Consumer<SearchPool<Collection, int>>(
        builder: (context, searchPool, _) => FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("New"),
          onPressed: () async {
            if (await navigator.push(
                  MaterialPageRoute(
                    builder: (_) => const CollectionCreatePage(),
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
    SearchEntry<Collection, int> entry,
    int i,
  ) {
    final collection = entry.value;
    final navigator = Navigator.of(context);
    return ListTile(
      title: Text(collection.nameD),
      subtitle: Text(collection.descriptionD),
      leading: collection.root.avatar(context),
      trailing: ChangeNotifierProvider.value(
        value: entry.selectionPool,
        child: Consumer<SelectionPool<int>>(
          builder: (_, selectionPool, __) => selectionPool.isEmpty
              ? const SizedBox()
              : Checkbox(
                  value: entry.selected,
                  onChanged: (v) => entry.selected = v!,
                ),
        ),
      ),
      onTap: () async {
        if (entry.selectionPool.isEmpty) {
          if (await navigator.push(
                MaterialPageRoute(
                  builder: (_) => CollectionPage(collection: collection),
                ),
              ) ??
              false) {
            searchPool.update();
          }
        } else {
          entry.selected = !entry.selected;
        }
      },
      onLongPress: () {
        entry.selected = !entry.selected;
      },
    );
  }
}
