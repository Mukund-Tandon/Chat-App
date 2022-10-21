import 'package:encrypt/encrypt.dart';
import 'package:whatsapp_clone/core/encryption/encryption.dart';

class EncryptionImpl implements Encryption {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(16);
  EncryptionImpl(this._encrypter);
  @override
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  @override
  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: _iv).base64;
  }
}
