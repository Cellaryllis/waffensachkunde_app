import 'dart:async';

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:waffensachkunde_app/pages/learn.dart';
import 'package:waffensachkunde_app/pages/questions.dart';
import 'package:waffensachkunde_app/singletons/learn_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    checkForInitialized();
  }

  void checkForInitialized() {
    if (!LearnDataManager().isInitialized()) {
      Future.delayed(const Duration(milliseconds: 100), checkForInitialized);
      return;
    }

    setState(() {});
  }

  void onPressedQuestionsList() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => const QuestionsList()));
  }

  void onPressedLearn() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => const Learn()));
    setState(() {});
  }

  Widget getSessionStats() {
    double pct = LearnDataManager().getSessionPctCorrect() * 100;

    return Column(
      children: [
        Text("Session stats:",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            )),
        Text("${pct.toStringAsFixed(2)}%",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            )).padding(bottom: 5),
        LinearProgressIndicator(
          value: LearnDataManager().getSessionPctCorrect(),
          minHeight: 15,
          backgroundColor: const Color.fromARGB(255, 122, 122, 122),
          color: Theme.of(context).colorScheme.primary,
        ).width(300).clipRRect(all: 30)
      ],
    ).padding(top: 50);
  }

  @override
  Widget build(BuildContext context) {
    if (!LearnDataManager().isInitialized()) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
                  onPressed: onPressedQuestionsList,
                  icon: const Icon(Icons.list),
                  label:
                      const Text("View questions list").padding(vertical: 10))
              .width(200),
          ElevatedButton.icon(
                  onPressed: onPressedLearn,
                  icon: const Icon(Icons.question_answer),
                  label: const Text("Learn").padding(vertical: 10))
              .width(200)
              .padding(top: 20),
          getSessionStats()
        ],
      ))),
    );
  }
}
