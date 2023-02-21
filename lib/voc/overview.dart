import "package:frenchscape/main.dart";
import "package:frenchscape/voc/lang.dart";
import "package:frenchscape/voc/collection.dart";
import "package:frenchscape/voc/collection/new.dart";

import "package:flutter/material.dart";

class VocOverviewPage extends StatefulWidget {
    const VocOverviewPage({super.key});

    @override
    State<VocOverviewPage> createState() => _VocOverviewPageState();
}
    

class _VocOverviewPageState extends State<VocOverviewPage> {
    final searchController = TextEditingController();

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
            ...(constraints.maxWidth > 400 ? [
                const Text("Vocabulary"),
                const SizedBox(width: 30)
            ] : []),

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

    Widget _listItem(BuildContext context, VocCollection collection, int i) => ListTile(
        title: Text(collection.name.isEmpty ? "Untitled" : collection.name),
        subtitle: Text(collection.description.isEmpty ? "No description provided" : collection.description),
        leading: langs[collection.lang].avatar(context),
        trailing: Checkbox(value: selected.contains(i), onChanged: (v) {
            setState(() => (v! ? selected.add : selected.remove)(i));
        })
    );
}
