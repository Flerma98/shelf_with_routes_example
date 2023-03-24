import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../methods/token_methods.dart';
import '../../models/objects/basic_auth_model.dart';

class RouterClassProperties extends TokenMethods {
  RouterClassProperties(
      {required this.databaseConnection, required this.secretKey});

  PostgreSQLConnection databaseConnection;

  String secretKey;

  late Router router;

  BasicAuthModel? validateBasicAuth(final String? authorizationHeader) {
    if (authorizationHeader == null ||
        !authorizationHeader.startsWith('Basic ')) {
      return null;
    }

    final base64Credentials =
        authorizationHeader.substring('Basic '.length).trim();
    final credentials = utf8.decode(base64.decode(base64Credentials));
    final tokens = credentials.split(':');
    final receivedUsername = tokens[0];
    final receivedPassword = tokens[1];

    return BasicAuthModel(
        username: receivedUsername, password: receivedPassword);
  }

  String? getTokenOfBearerHeader(final String? authorizationHeader) {
    if (authorizationHeader == null ||
        !authorizationHeader.startsWith('Bearer ')) {
      return null;
    }

    return authorizationHeader.substring('Bearer '.length).trim();
  }
}
