import "package:flutter/material.dart";

class VocLang {
  const VocLang(this.flag, this.name);

  final String flag;
  final String name;

  Widget avatar(BuildContext context) {
    return CircleAvatar(
      child: Text(flag)
    );
  }

  Widget full(BuildContext context) {
    return Text("$flag $name");
  }
}

const langs = [
  VocLang("\u{1F1E9}\u{1F1EA}", "German"),
  VocLang("\u{1F1FA}\u{1F1F8}", "English"),
  VocLang("\u{1F1EB}\u{1F1F7}", "French"),
  VocLang("\u{1F1EA}\u{1F1F8}", "Spanish"),
];
