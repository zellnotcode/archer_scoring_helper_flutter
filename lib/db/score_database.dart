import 'dart:core';

import 'package:archer_score_helper/data/model/game.dart';
import 'package:archer_score_helper/data/model/score.dart';
import 'package:archer_score_helper/data/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ScoreDatabase {
  static final ScoreDatabase instance = ScoreDatabase._init();

  static Database? _database;

  ScoreDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableGame (
      ${GameFields.id} $idType,
      ${GameFields.name} $textType,
      ${GameFields.distance} $integerType,
      ${GameFields.set} $integerType,
      ${GameFields.interval} $integerType
    )
    ''');

    await db.execute(''' 
    CREATE TABLE $tableUser (
      ${UserFields.id} $idType,
      ${UserFields.name} $textType,
      ${UserFields.age} $integerType
    )
    ''');

    await db.execute(''' 
    CREATE TABLE $tableScore(
      ${ScoreFields.id} $idType,
      ${ScoreFields.gameId} $integerType,
      ${ScoreFields.userId} $integerType,
      ${ScoreFields.setNumber} 'INTEGER NULL',
      ${ScoreFields.score} 'INTEGER NULL',
      FOREIGN KEY (${ScoreFields.gameId}) REFERENCES $tableGame(${GameFields.id}),
      FOREIGN KEY (${ScoreFields.userId}) REFERENCES $tableUser(${UserFields.id})
    )
     ''');
  }

  Future<User> insertUser(User user) async {
    final db = await instance.database;

    final id = await db.insert(tableUser, user.toJson());
    return user.copy(id: id);
  }

  Future<User> userById(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableUser,
        columns: UserFields.values,
        where: '${UserFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<User>> readAllUser() async {
    final db = await instance.database;

    final result = await db.query(tableUser);

    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<Game> insertGame(Game game) async {
    final db = await instance.database;

    final id = await db.insert(tableGame, game.toJson());
    return game.copy(id: id);
  }

  Future<Game> gameById(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableGame,
        columns: GameFields.values,
        where: '${GameFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Game.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<Game>> readAllGame() async {
    final db = await instance.database;

    final result = await db.query(tableGame);

    return result.map((json) => Game.fromJson(json)).toList();
  }

  Future<Score> insertScoreWithoutSetScore(Score score) async {
    final db = await instance.database;

    final id = await db.insert(tableScore, score.toJson());
    return score.copy(id: id);
  }

  Future<List<int>> getUserGame(int gameId) async {
    final db = await instance.database;

    final result = await db.rawQuery("""
    SELECT DISTINCT user_id FROM scores WHERE game_id = ?
    """, [gameId]);

    return result.map((row) => row[ScoreFields.userId] as int).toList();
  }

  Future<List<Score>> getScoreByIdGameId(int userId, int gameId) async {
    final db = await instance.database;

    try {
      final result = await db.rawQuery("""
      SELECT *
      FROM scores WHERE user_id = ? AND game_id = ? ORDER BY _id ASC
    """, [userId, gameId]);

      return result.map((json) => Score.fromJson(json)).toList();
    } catch (e) {
      return []; // Return an empty list if there's an error.
    }
  }

  Future<int> updateScore(int scoreId, int newScore) async {
    final db = await instance.database;

    final result = await db.rawUpdate('''
    UPDATE $tableScore
    SET ${ScoreFields.score} = ?
    WHERE ${ScoreFields.id} = ?
  ''', [newScore, scoreId]);

    return result;
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
