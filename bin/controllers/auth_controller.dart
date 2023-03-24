import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';

import '../models/enums/user_type.dart';
import '../models/objects/auth_token_model.dart';
import '../models/objects/user_model.dart';
import '../models/postgres_properties/where_sql_helper.dart';
import 'properties/router_class_properties.dart';

class AuthController extends RouterClassProperties {
  AuthController({required super.databaseConnection, required super.secretKey});

  Future<Response> login(Request request) async {
    try {
      final basicAuth = validateBasicAuth(request.headers["authorization"]);

      if (basicAuth == null) {
        return Response.unauthorized(
            json.encode({"error": "Invalid credentials"}));
      }

      final user = await UserViewModel.getItemFromDatabase(databaseConnection,
          where: WhereSqlHelper([
            "${UsersSqlTable.username} = @${UsersSqlTable.username}",
            "${UsersSqlTable.password} = ${UsersSqlTable.whereConditionForPassword("@${UsersSqlTable.password}")}"
          ], clausesValues: [
            WhereValuesHelper(
                parameterName: UsersSqlTable.username,
                value: basicAuth.username),
            WhereValuesHelper(
                parameterName: UsersSqlTable.password,
                value: basicAuth.password)
          ]));

      if (user == null) {
        return Response.notFound(json.encode({"error": "user not found"}));
      }

      final dateTimeCreated = DateTime.now().toUtc();
      const duration = Duration(minutes: 30);

      final token = createJwt(
          secretKey,
          AuthTokenRegisterModel(
                  userId: user.id, dateTimeCreated: dateTimeCreated)
              .toJson(),
          duration);

      return Response.ok(json.encode({"token": token, "user": user.toJson()}));
    } catch (error) {
      return Response.badRequest(
          body: json.encode({"error": error.toString()}));
    }
  }

  Future<Response> register(Request request) async {
    try {
      final requestBody = await request.readAsString().then(json.decode);
      final userRegisterItem = UserRegisterModel.fromMapServer(requestBody);
      final userRegistered = await userRegisterItem.saveInDatabase(
          databaseConnection: databaseConnection, userType: UserType.admin);
      return Response.ok(json.encode(userRegistered.toJson()));
    } catch (error) {
      return Response.badRequest(
          body: json.encode({"error": error.toString()}));
    }
  }

  ///AUTH ROUTES
  @override
  Router get router => Router()
    ..get("/login", login)
    ..post("/register", register);
}
