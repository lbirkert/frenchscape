import "package:frenchscape/frenchscape.dart";

class SearchEntry<T, U> extends ChangeNotifier {
  SearchEntry(this.value, this.selectionPool, this.id)
      : _selected = selectionPool.contains(id);

  final U id;
  final SelectionPool<U> selectionPool;

  T value;
  bool _selected;

  bool get selected {
    return _selected;
  }

  set selected(bool state) {
    (state ? selectionPool.add : selectionPool.remove)(id);
    _selected = state;
    notifyListeners();
  }
}

class SelectionPool<T> extends ChangeNotifier {
  SelectionPool();

  final HashSet<T> _selected = HashSet();

  bool contains(T id) => _selected.contains(id);
  bool get isEmpty => _selected.isEmpty;
  bool get isNotEmpty => _selected.isNotEmpty;

  add(T id) {
    _selected.add(id);
    notifyListeners();
  }

  remove(T id) {
    _selected.remove(id);
    notifyListeners();
  }
}

class SearchPool<T, U> extends ChangeNotifier {
  SearchPool({
    required this.identify,
    required this.matches,
    required this.fetch,
    this.query,
  }) {
    update();
  }

  final SelectionPool<U> selectionPool = SelectionPool();
  final U Function(T) identify;
  final List<T> Function() fetch;
  final bool Function(SearchEntry<T, U>, String) matches;

  late List<SearchEntry<T, U>> entries;
  late List<SearchEntry<T, U>> results;

  String? query;

  void search() {
    if (query == null) {
      results = entries;
    } else {
      results = entries.where((e) => matches(e, query!)).toList();
    }

    notifyListeners();
  }

  void update() {
    this.entries = fetch().map(_mapper).toList();

    // Clear deleted elements
    final ids = HashSet.from(entries.map((e) => e.id));
    selectionPool._selected.removeWhere(ids.add);
    selectionPool.notifyListeners();

    search();
  }

  SearchEntry<T, U> _mapper(T e) => SearchEntry(e, selectionPool, identify(e));
}
