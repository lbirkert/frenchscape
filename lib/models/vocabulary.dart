import "package:frenchscape/frenchscape.dart";

@Entity()
class Vocabulary {
  @Id()
  int id;

  final colleciton = ToOne<Collection>();

  String foreign;
  String root;

  Vocabulary({
    this.id = 0,
    required this.foreign,
    required this.root,
  });

  @Transient()
  String get foreignD => foreign.isEmpty ? "Empty" : foreign.trim();

  @Transient()
  String get rootD => root.isEmpty ? "Empty" : root.trim();
}
