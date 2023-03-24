import 'package:postgres/postgres.dart';

import '../enums/user_type.dart';
import '../postgres_properties/where_sql_helper.dart';
import 'properties/database_properties.dart';

abstract class UsersSqlTable {
  static String tableName = "users";
  static String id = "id";
  static String username = "username";
  static String password = "password";
  static String isEnabled = "is_enabled";
  static String dateTimeCreated = "date_time_created";
  static String userType = "user_type";

  static String whereConditionForPassword(final String passwordToValidate) {
    return "crypt($passwordToValidate, password)";
  }
}

class UserBasicModel {
  final String username;

  UserBasicModel({required this.username});
}

class UserRegisterModel extends UserBasicModel {
  final String password;

  UserRegisterModel({required super.username, required this.password});

  static UserRegisterModel fromMapServer(final Map<String, dynamic> map) {
    return UserRegisterModel(
        username: map["username"], password: map["password"]);
  }

  Future<UserViewModel> saveInDatabase(
      {required final PostgreSQLConnection databaseConnection,
      required final UserType userType}) async {
    final dateTimeCreated = DateTime.now().toUtc();
    final result = await databaseConnection.query(
        "INSERT INTO ${UsersSqlTable.tableName} "
        "(${UsersSqlTable.username}, "
        "${UsersSqlTable.password}, "
        "${UsersSqlTable.dateTimeCreated}, "
        "${UsersSqlTable.userType}) "
        "VALUES "
        "(@${UsersSqlTable.username}, "
        "crypt(@${UsersSqlTable.password}, gen_salt('bf')), "
        "@${UsersSqlTable.dateTimeCreated}, "
        "@${UsersSqlTable.userType})"
        "RETURNING ${UsersSqlTable.id};",
        substitutionValues: {
          UsersSqlTable.username: username,
          UsersSqlTable.password: password,
          UsersSqlTable.dateTimeCreated: dateTimeCreated.toIso8601String(),
          UsersSqlTable.userType: userType.index
        });

    return UserViewModel(
        id: result[0][0],
        username: username,
        userType: userType,
        isEnabled: true,
        dateTimeCreated: dateTimeCreated);
  }
}

class UserViewModel extends UserBasicModel {
  final int id;
  final UserType userType;
  final bool isEnabled;
  final DateTime dateTimeCreated;

  UserViewModel(
      {required this.id,
      required super.username,
      required this.userType,
      required this.isEnabled,
      required this.dateTimeCreated});

  Map<String, dynamic> toJson() => {
        UsersSqlTable.id: id,
        UsersSqlTable.username: username,
        UsersSqlTable.userType: userType.index,
        UsersSqlTable.isEnabled: isEnabled,
        UsersSqlTable.dateTimeCreated: dateTimeCreated.toIso8601String()
      };

  static Future<UserViewModel> fromMapDatabase(
      final Map<String, dynamic> map) async {
    return UserViewModel(
        id: map[UsersSqlTable.id],
        username: map[UsersSqlTable.username],
        userType: UserType.values[map[UsersSqlTable.userType]],
        isEnabled: map[UsersSqlTable.isEnabled] == true,
        dateTimeCreated: map[UsersSqlTable.dateTimeCreated]);
  }

  static Future<List<UserViewModel>> getListFromDatabase(
      final PostgreSQLConnection databaseConnection,
      {final WhereSqlHelper? where,
      final OrderBy? orderBy,
      final String? groupBy,
      final String? having,
      final int? limit,
      final int? offset}) async {
    final Map<String, dynamic> substitutionValues = {};
    if (where?.values().isNotEmpty == true) {
      substitutionValues.addAll(where!.values());
    }

    final results = await databaseConnection.query(
        DatabaseProperties.makeQuery(UsersSqlTable.tableName,
            where: where,
            orderBy: orderBy,
            groupBy: groupBy,
            having: having,
            limit: limit,
            offset: offset),
        substitutionValues:
            (substitutionValues.isEmpty) ? null : substitutionValues);

    final List<UserViewModel> list = [];
    for (dynamic itemMap in results) {
      list.add(await fromMapDatabase(itemMap.toColumnMap()));
    }

    return list;
  }

  static Future<UserViewModel?> getItemFromDatabase(
      final PostgreSQLConnection databaseConnection,
      {final WhereSqlHelper? where,
      final OrderBy? orderBy,
      final String? groupBy,
      final String? having,
      final int? offset}) async {
    final Map<String, dynamic> substitutionValues = {};
    if (where?.values().isNotEmpty == true) {
      substitutionValues.addAll(where!.values());
    }

    print(DatabaseProperties.makeQuery(UsersSqlTable.tableName,
        where: where,
        orderBy: orderBy,
        groupBy: groupBy,
        having: having,
        offset: offset));

    final results = await databaseConnection.query(
        DatabaseProperties.makeQuery(UsersSqlTable.tableName,
            where: where,
            orderBy: orderBy,
            groupBy: groupBy,
            having: having,
            offset: offset),
        substitutionValues: substitutionValues);
    if (results.isEmpty) return null;
    return await fromMapDatabase(results.first.toColumnMap());
  }
}
