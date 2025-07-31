import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignatureConstant {
  SignatureConstant._();

  /// Public / Private Key
  /// harus sesuai format, seperti new line,
  /// Prefix "-----BEGIN PUBLIC KEY-----",
  /// dan Suffix "-----END PUBLIC KEY-----"
  /// Contoh PUBLIC KEY untuk enkripsi, gantis sesuai kebutuhan
  static final String publicKey = dotenv.env['SIGN_PUBLIC_KEY']!;

  static final String privateKey = dotenv.env['SIGN_PRIVATE_KEY']!;
}
