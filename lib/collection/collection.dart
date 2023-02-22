export "new.dart";
export "collections.dart";

import "package:flutter/material.dart";
import "package:objectbox/objectbox.dart";


// The entity
@Entity()
class Collection {
  @Id() 
  int id;

  int lang;

  String name;
  String description;
  String author;

  Collection({
    this.id = 0,
    required this.lang,
    required this.name,
    required this.description,
    required this.author,
  });
  
  get nameD => name.isEmpty ? "Untitled" : name;
  get descriptionD => description.isEmpty ? "No description provided" : name;
  get authorD => author.isEmpty ? "Unknown Author" : name;
}

class CollectionPage extends StatelessWidget {
  const CollectionPage({
    super.key,
    required this.collection
  });

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name)
      )
    );
  }
}
