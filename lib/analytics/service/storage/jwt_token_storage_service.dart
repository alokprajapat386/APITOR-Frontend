import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtTokenStorage{
  static const storage=FlutterSecureStorage();
  static const tokenKey="jwt-token";

   static Future<void> saveToken(String token) async {
    await storage.write(key: tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: tokenKey);
  }

  static Future<void> clearToken() async {
    await storage.delete(key: tokenKey);
  }
  
}