import "package:frenchscape/frenchscape.dart";

class CollectionDetails extends StatelessWidget {
  CollectionDetails(
      {super.key,
      required this.builder,
      String? name,
      String? description,
      String? author,
      int? lang})
      : name = TextEditingController(text: name),
        description = TextEditingController(text: description),
        author = TextEditingController(text: author),
        lang = ValueNotifier(lang ?? 0);

  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController author;
  final ValueNotifier<int> lang;

  final List<Widget> Function(BuildContext, CollectionDetails) builder;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText: "Name",
              border: const OutlineInputBorder(),
              suffixIcon: DropdownButton(
                value: lang.value,
                items: langs
                    .asMap()
                    .entries
                    .map<DropdownMenuItem<int>>((entry) =>
                        DropdownMenuItem<int>(
                            value: entry.key, child: entry.value.full(context)))
                    .toList(),
                onChanged: (int? value) => lang.value = value!,
                underline: const SizedBox(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: description,
            decoration: const InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          TextFormField(
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
