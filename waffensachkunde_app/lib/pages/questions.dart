import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:waffensachkunde_app/elements/question_list_entry.dart';
import 'package:waffensachkunde_app/singletons/learn_data.dart';

class QuestionsList extends StatefulWidget {
  const QuestionsList({super.key});

  @override
  State<QuestionsList> createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  RangeValues sliderValues = RangeValues(0, 30);

  @override
  void initState() {
    super.initState();
  }

  Widget getContent() {
    Iterable<LearnDataEntry> learnEntries =
        LearnDataManager().getOrderedLearnDataEntries().reversed;
    Iterable<LearnDataEntry> filteredLearnEntries = learnEntries.where(
        (element) =>
            element.progress >= sliderValues.start &&
            element.progress <= sliderValues.end);

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(
        "${filteredLearnEntries.length} questions",
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      Expanded(
          child: ListView.separated(
        controller: PrimaryScrollController.maybeOf(context),
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: filteredLearnEntries.length,
        itemBuilder: (BuildContext context, int index) {
          QuestionObject question = LearnDataManager()
              .getQuestions()
              .firstWhere((element) =>
                  filteredLearnEntries.elementAt(index).id == element.id);
          return QuestionListEntry(question: question)
              .padding(left: 20, right: 20);
        },
      ))
    ]);
  }

  void onRangeChanged(RangeValues values) {
    sliderValues = values;
    setState(() {});
  }

  Widget getTopFilter() {
    return Column(children: [
      Text(
        "Filter progress: ${sliderValues.start.round()} <=> ${sliderValues.end.round()}",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 15,
            fontWeight: FontWeight.w400),
      ).padding(top: 20),
      RangeSlider(
        onChanged: onRangeChanged,
        min: 0,
        max: 30,
        divisions: 30,
        values: sliderValues,
      ).padding(horizontal: 20),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Questions overview"),
        ),
        body: Column(
          children: [getTopFilter(), Expanded(child: getContent())],
        ));
  }
}
