import 'package:archer_score_helper/component/score_list.dart';
import 'package:archer_score_helper/data/model/score.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserListScore extends StatelessWidget {
  final String username;
  final List<List<Score>> setScores;

  const UserListScore(
      {super.key, required this.username, required this.setScores});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            username,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            children: setScores.map((set) {
              return ScoreListItem(listScore: set);
            }).toList(),
          )
        ],
      ),
    );
  }
}
