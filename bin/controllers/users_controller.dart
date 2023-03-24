import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';

import '../models/objects/user_model.dart';
import 'properties/router_class_properties.dart';

class UsersController extends RouterClassProperties {
  UsersController({required super.databaseConnection});

  Future<Response> getAllUsers(Request request) async {
    try {
      final token = getTokenOfBearerHeader(request.headers["authorization"]);
      if (token == null) {
        return Response.unauthorized(
            json.encode({"error": "Invalid credentials"}));
      }

      return Response.ok(json.encode(await UserViewModel.getListFromDatabase(
          databaseConnection)));
    } catch (error) {
      return Response.badRequest(
          body: json.encode({"error": error.toString()}));
    }
  }

  Future<Response> getSingleUser(Request request, String id) async {
    try {
      final token = getTokenOfBearerHeader(request.headers["authorization"]);
      if (token == null) {
        return Response.unauthorized(
            json.encode({"error": "Invalid credentials"}));
      }

      if (int.tryParse(id) == null) throw "Invalid ID";
      final userId = int.parse(id);

      return Response.ok(json.encode([
        {"id": userId}
      ]));
    } catch (error) {
      return Response.badRequest(
          body: json.encode({"error": error.toString()}));
    }
  }

  ///USERS ROUTES
  @override
  Router get router => Router()
    ..get("/", getAllUsers)
    ..get("/<id>", getSingleUser);
}
