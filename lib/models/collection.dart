import "package:frenchscape/frenchscape.dart";

@Entity()
class Collection {
  @Id()
  int id;

  @Transient()
  late Language root;

  int get dbRoot => root.id;
  set dbRoot(int value) => root = langs[value]!;

  @Transient()
  late Language foreign;

  int get dbForeign => foreign.id;
  set dbForeign(int value) => foreign = langs[value]!;

  /// The vocabularies in this set
  final vocabularies = ToMany<Vocabulary>();

  String name;
  String description;
  String author;

  Collection({
    this.id = 0,
    required this.name,
    required this.description,
    required this.author,
  });

  @Transient()
  String get nameD => name.isEmpty ? "Untitled" : name.trim();
  @Transient()
  String get descriptionD =>
      description.isEmpty ? "No description provided" : description.trim();
  @Transient()
  String get authorD => author.isEmpty ? "Unknown Author" : author.trim();
}
