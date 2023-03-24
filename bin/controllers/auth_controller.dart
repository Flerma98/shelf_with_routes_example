import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';

import 'properties/router_class_properties.dart';

class AuthController extends RouterClassProperties {
  Future<Response> login(Request request) async {
    try {
      final basicAuth = validateBasicAuth(request.headers["authorization"]);
      if (basicAuth == null) {
        return Response.unauthorized(
            json.encode({"error": "Invalid credentials"}));
      }

      return Response.ok(json.encode(
          {"username": basicAuth.username, "password": basicAuth.password}));
    } catch (error) {
      return Response.badRequest(
          body: json.encode({"error": error.toString()}));
    }
  }

  Future<Response> register(Request request) async {
    try {
      final requestBody = await request.readAsString();
      final itemJson = json.decode(requestBody);

      return Response.ok(json.encode(itemJson));
    } catch (error) {
      return Response.badRequest(
          body: json.encode({"error": error.toString()}));
    }
  }

  @override
  Router get router => Router()
    ..get("/login", login)
    ..post("/register", register);
}
