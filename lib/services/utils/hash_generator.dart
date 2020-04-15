import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashGenerator {
  static String hmacGenerator(String value, String key) {
    var hmacKey = utf8.encode(key);
    var bytes = utf8.encode(value);

    var hmacSha256 = new Hmac(sha256, hmacKey); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }
}
