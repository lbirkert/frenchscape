import "package:frenchscape/frenchscape.dart";

class Language {
  const Language(this.flag, this.name);

  final String flag;
  final String name;

  Widget avatar(BuildContext context) {
    return CircleAvatar(child: Text(flag));
  }

  Widget full(BuildContext context) {
    return Text("$flag $name");
  }
}

const langs = [
  Language("\u{1F1E9}\u{1F1EA}", "German"),
  Language("\u{1F1FA}\u{1F1F8}", "English"),
  Language("\u{1F1EB}\u{1F1F7}", "French"),
  Language("\u{1F1EA}\u{1F1F8}", "Spanish"),
];
