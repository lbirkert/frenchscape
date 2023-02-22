import "package:frenchscape/frenchscape.dart";

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    this.confirm = "Confirm",
    this.cancel = "Cancel",
  });

  final String title;
  final String description;

  final String confirm;
  final String cancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirm),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancel),
        ),
      ],
    );
  }
}
