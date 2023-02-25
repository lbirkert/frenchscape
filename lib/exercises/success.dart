import "package:frenchscape/frenchscape.dart";

class SuccessDialog extends StatelessWidget {
  static const List<String> successTexts = [
    "WOW!",
    "Great Job!",
    "Well Done!",
    "Great!",
    "Stark Brudi!",
    "Insane!",
    "Magnificent!",
    "Fabulous!",
    "Yeah!",
    "Just like that!",
    "Keep going!",
  ];

  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(randomElement(successTexts),
                  style: theme.textTheme.headlineLarge)
              .animate()
              .move(
                delay: 200.ms,
                duration: 2000.ms,
                begin: const Offset(-40, 0),
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 5),
          Text("You solved this puzzle", style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          FilledButton(
            child: const Text("Next"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ).animate().move(
                delay: 200.ms,
                duration: 2000.ms,
                begin: const Offset(40, 0),
                curve: Curves.elasticOut,
              ),
        ],
      ),
    ).animate().scale();
  }
}
