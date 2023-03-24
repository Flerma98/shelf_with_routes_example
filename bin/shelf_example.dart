import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'controllers/auth_controller.dart';
import 'controllers/users_controller.dart';

void main(List<String> arguments) async {
  final controllers = Router()
    ..mount('/users', UsersController().router)
    ..mount('/auth', AuthController().router);

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(controllers);

  final server = await io.serve(handler, 'localhost', 8080);
  print('Server listening on ${server.address.host}:${server.port}');
}
