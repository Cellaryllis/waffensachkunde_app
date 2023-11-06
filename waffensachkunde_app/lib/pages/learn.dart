import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:waffensachkunde_app/elements/answer.dart';
import 'package:waffensachkunde_app/elements/progress.dart';
import 'package:waffensachkunde_app/elements/question.dart';
import 'package:waffensachkunde_app/singletons/learn_data.dart';

class Learn extends StatefulWidget {
  const Learn({super.key, required this.learnRandom});

  final bool learnRandom;

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  late QuestionObject currentQuestion;
  List<bool> answerStates = [];
  bool bAnswering = true;

  @override
  void initState() {
    super.initState();

    getNextLearnQuestion();
  }

  void getNextLearnQuestion() {
    currentQuestion = LearnDataManager().getNextQuestion(widget.learnRandom);
    answerStates = List<bool>.filled(currentQuestion.answers.length, false);
    bAnswering = true;
    if (mounted) {
      setState(() {});
    }
  }

  void onAnswerCheckChanged(String id, bool checkedState) {
    answerStates[LearnDataManager().anwserIdtoIndex(id)] = checkedState;
  }

  void pressedSubmit() {
    bAnswering = false;

    bool allCorrect = true;

    int index = 0;
    currentQuestion.answers.forEach((answer) {
      final bool isRequiredAnswer = currentQuestion.correctAnswers
          .contains(LearnDataManager().indexToAnswerId(index));

      final bool wasCorrect = answerStates[index] == isRequiredAnswer;
      if (!wasCorrect) {
        allCorrect = false;
      }

      index++;
    });

    LearnDataManager().updateQuestionResult(currentQuestion.id, allCorrect);

    setState(() {});
  }

  Widget getAnswers() {
    List<Widget> answers = [];

    int index = 0;
    currentQuestion.answers.forEach((answer) {
      final bool isRequiredAnswer = currentQuestion.correctAnswers
          .contains(LearnDataManager().indexToAnswerId(index));

      bool? wasCorrect;
      if (!bAnswering) {
        wasCorrect = answerStates[index] == isRequiredAnswer;
      }

      answers.add(Answer(
          key: Key(answer),
          questionObject: currentQuestion,
          answer: answer,
          requiresTicked: isRequiredAnswer,
          wasCorrect: wasCorrect,
          answerId: LearnDataManager().indexToAnswerId(index),
          onAnswerCheckChanged: onAnswerCheckChanged));

      index++;
    });

    return Column(
      children: answers,
    );
  }

  Widget getLearnProgress() {
    return LearnProgress(
        progress: LearnDataManager().getQuestionProgress(currentQuestion.id));
  }

  Widget getSubmitButton() {
    if (bAnswering) {
      return ElevatedButton.icon(
              onPressed: pressedSubmit,
              icon: const Icon(Icons.arrow_right),
              label: const Text("Submit").padding(vertical: 20))
          .width(300)
          .padding(top: 50);
    }

    return ElevatedButton.icon(
            onPressed: getNextLearnQuestion,
            icon: const Icon(Icons.arrow_right),
            label: const Text("Next question").padding(vertical: 20))
        .width(300)
        .padding(top: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn"),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scrollbar(
            controller: PrimaryScrollController.maybeOf(context),
            child: SingleChildScrollView(
                controller: PrimaryScrollController.maybeOf(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getLearnProgress(),
                    Question(questionObject: currentQuestion),
                    getAnswers(),
                    getSubmitButton().padding(bottom: 30)
                  ],
                )),
          )),
    );
  }
}
