import "package:frenchscape/frenchscape.dart";

@Entity()
class Task {
  @Id()
  int id;

  List<String> answers;

  final vocabulary = ToOne<Vocabulary>();
  final exercise = ToOne<Exercise>();

  Task({
    this.id = 0,
    required this.answers,
  });
}
