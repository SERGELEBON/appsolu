
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionHelper {
  final _secureStorage = const FlutterSecureStorage();


  Future<encrypt.Encrypter> _getEncrypter() async {
    final keyString = await _secureStorage.read(key: 'encryption_key');
    final key = encrypt.Key.fromUtf8(keyString!);
    return encrypt.Encrypter(encrypt.AES(key));
  }

  Future<void> generateKey() async {
    final key = encrypt.Key.fromSecureRandom(32);
    await _secureStorage.write(key: 'encryption_key', value: key.base64);
  }

  Future<String> encryptText(String plainText) async {
    final encrypter = await _getEncrypter();
    final iv = encrypt.IV.fromLength(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  Future<String> decryptText(String encryptedText) async {
    final encrypter = await _getEncrypter();
    final iv = encrypt.IV.fromLength(16);
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
