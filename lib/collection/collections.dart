import "collection.dart";
import "../language.dart";

import "package:frenchscape/main.dart";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "dart:collection";

class CollectionEntry extends ChangeNotifier {
    CollectionEntry(this.collection, this.pool):
        _selected = pool.contains(collection.id);

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
    SearchPool({ query }) {
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
        if(_query == null) {
            results = collections.map(_mapper).toList();
        } else {
            final query = (_query!).toLowerCase();
            results = collections.where((e) {
                return e.nameD.toLowerCase().contains(query);
            }).map(_mapper).toList();
        }

        notifyListeners();
    }

    CollectionEntry _mapper(Collection e) => CollectionEntry(e, pool);
}

class Searchbar extends StatelessWidget {
    Searchbar({ super.key });

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
                    icon: searchPool.query == null ? const Icon(Icons.search) : const Icon(Icons.close),
                    onPressed: () {
                        if(searchPool.query != null) {
                            searchController.text = "";
                            searchPool.query = null;
                        }
                    }
                ),
                suffixIcon: ChangeNotifierProvider.value(
                    value: searchPool.pool,
                    builder: (context, __) {
                        final selectionPool = Provider.of<SelectionPool>(context);
                        return Checkbox(
                            value: searchPool.results.every((r) => selectionPool.contains(r.collection.id)),
                            onChanged: (v) => {
                                for(final result in searchPool.results) {
                                    result.selected = v!
                                }
                            }
                        );
                    }
                )
            ),
        );
    }
}

class CollectionsPage extends StatelessWidget {
    const CollectionsPage({super.key});

    @override
    Widget build(BuildContext context) {
        return ChangeNotifierProvider(
            create: (_) => SearchPool(),
            child: const CollectionsView()
        );
    }
}

class CollectionsView extends StatelessWidget {
    const CollectionsView({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: LayoutBuilder(
                        builder: (context, constraints) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                if(constraints.maxWidth > 350)
                                    const Text("Vocabulary"),
                                if(constraints.maxWidth > 350)
                                    const SizedBox(width: 20),

                                Flexible(child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 350),
                                    child: Searchbar()
                                ))
                            ]
                        )
                    )
                )
            ),
            body: SafeArea(child: Consumer<SearchPool>(
                builder: (context, pool, _) {
                    return ListView.builder(
                        itemCount: pool.results.length,
                        itemBuilder: (BuildContext context, int i) => _listItem(context, pool.results[i], i),
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 80)
                    );
                }
            )),
            floatingActionButton: Consumer<SearchPool>(
                builder: (context, pool, _) =>FloatingActionButton.extended(
                    icon: const Icon(Icons.add),
                    label: const Text("New"),
                    onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const VocCollectionNewPage())
                        );
                        pool.search(collectionBox.getAll());
                    }
                )
            )
        );
    }
    
    
    Widget _listItem(BuildContext context, CollectionEntry entry, int i) {
        final collection = entry.collection;
        return ChangeNotifierProvider.value(
            value: entry,
            builder: (context, _) {
                final entry = Provider.of<CollectionEntry>(context);
                return ListTile(
                    title: Text(collection.nameD),
                    subtitle: Text(collection.descriptionD),
                    leading: langs[collection.lang].avatar(context),
                    trailing: Checkbox(value: entry.selected, onChanged: (v) => entry.selected = v!)
                );
            }
        );
    }
}

/*

class Searchbar extends StatelessWidget {
    Searchbar({ super.key });

    final searchController = TextEditingController();

    @override
    build(BuildContext context) {
        return TextField(
            controller: searchController,
            decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: (){}
                ),
                suffixIcon: BlocBuilder<VocOverviewBloc, VocOverviewState>(
                    builder: (context, state) => Checkbox(
                        value: state.results.every((r) => r.selected),
                        onChanged: (v) =>
                            context.read<VocOverviewBloc>().add(VocOverviewSelectEvent(v!))
                    )
                )
            ),
        );
    }
}

class VocOverviewPage extends StatelessWidget {
    const VocOverviewPage({super.key});

    @override
    Widget build(BuildContext context) {
        return BlocProvider(
            create: (_) => VocOverviewBloc(),
            child: const VocOverviewView(),
        );
    }
}
    

class VocOverviewView extends StatelessWidget {
    const VocOverviewView({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: LayoutBuilder(
                        builder: (context, constraints) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                if(constraints.maxWidth > 350)
                                    const Text("Vocabulary"),
                                if(constraints.maxWidth > 350)
                                    const SizedBox(width: 20),

                                Flexible(child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 350),
                                    child: Searchbar()
                                ))
                            ]
                        )
                    )
                )
            ),
            body: SafeArea(child: BlocBuilder<VocOverviewBloc, VocOverviewState>(
                buildWhen: (p, s) => p.results.length != s.results.length,
                builder: (context, state) => ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (BuildContext context, int i) => _listItem(context, state.results[i], i),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                )
            )),
            floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                label: const Text("New"),
                onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const VocCollectionNewPage())
                    );
                }
            )
        );
    }
    
    
    Widget _listItem(BuildContext context, VocOverviewEntry entry, int i) {
        final collection = entry.collection;
        final name = collection.name.isEmpty ?
                "Untitled" : collection.name;
        final description = collection.description.isEmpty ?
                "No description provided" : collection.description;

        return ListTile(
            title: Text(name),
            subtitle: Text(description),
            leading: langs[collection.lang].avatar(context),
            trailing: BlocBuilder<VocOverviewBloc, VocOverviewState>(
                buildWhen: (p, s) => p.results[i].selected != s.results[i].selected,
                builder: (context, state) {
                    final entry = state.results[i];
                    return Checkbox(value: entry.selected, onChanged: (v) {
                        context.read<VocOverviewBloc>().add(VocOverviewEntrySelectEvent(entry, v!));
                    });
                }
            )
        );
    }
}

*/
/*
class _VocOverviewPageState extends State<VocOverviewPage> {
    List<int> selected = [];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: LayoutBuilder(builder: title)
                )
            ),
            body: SafeArea(child: ValueListenableBuilder(
                valueListenable: vocCollectionsNotifier,
                builder: list
            )),
            floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                label: const Text("New"),
                onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const VocCollectionNewPage())
                    );
                }
            )
        );
    }

    Widget title(BuildContext context, BoxConstraints constraints) => Row(
        children: [
            if(constraints.maxWidth > 400)
                const Text("Vocabulary"),

            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Flexible(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 300),
                                child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                        hintText: "Search",
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                            icon: const Icon(Icons.search),
                                            onPressed: (){}
                                        ),
                                    ),
                                )
                            )
                        ),
                        const SizedBox(width: 20),
                        ValueListenableBuilder(
                            valueListenable: vocCollectionsNotifier,
                            builder: (_, List<VocCollection> collections, __) => Checkbox(
                                value: collections.length == selected.length,
                                onChanged: (v) {
                                    setState(() {
                                        if(v!) {
                                            selected = Iterable<int>.generate(collections.length).toList();
                                        } else {
                                            selected.clear();
                                        }
                                    });
                                }
                            )
                        )
                    ]
                )
            )
        ]
    );

    Widget list(BuildContext context, List<VocCollection> collections, _) => ListView.builder(
        itemCount: collections.length,
        itemBuilder: (BuildContext context, int i) => _listItem(context, collections[i], i),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
    );

}
*/
