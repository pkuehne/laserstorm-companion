import 'package:flutter/material.dart';

class TileTitle extends StatelessWidget {
  final String title;
  final String cost;

  const TileTitle({super.key, required this.title, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          width: 10,
        ),
        Text("($cost pts)"),
      ],
    );
  }
}

/// Displays a stat with an icon and tooltip
///
/// The stat, its value and the icon to use must be supplied at creation.
/// The value of the stat must be a string.
class StatDisplay extends StatelessWidget {
  const StatDisplay({
    super.key,
    required this.stat,
    required this.value,
    required this.icon,
  });

  final String stat;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Tooltip(
        message: "$stat: $value",
        child: Column(
          children: [
            Text(stat),
            Text(value),
          ],
        ),
      ),
    );
  }
}
