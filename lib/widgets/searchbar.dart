import "package:frenchscape/frenchscape.dart";

class SearchBar<T, U> extends StatelessWidget {
  SearchBar({super.key});

  final searchController = TextEditingController();

  @override
  build(BuildContext context) {
    final searchPool = Provider.of<SearchPool<T, U>>(context);

    final searchIcon = IconButton(
      icon: searchPool.query == null
          ? const Icon(Icons.search)
          : const Icon(Icons.close),
      onPressed: () {
        if (searchPool.query != null) {
          searchController.text = "";
          searchPool.query = null;
          searchPool.search();
        }
      },
    );

    return ChangeNotifierProvider.value(
      value: searchPool.selectionPool,
      builder: (context, __) {
        final selectionPool = Provider.of<SelectionPool<U>>(context);
        return TextField(
          controller: searchController,
          onChanged: (value) {
            searchPool.query = value.isEmpty ? null : value;
            searchPool.search();
          },
          decoration: InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
            suffixIcon: selectionPool.isEmpty
                ? searchIcon
                : Checkbox(
                    value: searchPool.results.isNotEmpty &&
                        searchPool.results
                            .every((r) => selectionPool.contains(r.id)),
                    onChanged: (v) => {
                      for (final result in searchPool.results)
                        {result.selected = v!}
                    },
                  ),
            prefixIcon: selectionPool.isEmpty ? null : searchIcon,
          ),
        );
      },
    );
  }
}
