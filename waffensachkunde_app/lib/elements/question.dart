import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:waffensachkunde_app/singletons/learn_data.dart';

class Question extends StatelessWidget {
  const Question({super.key, required this.questionObject});

  final QuestionObject questionObject;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        questionObject.id,
        style: TextStyle(
            fontSize: 20, color: Theme.of(context).colorScheme.onBackground),
      ).padding(bottom: 5),
      Text(
        questionObject.question,
        style: TextStyle(
            fontSize: 20, color: Theme.of(context).colorScheme.onBackground),
        textAlign: TextAlign.center,
      )
    ]).padding(horizontal: 50, bottom: 30, top: 30);
  }
}
