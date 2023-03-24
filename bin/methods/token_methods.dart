import 'dart:convert';
import 'package:crypto/crypto.dart';

abstract class TokenMethods {
  String createJwt(
      String key, Map<String, dynamic> payload, Duration duration) {
    final headers = {'alg': 'HS256', 'typ': 'JWT'};

    final issuedAt = DateTime.now().millisecondsSinceEpoch;
    final expiration = issuedAt + duration.inMilliseconds;

    final Map<String, dynamic> claims = {
      'iat': issuedAt ~/ 1000,
      'exp': expiration ~/ 1000
    }..addAll(payload);

    final base64UrlHeaders =
        base64Url.encode(utf8.encode(json.encode(headers)));
    final base64UrlPayload = base64Url.encode(utf8.encode(json.encode(claims)));
    final signature =
        _generateSignature('$base64UrlHeaders.$base64UrlPayload', key);

    return '$base64UrlHeaders.$base64UrlPayload.$signature';
  }

  String _generateSignature(String input, String key) {
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(input));
    return base64Url.encode(digest.bytes);
  }
}
