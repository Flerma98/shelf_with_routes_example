import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';

import '../models/enums/user_type.dart';
import '../models/objects/user_model.dart';
import 'properties/router_class_properties.dart';

class AuthController extends RouterClassProperties {
  AuthController({required super.databaseConnection});

  Future<Response> login(Request request) async {
    try {
      final basicAuth = validateBasicAuth(request.headers["authorization"]);

      if (basicAuth == null) {
        return Response.unauthorized(
            json.encode({"error": "Invalid credentials"}));
      }

      final user = await UserViewModel.getItemFromDatabase(databaseConnection);

      return Response.ok(json.encode(
          {"username": basicAuth.username, "password": basicAuth.password}));
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
