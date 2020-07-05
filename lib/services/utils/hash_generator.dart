import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class HashGenerator {
  static String hmacGenerator(String value, String key) {
    var hmacKey = utf8.encode(key);
    var bytes = utf8.encode(value);

    var hmacSha256 = new Hmac(sha256, hmacKey); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  static String encrypt(String text, String eKey, String appender) {
    // appender should be 4 digit length
    final key = Key.fromUtf8("iFIN"+ eKey + appender);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String eText, String eKey, String appender) {
    // appender should be 4 digit length
    final key = Key.fromUtf8("iFIN"+ eKey + appender);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(eText, iv: iv);
    return decrypted;
  }
}
