import "package:frenchscape/frenchscape.dart";

class Language {
  const Language(this.id, this.flag, this.name);

  final int id;

  final String flag;
  final String name;

  String get full => "$flag $name";

  Widget avatar(BuildContext context) {
    return CircleAvatar(child: Text(flag));
  }
}

final langs = HashMap.fromEntries([
  const MapEntry(1, Language(1, "\u{1F1E9}\u{1F1EA}", "German")),
  const MapEntry(2, Language(2, "\u{1F1FA}\u{1F1F8}", "English")),
  const MapEntry(3, Language(3, "\u{1F1EB}\u{1F1F7}", "French")),
  const MapEntry(4, Language(4, "\u{1F1EA}\u{1F1F8}", "Spanish")),
]);
