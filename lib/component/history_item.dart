import 'package:archer_score_helper/component/container_item.dart';
import 'package:archer_score_helper/constant/color.dart';
import 'package:archer_score_helper/screen/detail_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/model/game.dart';

class HistoryItem extends StatelessWidget {
  final Game game;

  const HistoryItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailGameScreen(
              gameData: game,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: ContainerItem(
          height: 65,
          child: Text(
            game.name,
            style: GoogleFonts.poppins(
                color: CustomColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
