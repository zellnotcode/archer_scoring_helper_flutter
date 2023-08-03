import 'package:archer_score_helper/constant/color.dart';
import 'package:archer_score_helper/data/model/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../db/score_database.dart';

class ScoreListItem extends StatefulWidget {
  final List<Score> listScore;

  const ScoreListItem({super.key, required this.listScore});

  @override
  State<ScoreListItem> createState() => _ScoreListItemState();
}

class _ScoreListItemState extends State<ScoreListItem> {
  final ScoreDatabase _scoreDatabase = ScoreDatabase.instance;
  List<Score> editedList = [];
  List<TextEditingController> scoreControllers = [];

  Future<void> updateScore(int scoreId, int newScore) async {
    await _scoreDatabase.updateScore(scoreId, newScore);
  }

  @override
  void initState() {
    editedList = List.from(widget.listScore);
    for (var score in editedList) {
      var controller = TextEditingController(
        text: score.score != null ? score.score.toString() : '',
      );
      controller.addListener(() {
        _onScoreChanged(score, controller.text);
      });
      scoreControllers.add(controller);
    }
    super.initState();
  }

  void _onScoreChanged(Score score, String value) {
    int index = widget.listScore.indexOf(score);
    if (index != -1) {
      int parsedValue = int.tryParse(value) ?? 0;
      setState(() {
        editedList[index] = editedList[index].copy(score: parsedValue);
      });
    }
  }

  double calculateAverageScore(List<Score> scores) {
    double totalScore = 0;
    int validScoresCount = 0;

    for (var score in scores) {
      if (score.score != null && score.score! < 11) {
        totalScore += score.score!;
        validScoresCount++;
      }
    }

    return validScoresCount > 0 ? totalScore / validScoresCount : 0;
  }

  int calculateTotalScore(List<Score> scores) {
    int totalScore = 0;

    for (var score in scores) {
      if (score.score != null && score.score! < 11) {
        totalScore += score.score!;
      }
    }

    return totalScore;
  }

  List<int?> getSetNumbers(List<Score> scores) {
    return scores.map((score) => score.setNumber).toSet().toList();
  }

  List<Score> getScoresForSet(List<Score> scores, int setNumber) {
    return scores.where((score) => score.setNumber == setNumber).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.blue,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            for (var setNumber in getSetNumbers(editedList))
              Column(
                children: [
                  Text(
                    'Set ${setNumber.toString()}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.white,
                    ),
                  ),
                  Wrap(
                    children: [
                      for (var score in getScoresForSet(editedList, setNumber!))
                        Container(
                          width: 40,
                          height: 24,
                          color: CustomColor.white,
                          child: Center(
                            child: TextField(
                              controller:
                                  scoreControllers[editedList.indexOf(score)],
                              onChanged: (value) async {
                                await updateScore(score.id!, int.parse(value));
                                _onScoreChanged(score, value);
                              },
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: CustomColor.blue,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                _NumberRangeTextInputFormatter(min: 0, max: 10)
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 40,
                        height: 24,
                        color: CustomColor.white,
                        child: Center(
                          child: Text(
                            calculateTotalScore(
                                    getScoresForSet(editedList, setNumber))
                                .toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: CustomColor.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _NumberRangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _NumberRangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int value = int.tryParse(newValue.text) ?? min;
    if (value < min) value = min;
    if (value > max) value = max;

    return TextEditingValue(
      text: value.toString(),
      selection: TextSelection.fromPosition(
          TextPosition(offset: value.toString().length)),
    );
  }
}
