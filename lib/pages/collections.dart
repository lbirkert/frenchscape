import "package:frenchscape/frenchscape.dart";

class CollectionEntry extends ChangeNotifier {
  CollectionEntry(this.collection, this.pool)
      : _selected = pool.contains(collection.id);

  final SelectionPool pool;

  Collection collection;
  bool _selected;

  bool get selected {
    return _selected;
  }

  set selected(bool state) {
    (state ? pool.add : pool.remove)(collection.id);
    _selected = state;
    notifyListeners();
  }
}

class SelectionPool extends ChangeNotifier {
  SelectionPool();

  final HashSet<int> _selected = HashSet();

  bool contains(int id) => _selected.contains(id);

  add(int id) {
    _selected.add(id);
    notifyListeners();
  }

  remove(int id) {
    _selected.remove(id);
    notifyListeners();
  }
}

class SearchPool extends ChangeNotifier {
  SearchPool({query}) {
    _query = query;
    search(collectionBox.getAll());
  }

  final SelectionPool pool = SelectionPool();
  late List<CollectionEntry> results;

  String? _query;

  String? get query => _query;
  set query(String? v) {
    _query = v;
    search(collectionBox.getAll());
  }

  void search(List<Collection> collections) {
    if (_query == null) {
      results = collections.map(_mapper).toList();
    } else {
      final query = (_query!).toLowerCase();
      results = collections
          .where((e) {
            return e.nameD.toLowerCase().contains(query);
          })
          .map(_mapper)
          .toList();
    }

    notifyListeners();
  }

  void update() {
    search(collectionBox.getAll());
  }

  CollectionEntry _mapper(Collection e) => CollectionEntry(e, pool);
}

class Searchbar extends StatelessWidget {
  Searchbar({super.key});

  final searchController = TextEditingController();

  @override
  build(BuildContext context) {
    final searchPool = Provider.of<SearchPool>(context);

    return TextField(
      controller: searchController,
      onChanged: (value) {
        searchPool.query = value.isEmpty ? null : value;
      },
      decoration: InputDecoration(
        hintText: "Search",
        border: InputBorder.none,
        prefixIcon: IconButton(
          icon: searchPool.query == null
              ? const Icon(Icons.search)
              : const Icon(Icons.close),
          onPressed: () {
            if (searchPool.query != null) {
              searchController.text = "";
              searchPool.query = null;
            }
          },
        ),
        suffixIcon: ChangeNotifierProvider.value(
          value: searchPool.pool,
          builder: (context, __) {
            final selectionPool = Provider.of<SelectionPool>(context);
            return Checkbox(
              value: searchPool.results.isNotEmpty &&
                  searchPool.results
                      .every((r) => selectionPool.contains(r.collection.id)),
              onChanged: (v) => {
                for (final result in searchPool.results) {result.selected = v!}
              },
            );
          },
        ),
      ),
    );
  }
}

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SearchPool(), child: const CollectionsView());
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
                if (constraints.maxWidth > 400) const Text("Vocabulary"),
                if (constraints.maxWidth > 400) const SizedBox(width: 20),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth < 400 ? 400 : 300),
                    child: Searchbar(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<SearchPool>(
          builder: (context, searchPool, _) {
            return ListView.builder(
              itemCount: searchPool.results.length,
              itemBuilder: (BuildContext context, int i) =>
                  _listItem(context, searchPool, searchPool.results[i], i),
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 80),
            );
          },
        ),
      ),
      floatingActionButton: Consumer<SearchPool>(
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

  Widget _listItem(BuildContext context, SearchPool searchPool,
      CollectionEntry entry, int i) {
    final collection = entry.collection;
    final navigator = Navigator.of(context);
    return ChangeNotifierProvider.value(
      value: entry,
      builder: (context, _) {
        final entry = Provider.of<CollectionEntry>(context);
        return ListTile(
          title: Text(collection.nameD),
          subtitle: Text(collection.descriptionD),
          leading: langs[collection.lang].avatar(context),
          trailing: Checkbox(
            value: entry.selected,
            onChanged: (v) => entry.selected = v!,
          ),
          onTap: () async {
            if (await navigator.push(
                  MaterialPageRoute(
                    builder: (_) =>
                        CollectionPage(collection: entry.collection),
                  ),
                ) ??
                false) {
              searchPool.update();
            }
          },
        );
      },
    );
  }
}
