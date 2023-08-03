const String tableUser = 'users';

class UserFields {
  static final List<String> values = [id, name, age];

  static const String id = 'user_id';
  static const String name = 'user_name';
  static const String age = 'user_age';
}

class User {
  final int? id;
  final String name;
  final int age;

  User({this.id, required this.name, required this.age});

  User copy({int? id, String? name, int? age}) =>
      User(id: id ?? this.id, name: name ?? this.name, age: age ?? this.age);

  static User fromJson(Map<String, Object?> json) => User(
      id: json[UserFields.id] as int?,
      name: json[UserFields.name] as String,
      age: json[UserFields.age] as int);

  Map<String, Object?> toJson() =>
      {UserFields.id: id, UserFields.name: name, UserFields.age: age};
}
