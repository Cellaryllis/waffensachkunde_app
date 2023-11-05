import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class LearnProgress extends StatelessWidget {
  const LearnProgress({super.key, required this.progress});

  final int progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$progress/30",
          style: const TextStyle(color: Color.fromARGB(255, 231, 231, 231)),
        ).padding(right: 10),
        Expanded(
            child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 170),
          curve: Curves.easeInOut,
          tween: Tween<double>(
            begin: 0,
            end: progress.toDouble() / 30.0,
          ),
          builder: (context, value, _) => LinearProgressIndicator(
            minHeight: 20,
            backgroundColor: const Color.fromARGB(255, 122, 122, 122),
            color: Theme.of(context).colorScheme.primary,
            value: value,
          ),
        ).clipRRect(all: 30))
      ],
    ).padding(horizontal: 60, top: 30);
  }
}
