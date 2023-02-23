import "package:frenchscape/frenchscape.dart";

@Entity()
class Collection {
  @Id()
  int id;

  int root;
  int foreign;

  String name;
  String description;
  String author;

  Collection({
    this.id = 0,
    required this.root,
    required this.foreign,
    required this.name,
    required this.description,
    required this.author,
  });

  String get nameD => name.isEmpty ? "Untitled" : name.trim();
  String get descriptionD =>
      description.isEmpty ? "No description provided" : description.trim();
  String get authorD => author.isEmpty ? "Unknown Author" : author.trim();
}
