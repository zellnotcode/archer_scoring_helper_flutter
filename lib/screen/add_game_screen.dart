import 'package:archer_score_helper/component/container_item.dart';
import 'package:archer_score_helper/constant/color.dart';
import 'package:archer_score_helper/data/model/game.dart';
import 'package:archer_score_helper/data/model/score.dart';
import 'package:archer_score_helper/db/score_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/model/user.dart';

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  bool _isLoading = false;
  String? name;
  List<User> listUser = [];
  List<User>? selectedUser;
  String? distance;
  String? set;
  String? interval;
  String selectedUserString = '';
  final ScoreDatabase _scoreDatabase = ScoreDatabase.instance;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  Future<void> _loadUsers() async {
    List<User> users = await _scoreDatabase.readAllUser();
    setState(() {
      listUser = users;
    });
  }

  Future<void> insertGameWithScores(
      Game game, int numberOfSets, int scorePerSet) async {
    Game gameInserted = await _scoreDatabase.insertGame(game);

    for (var user in selectedUser!) {
      for (var setNumber = 1; setNumber <= numberOfSets; setNumber++) {
        for (var scoreIndex = 1; scoreIndex <= scorePerSet; scoreIndex++) {
          Score addScore = Score(
            gameId: gameInserted.id!,
            userId: user.id!,
            setNumber: setNumber,
            score: 0,
          );
          await insertScoreWithoutSetScore(addScore);
        }
      }
    }
  }

  Future<void> insertScoreWithoutSetScore(Score score) async {
    await _scoreDatabase.insertScoreWithoutSetScore(score);
  }

  void _showCheckboxDialog() async {
    selectedUser = await showDialog<List<User>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Select User',
              style: GoogleFonts.poppins(),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: listUser.map((user) {
                  bool isChecked = selectedUser?.contains(user) ?? false;
                  return CheckboxListTile(
                    title: Text(user.name),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                        selectedUser ??= [];
                        if (value) {
                          selectedUser!.add(user);
                        } else {
                          selectedUser!.remove(user);
                        }
                        selectedUserString =
                            selectedUser?.map((user) => user.name).join(", ") ??
                                '';
                        controller.text = selectedUserString;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(selectedUser);
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ContainerItem(
              height: 570,
              child: Column(
                children: [
                  Text(
                    'Name',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    style: GoogleFonts.poppins(),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: CustomColor.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'User',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () => _showCheckboxDialog(),
                    child: TextField(
                      enabled: false,
                      controller: controller,
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: CustomColor.white,
                        suffixIcon: Image.asset(
                          "assets/ic_arrow_right.png",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Distance',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    onChanged: (value) {
                      distance = value;
                    },
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: CustomColor.white),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              'Set',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColor.white),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 87,
                            height: 57,
                            child: TextField(
                              onChanged: (value) {
                                set = value;
                              },
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.poppins(),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: CustomColor.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              'Interval',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColor.white),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 87,
                            height: 57,
                            child: TextField(
                              onChanged: (value) {
                                interval = value;
                              },
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.poppins(),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: CustomColor.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColor.yellow,
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: CustomColor.blue,
                              )
                            : Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                    color: CustomColor.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _isLoading = true;
                      });
                      if (name != null &&
                          selectedUser != null &&
                          distance != null &&
                          set != null &&
                          interval != null) {
                        Game newGame = Game(
                            name: name!,
                            distance: int.parse(distance!),
                            set: int.parse(set!),
                            interval: int.parse(interval!));

                        insertGameWithScores(
                            newGame, int.parse(set!), int.parse(interval!));
                        setState(() {
                          _isLoading = false;
                        });

                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
