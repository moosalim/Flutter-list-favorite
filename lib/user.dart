class User {
  final String name;
  User(this.name);
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'];
}