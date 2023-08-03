import 'package:archer_score_helper/component/user_list_score.dart';
import 'package:archer_score_helper/constant/color.dart';
import 'package:archer_score_helper/data/model/user.dart';
import 'package:archer_score_helper/db/score_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../data/model/game.dart';
import '../data/model/score.dart';

class DetailGameScreen extends StatefulWidget {
  final Game gameData;
  const DetailGameScreen({super.key, required this.gameData});

  @override
  State<DetailGameScreen> createState() => _DetailGameScreenState();
}

class _DetailGameScreenState extends State<DetailGameScreen> {
  final ScoreDatabase _scoreDatabase = ScoreDatabase.instance;
  List<int> listUserId = [];
  List<User> listUserData = [];

  Future<void> getUserGame() async {
    List<int> result = await _scoreDatabase.getUserGame(widget.gameData.id!);
    listUserId = result;
    for (var i = 0; i < listUserId.length; i++) {
      int id = listUserId[i];
      getUserData(id);
    }
  }

  Future<Game> getGameById(int id) async {
    Game game = await _scoreDatabase.gameById(id);
    return game;
  }

  Future<User> getUserById(int id) async {
    final user = await _scoreDatabase.userById(id);
    return user;
  }

  Future<void> getUserData(int id) async {
    User result = await _scoreDatabase.userById(id);
    listUserData.add(result);
  }

  Future<List<Score>> getScoreByidGameId(int userId, int gameId) async {
    List<Score> result =
        await _scoreDatabase.getScoreByIdGameId(userId, gameId);
    return result;
  }

  Future<void> exportToExcel(BuildContext context, List<Score> scores) async {
    final excel = Excel.createExcel();
    final userTotalScores = <int, int>{};

    for (var score in scores) {
      final userId = score.userId;
      final totalScore = userTotalScores[userId] ?? 0;
      userTotalScores[userId] = totalScore + (score.score ?? 0);
    }

    final sheet = excel['scores'];
    final sortedUsers = userTotalScores.keys.toList()
      ..sort((a, b) => userTotalScores[b]!.compareTo(userTotalScores[a]!));

    for (var rank = 0; rank < sortedUsers.length; rank++) {
      final userId = sortedUsers[rank];
      final userScores =
          scores.where((score) => score.userId == userId).toList();
      final userName = await getUserById(userId);

      sheet.appendRow(['Username', userName.name]);
      sheet.appendRow(['Rank', rank + 1]);

      int maxScores = userScores.fold(
          0, (max, score) => score.setNumber == null ? max : score.setNumber!);

      final headerRow = [
        'Set',
        for (int i = 1; i <= maxScores; i++) 'Score $i'
      ];
      sheet.appendRow(headerRow);

      final userSetScores = List.generate(maxScores, (_) => <String>[]);

      for (var setNumber = 1; setNumber <= maxScores; setNumber++) {
        final userSetScore =
            userScores.where((score) => score.setNumber == setNumber).toList();

        final row = [
          setNumber.toString(),
          for (var score in userSetScore) score.score.toString(),
        ];

        userSetScores[setNumber - 1].addAll(row);
      }

      for (var setNumber = 0; setNumber < maxScores; setNumber++) {
        sheet.appendRow(userSetScores[setNumber]);
      }
    }

    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      final excelBytes = excel.save();
      if (excelBytes != null) {
        File('/storage/emulated/0/Download/${widget.gameData.name}.xlsx')
          ..createSync(recursive: true)
          ..writeAsBytesSync(excelBytes);
        _showSnackbar(context, "Exported");
      }
    } else if (status == PermissionStatus.denied) {
      _showSnackbar(context, "Permission Denied");
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showSnackbar(context, "Permission Permanent Denied");
    }
  }

  void _onTapExport(BuildContext context) async {
    if (listUserId.isNotEmpty) {
      List<Score> allScores = [];

      for (int i = 0; i < listUserId.length; i++) {
        int userId = listUserId[i];
        List<Score> scores =
            await getScoreByidGameId(userId, widget.gameData.id!);
        allScores.addAll(scores);
      }

      for (int x = 0; x < allScores.length; x++) {}
      await exportToExcel(context, allScores);
    }
  }

  void _showSnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    getUserGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              listUserId.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        _onTapExport(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 120,
                        height: 30,
                        decoration: BoxDecoration(
                          color: CustomColor.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Export',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: CustomColor.white),
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(
                      color: CustomColor.blue,
                    ),
              const SizedBox(
                height: 20,
              ),
              Text("Distance ${widget.gameData.distance}",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: CustomColor.blue,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder<void>(
                  future: getUserGame(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: CustomColor.blue,
                        ),
                      );
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: listUserData.length,
                          itemBuilder: (context, index) {
                            int userId = listUserData[index].id!;

                            Future<List<Score>> allScores =
                                getScoreByidGameId(userId, widget.gameData.id!);

                            return FutureBuilder<List<Score>>(
                                future: allScores,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Text("Loading"),
                                    );
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      !snapshot.hasData) {
                                    return const Text("No Data");
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading scores');
                                  } else {
                                    List<Score> allScoresData =
                                        snapshot.data as List<Score>;
                                    return allScoresData.isEmpty
                                        ? const Text("Empty")
                                        : Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: UserListScore(
                                              username:
                                                  listUserData[index].name,
                                              setScores: [allScoresData],
                                            ),
                                          );
                                  }
                                });
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
