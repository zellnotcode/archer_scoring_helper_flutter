const String tableScore = 'scores';

class ScoreFields {
  static final List<String> values = [id, gameId, userId, setNumber, score];

  static const String id = '_id';
  static const String gameId = 'game_id';
  static const String userId = 'user_id';
  static const String setNumber = 'set_number';
  static const String score = 'score';
}

class Score {
  final int? id;
  final int gameId;
  final int userId;
  final int? setNumber;
  final int? score;

  Score(
      {this.id,
      required this.gameId,
      required this.userId,
      this.setNumber,
      this.score});

  Score copy({int? id, int? gameId, int? userId, int? setNumber, int? score}) =>
      Score(
          id: id ?? this.id,
          gameId: gameId ?? this.gameId,
          userId: userId ?? this.userId,
          setNumber: setNumber ?? this.setNumber,
          score: score ?? this.score);

  static Score fromJson(Map<String, Object?> json) => Score(
      id: json[ScoreFields.id] as int?,
      gameId: json[ScoreFields.gameId] as int,
      userId: json[ScoreFields.userId] as int,
      setNumber: json[ScoreFields.setNumber] as int,
      score: json[ScoreFields.score] as int);

  Map<String, Object?> toJson() => {
        ScoreFields.id: id,
        ScoreFields.gameId: gameId,
        ScoreFields.userId: userId,
        ScoreFields.setNumber: setNumber,
        ScoreFields.score: score
      };
}
