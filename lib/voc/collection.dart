import "package:flutter/material.dart";
import "package:objectbox/objectbox.dart";

// The entity
@Entity()
class VocCollection {
  @Id() 
  int id;

  int lang;

  String name;
  String description;
  String author;

  VocCollection({
    this.id = 0,
    required this.lang,
    required this.name,
    required this.description,
    required this.author,
  });
}

class VocCollectionPage extends StatefulWidget {
  const VocCollectionPage({
    super.key,
    required this.collection
  });

  final VocCollection collection;

  @override
  State<VocCollectionPage> createState() => _VocCollectionPageState();
}

class _VocCollectionPageState extends State<VocCollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.name)
      )
    );
  }
}
