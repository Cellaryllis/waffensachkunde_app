import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tuple/tuple.dart';

class QuestionObject {
  final String id;
  final String question;
  final List<String> answers;
  final List<String> correctAnswers;

  QuestionObject(
      {required this.id,
      required this.question,
      required this.answers,
      required this.correctAnswers});
}

class LearnDataEntry {
  final String id;
  final int progress;

  LearnDataEntry(this.id, this.progress);
}

class LearnData {
  Map<String, int> learnProgress = {};
  List<LearnDataEntry> orderedLearnProgress = [];
}

class LearnDataManager {
  static LearnDataManager? _instance;

  LearnDataManager._() {}

  factory LearnDataManager() {
    if (_instance == null) {
      _instance = new LearnDataManager._();
    }
    return _instance!;
  }

  bool _initialized = false;
  LearnData _learnData = LearnData();
  List<QuestionObject> _questions = [];

  // numCorrect, total
  Tuple2<int, int> _sessionStats = Tuple2(0, 0);

  void load() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = '${dir.path}/learn.db';

    File file = File(dbPath);
    bool exists = await file.exists();

    if (exists) {
      String jsonObjectString = await file.readAsString();
      if (jsonObjectString.isNotEmpty) {
        final Map<String, dynamic> loadedValues =
            ((jsonDecode(jsonObjectString)) ?? <String, dynamic>{})
                as Map<String, dynamic>;
        _learnData.learnProgress = (loadedValues as Map<String, dynamic>)
            .map<String, int>((key, value) => MapEntry(key, value as int));
      }
    } else {
      _learnData.learnProgress = {};
    }

    final questionsFile = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> questionsJson = jsonDecode(questionsFile);

    questionsJson.forEach((element) {
      _questions.add(QuestionObject(
          id: element["id"],
          question: element["question"],
          answers: (element["answers"] as List<dynamic>)
              .map<String>((e) => e as String)
              .toList(),
          correctAnswers: (element["correct"] as List<dynamic>)
              .map<String>((e) => e as String)
              .toList()));
    });

    if (_learnData.learnProgress.isEmpty) {
      _questions.forEach((element) {
        _learnData.learnProgress[element.id] = 0;
      });
    }

    _learnData.learnProgress.forEach((key, value) {
      _learnData.orderedLearnProgress.add(LearnDataEntry(key, value));
    });

    sortOrderedLearnData();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      save();
    });

    _initialized = true;
  }

  void save() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = '${dir.path}/learn.db';

    File file = File(dbPath);
    file.writeAsStringSync(jsonEncode(_learnData.learnProgress));
  }

  void updateQuestionResult(String id, bool wasCorrect) {
    int currentLearnProgress = _learnData.learnProgress[id]!;
    if (wasCorrect) {
      if (currentLearnProgress < 30) {
        currentLearnProgress++;
      }
    } else {
      if (currentLearnProgress > 0) {
        currentLearnProgress--;
      }
    }

    _learnData.learnProgress[id] = currentLearnProgress;

    _learnData.orderedLearnProgress.removeWhere((element) => element.id == id);
    _learnData.orderedLearnProgress
        .add(LearnDataEntry(id, currentLearnProgress));
    sortOrderedLearnData();

    _sessionStats = Tuple2(
        _sessionStats.item1 + (wasCorrect ? 1 : 0), _sessionStats.item2 + 1);
  }

  void sortOrderedLearnData() {
    _learnData.orderedLearnProgress.sort((a, b) => a.progress - b.progress);
  }

  bool isInitialized() => _initialized;
  List<QuestionObject> getQuestions() => _questions;
  List<LearnDataEntry> getOrderedLearnDataEntries() =>
      _learnData.orderedLearnProgress;
  QuestionObject getNextQuestion() {
    // Shuffle the data, then order the data, this will randomize keys with the same progress
    _learnData.orderedLearnProgress.shuffle();
    sortOrderedLearnData();

    double rand = Random().nextDouble();
    for (int i = 0; i < 10; ++i) {
      rand -= i * .1;
      if (rand <= 0.0) {
        return _questions.firstWhere(
            (element) => element.id == _learnData.orderedLearnProgress[i].id);
      }
    }

    return _questions[Random().nextInt(_questions.length - 1)];
  }

  String indexToAnswerId(int index) {
    switch (index) {
      case 0:
        return "a";
      case 1:
        return "b";
      case 2:
        return "c";
      case 3:
        return "d";
      case 4:
        return "e";
      case 5:
        return "f";
      case 6:
        return "g";
      case 7:
        return "h";
      case 8:
        return "i";
      case 9:
        return "j";
      case 10:
        return "k";
    }

    assert(false, "Unable to find answer id from index $index");
    return "ERROR";
  }

  int anwserIdtoIndex(String answerId) {
    switch (answerId) {
      case "a":
        return 0;
      case "b":
        return 1;
      case "c":
        return 2;
      case "d":
        return 3;
      case "e":
        return 4;
      case "f":
        return 5;
      case "g":
        return 6;
      case "h":
        return 7;
      case "i":
        return 8;
      case "j":
        return 9;
      case "k":
        return 10;
    }

    assert(false, "Unable to find index from answerId $answerId");
    return -1;
  }

  int getQuestionProgress(String id) {
    return _learnData.learnProgress[id]!;
  }

  double getSessionPctCorrect() {
    if (_sessionStats.item2 == 0) {
      return 0;
    }
    return _sessionStats.item1.toDouble() / _sessionStats.item2.toDouble();
  }
}
