import "package:frenchscape/frenchscape.dart";

@Entity()
class Training {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime start;

  @Property(type: PropertyType.date)
  DateTime end;

  final collection = ToOne<Collection>();
  final exercises = ToMany<Exercise>();

  Training({
    this.id = 0,
    required this.start,
    required this.end,
  });
}
