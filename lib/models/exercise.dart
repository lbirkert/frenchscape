import "package:frenchscape/frenchscape.dart";

enum ExerciseType { translate }

@Entity()
class Exercise {
  @Id()
  int id;

  @Transient()
  late Duration duration;

  int get dbDuration {
    return duration.inMilliseconds;
  }

  set dbDuration(int value) {
    duration = Duration(milliseconds: value);
  }

  @Transient()
  late ExerciseType type;

  int get dbType => type.index;
  set dbType(int value) => type = ExerciseType.values[value];

  final training = ToOne<Training>();
  final tasks = ToMany<Task>();

  Exercise({
    this.id = 0,
  });
}
