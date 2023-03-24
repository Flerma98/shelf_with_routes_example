import 'dart:convert';

import 'package:crypto/crypto.dart';

abstract class TokenMethods {
  String createJwt(
      {required final String secretKey,
      required final Map<String, dynamic> payload,
      final Duration? duration}) {
    final headers = {'alg': 'HS256', 'typ': 'JWT'};

    final issuedAt = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> claims = {'iat': issuedAt ~/ 1000}
      ..addAll(payload);

    if (duration != null) {
      final expiration = issuedAt + duration.inMilliseconds;
      claims['exp'] = expiration ~/ 1000;
    }

    final base64UrlHeaders =
        base64Url.encode(utf8.encode(json.encode(headers)));
    final base64UrlPayload = base64Url.encode(utf8.encode(json.encode(claims)));
    final signature = _generateSignature(
        input: '$base64UrlHeaders.$base64UrlPayload', secretKey: secretKey);

    return '$base64UrlHeaders.$base64UrlPayload.$signature';
  }

  String _generateSignature(
      {required final String input, required final String secretKey}) {
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(input));
    return base64Url.encode(digest.bytes);
  }
}
