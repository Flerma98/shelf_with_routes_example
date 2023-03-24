class AuthTokenRegisterModel {
  final int userId;
  final DateTime dateTimeCreated;

  AuthTokenRegisterModel({required this.userId, required this.dateTimeCreated});

  Map<String, dynamic> toJson() =>
      {"userId": userId, "dateTimeCreated": dateTimeCreated.toIso8601String()};
}

class AuthTokenModel extends AuthTokenRegisterModel {
  final DateTime? dateTimeExpiration;

  AuthTokenModel(
      {required super.userId,
      required super.dateTimeCreated,
      this.dateTimeExpiration});

  @override
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "dateTimeCreated": dateTimeCreated.toIso8601String(),
        "dateTimeExpiration": dateTimeExpiration?.toIso8601String()
      };
}
