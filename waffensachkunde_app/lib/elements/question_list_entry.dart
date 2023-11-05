import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:waffensachkunde_app/elements/progress.dart';
import 'package:waffensachkunde_app/singletons/learn_data.dart';

class QuestionListEntry extends StatelessWidget {
  const QuestionListEntry({super.key, required this.question});

  final QuestionObject question;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            question.question,
            style: const TextStyle(color: Color.fromARGB(255, 238, 237, 237)),
          )),
      LearnProgress(
              progress: LearnDataManager().getQuestionProgress(question.id))
          .padding(bottom: 20)
    ]));
  }
}
