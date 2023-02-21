import "package:flutter/material.dart";

import "package:frenchscape/main.dart";
import "package:frenchscape/voc/collection.dart";
import "package:frenchscape/voc/lang.dart";

class VocCollectionNewPage extends StatefulWidget {
    const VocCollectionNewPage({
        super.key
    });

    @override
    State<VocCollectionNewPage> createState() => _VocCollectionNewPageState();
}

class _VocCollectionNewPageState extends State<VocCollectionNewPage> {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final authorController = TextEditingController();
    int selectedLang = 0;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text("New Vocabulary Collection")
            ),
            body: Column(
                children: [
                    name(context),
                    const SizedBox(height: 20),
                    description(context),
                    const SizedBox(height: 20),
                    author(context),
                    const SizedBox(height: 20),
                    create(context)
                ]
            )
        );
    }

    Widget name(BuildContext context) => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
            hintText: "Name",
            border: const OutlineInputBorder(),
            suffixIcon: DropdownButton(
                value: selectedLang,
                items: langs.asMap().entries.map<DropdownMenuItem<int>>((entry) => 
                    DropdownMenuItem<int>(value: entry.key, child: entry.value.full(context))).toList(),
                onChanged: (int? value) => setState(() => selectedLang = value!),
                underline: const SizedBox() 
            ),
        ),
    );

    Widget description(BuildContext context) => TextFormField(
        controller: descriptionController,
        decoration: const InputDecoration(
            hintText: "Description",
            border: OutlineInputBorder(),
        ),
        maxLines: 4
    );

    Widget author(BuildContext context) => TextFormField(
        controller: authorController,
        decoration: const InputDecoration(
            hintText: "Author",
            border: OutlineInputBorder(),
        )
    );

    Widget create(BuildContext context) => FilledButton(
        child: const Text("Create"),
        onPressed: () {
            final name = nameController.text.isEmpty ? "Untitled" : nameController.text;
            final description = descriptionController.text.isEmpty ? "No description provided" : descriptionController.text;
            final author = authorController.text.isEmpty ? "Unknown Author" : authorController.text;
            
            vocColBox.put(VocCollection(
                lang: selectedLang,
                name: name,
                description: description,
                author: author,
            ));
            
            Navigator.pop(context);
        }
    );
}
