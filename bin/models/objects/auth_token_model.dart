class AuthTokenModel {
  final int userId;
  final DateTime dateTimeCreated;
  final DateTime? dateTimeExpiration;

  AuthTokenModel(
      {required this.userId,
      required this.dateTimeCreated,
      required this.dateTimeExpiration});
}
