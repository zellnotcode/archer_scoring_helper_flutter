import 'package:archer_score_helper/component/container_item.dart';
import 'package:archer_score_helper/component/user_item.dart';
import 'package:archer_score_helper/db/score_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/color.dart';
import '../data/model/user.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ScoreDatabase _scoreDatabase = ScoreDatabase.instance;
  List<User> _users = [];

  Future<void> _addUsers(User user) async {
    await _scoreDatabase.insertUser(user);
    setState(() {
      _users.add(user);
    });
  }

  void _openAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? name;
        int age = 0;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    age = int.parse(value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  child: Container(
                    color: CustomColor.yellow,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(color: CustomColor.blue),
                    ),
                  ),
                  onTap: () {
                    if (name != null) {
                      User newData = User(name: name.toString(), age: age);
                      _addUsers(newData);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  Future<void> _loadUsers() async {
    List<User> users = await _scoreDatabase.readAllUser();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _openAddDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ContainerItem(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Add New',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: CustomColor.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return UserItem(
                      name: user.name,
                      age: user.age.toString(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
