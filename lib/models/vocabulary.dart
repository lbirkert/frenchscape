import "package:frenchscape/frenchscape.dart";

@Entity()
class Vocabulary {
  @Id()
  int id;

  int collection;

  String foreign;
  String root;

  Vocabulary({
    this.id = 0,
    required this.collection,
    required this.foreign,
    required this.root,
  });

  String get foreignD => foreign.isEmpty ? "Empty" : foreign.trim();
  String get rootD => root.isEmpty ? "Empty" : root.trim();
}
