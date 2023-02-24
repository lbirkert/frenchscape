import "package:frenchscape/frenchscape.dart";

import "dart:typed_data";

enum Mistake {
  skip,
  wrong,
  accent,
  article,
  ending,
}

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
  late List<Mistake> mistakes;

  Uint8List get dbMistakes {
    return Uint8List.fromList(mistakes.map((m) => m.index).toList());
  }

  set dbMistakes(Uint8List value) {
    mistakes = value.map((m) => Mistake.values[m]).toList();
  }

  final training = ToOne<Training>();

  Exercise({
    this.id = 0,
  });
}
