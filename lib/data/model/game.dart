const String tableGame = 'games';

class GameFields {
  static final List<String> values = [id, name, distance, set, interval];

  static const id = 'game_id';
  static const name = 'game_name';
  static const distance = 'game_distance';
  static const set = 'game_set';
  static const interval = 'game_interval';
}

class Game {
  final int? id;
  final String name;
  final int distance;
  final int set;
  final int interval;

  Game(
      {this.id,
      required this.name,
      required this.distance,
      required this.set,
      required this.interval});

  Game copy({int? id, String? name, int? distance, int? set, int? interval}) =>
      Game(
          id: id ?? this.id,
          name: name ?? this.name,
          distance: distance ?? this.distance,
          set: set ?? this.set,
          interval: interval ?? this.interval);

  static Game fromJson(Map<String, Object?> json) => Game(
      id: json[GameFields.id] as int?,
      name: json[GameFields.name] as String,
      distance: json[GameFields.distance] as int,
      set: json[GameFields.set] as int,
      interval: json[GameFields.interval] as int);

  Map<String, Object?> toJson() => {
        GameFields.id: id,
        GameFields.name: name,
        GameFields.distance: distance,
        GameFields.set: set,
        GameFields.interval: interval
      };
}
