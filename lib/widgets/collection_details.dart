import "package:frenchscape/frenchscape.dart";

class CollectionDetails extends StatelessWidget {
  CollectionDetails({
    super.key,
    required this.builder,
    String? name,
    String? description,
    String? author,
    int? root,
    int? foreign,
  })  : name = TextEditingController(text: name),
        description = TextEditingController(text: description),
        author = TextEditingController(text: author),
        root = ValueNotifier(root ?? 0),
        foreign = ValueNotifier(foreign ?? 0);

  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController author;
  final ValueNotifier<int> foreign;
  final ValueNotifier<int> root;

  final List<Widget> Function(BuildContext, CollectionDetails) builder;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            ValueListenableBuilder(
              valueListenable: root,
              builder: (context, value, _) => DropdownButton(
                value: value,
                items: langs
                    .asMap()
                    .entries
                    .map<DropdownMenuItem<int>>((entry) =>
                        DropdownMenuItem<int>(
                            value: entry.key, child: Text(entry.value.full)))
                    .toList(),
                onChanged: (int? value) => root.value = value!,
                underline: const SizedBox(),
              ),
            ),
            const Expanded(child: Text("->", textAlign: TextAlign.center)),
            ValueListenableBuilder(
              valueListenable: foreign,
              builder: (context, value, _) => DropdownButton(
                value: value,
                items: langs
                    .asMap()
                    .entries
                    .map<DropdownMenuItem<int>>((entry) =>
                        DropdownMenuItem<int>(
                            value: entry.key, child: Text(entry.value.full)))
                    .toList(),
                onChanged: (int? value) => foreign.value = value!,
                underline: const SizedBox(),
              ),
            )
          ]),
          const SizedBox(height: 20),
          TextField(
            controller: name,
            decoration: const InputDecoration(
              hintText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: description,
            decoration: const InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: author,
            decoration: const InputDecoration(
              hintText: "Author",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ...builder(context, this)
        ],
      ),
    );
  }
}
