import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:waffensachkunde_app/singletons/learn_data.dart';

class Answer extends StatefulWidget {
  const Answer(
      {super.key,
      required this.questionObject,
      required this.answer,
      required this.answerId,
      required this.onAnswerCheckChanged,
      required this.requiresTicked,
      this.wasCorrect});

  final QuestionObject questionObject;
  final String answer;
  final String answerId;
  final bool? wasCorrect;
  final bool requiresTicked;
  final Function(String, bool) onAnswerCheckChanged;

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  bool bChecked = false;

  void onCheckStateChanged(bool? state) {
    widget.onAnswerCheckChanged(widget.answerId, state!);
    setState(() {
      bChecked = state;
    });
  }

  void onAnswerTap() {
    widget.onAnswerCheckChanged(widget.answerId, !bChecked);
    setState(() {
      bChecked = !bChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool bCheckboxState = bChecked;

    Color? checkBoxColor;

    if (widget.wasCorrect != null) {
      if (widget.requiresTicked) {
        bCheckboxState = true;
        if (widget.wasCorrect == true) {
          checkBoxColor = Colors.green;
        } else {
          checkBoxColor = Colors.red;
        }
      } else {
        if (bCheckboxState) {
          checkBoxColor = Colors.red;
        }
        bCheckboxState = false;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Checkbox(
          value: bCheckboxState,
          onChanged: onCheckStateChanged,
          fillColor: MaterialStateProperty.all(checkBoxColor),
          side: const BorderSide(color: Colors.white),
        ).padding(right: 20),
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                    onTap: onAnswerTap,
                    child: AnimatedContainer(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 70, 70, 70),
                            border: Border.all(
                                color: checkBoxColor ?? Colors.transparent)),
                        padding: EdgeInsets.all(20),
                        duration: Duration(milliseconds: 200),
                        child: Text(
                          widget.answer,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 241, 241, 241)),
                        )))))
      ],
    ).padding(horizontal: 30);
  }
}
