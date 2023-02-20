import "package:flutter/material.dart";

class InsightsPage extends StatelessWidget {
  const InsightsPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(child: Column(
        children: [
          Text("Insights", style: Theme.of(context).textTheme.headlineLarge!),
          const SizedBox(height: 10),
          const Text("View the statistics of your learning process", textAlign: TextAlign.center)
        ]
      ))
    );
  }
}
