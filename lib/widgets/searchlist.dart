import "package:frenchscape/frenchscape.dart";

class SearchList<T, U> extends StatelessWidget {
  const SearchList({
    super.key,
    this.padding = const EdgeInsets.fromLTRB(5, 10, 5, 80),
    required this.itemBuilder,
  });

  final Widget Function(
      BuildContext, SearchPool<T, U>, SearchEntry<T, U>, int i) itemBuilder;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final searchPool = Provider.of<SearchPool<T, U>>(context);
    return ListView.builder(
      itemCount: searchPool.results.length,
      itemBuilder: (BuildContext context, int i) {
        return ChangeNotifierProvider.value(
            value: searchPool.results[i],
            builder: (context, _) => itemBuilder(context, searchPool,
                Provider.of<SearchEntry<T, U>>(context), i));
      },
      padding: padding,
    );
  }
}
