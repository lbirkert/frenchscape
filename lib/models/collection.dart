import "package:frenchscape/frenchscape.dart";

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
  get descriptionD =>
      description.isEmpty ? "No description provided" : description;
  get authorD => author.isEmpty ? "Unknown Author" : author;
}
