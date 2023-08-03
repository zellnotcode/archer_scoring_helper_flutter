import 'package:archer_score_helper/component/history_item.dart';
import 'package:archer_score_helper/constant/color.dart';
import 'package:archer_score_helper/data/model/game.dart';
import 'package:archer_score_helper/db/score_database.dart';
import 'package:archer_score_helper/screen/add_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Game> _gameData = [];
  final ScoreDatabase _scoreDatabase = ScoreDatabase.instance;

  @override
  void initState() {
    _loadGames();
    super.initState();
  }

  Future<void> _loadGames() async {
    List<Game> games = await _scoreDatabase.readAllGame();
    setState(() {
      _gameData = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.blue,
        title: Text(
          "Data Game",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
            itemCount: _gameData.length,
            itemBuilder: (context, index) {
              return HistoryItem(game: _gameData[index]);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.yellow,
        onPressed: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddGameScreen()));
          if (result == true) {
            setState(() {
              _loadGames();
            });
          }
        },
        child: const Icon(
          Icons.add,
          color: CustomColor.blue,
        ),
      ),
    );
  }
}
