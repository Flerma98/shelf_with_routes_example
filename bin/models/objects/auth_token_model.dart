class AuthTokenModel {
  final int userId;
  final DateTime dateTimeCreated;

  AuthTokenModel({required this.userId, required this.dateTimeCreated});

  Map<String, dynamic> toJson() =>
      {"userId": userId, "dateTimeCreated": dateTimeCreated.toIso8601String()};

  static AuthTokenModel fromMapDecoded(final Map<String, dynamic> map) {
    return AuthTokenModel(
        userId: map["userId"],
        dateTimeCreated: DateTime.parse(map["dateTimeCreated"]));
  }
}
