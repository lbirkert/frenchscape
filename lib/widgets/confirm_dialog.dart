import "package:frenchscape/frenchscape.dart";

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirm,
    required this.cancel,
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
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirm),
        ),
      ],
    );
  }

  static Future<bool> ask({
    required BuildContext context,
    required String title,
    required String description,
    String confirm = "Confirm",
    String cancel = "Cancel",
  }) async {
    return await showDialog<bool?>(
          context: context,
          builder: (_) => ConfirmDialog(
            title: title,
            description: description,
            confirm: confirm,
            cancel: cancel,
          ),
        ) ??
        false;
  }
}
