import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'controllers/auth_controller.dart';
import 'controllers/users_controller.dart';

const secretKey = "NlrKrZbHsxWvPyjbmTfXGlcSPgJQoIet";

void main(List<String> arguments) async {
  final databaseConnection = PostgreSQLConnection(
      'localhost', 5432, 'shelf_example',
      username: 'menonaxs', password: 'micontra');

  await databaseConnection.open();

  final controllers = Router()
    ..mount(
        '/users',
        UsersController(
                databaseConnection: databaseConnection, secretKey: secretKey)
            .router)
    ..mount(
        '/auth',
        AuthController(
                databaseConnection: databaseConnection, secretKey: secretKey)
            .router);

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(controllers);

  final server = await io.serve(handler, 'localhost', 8080);
  print('Server listening on ${server.address.host}:${server.port}');
}
