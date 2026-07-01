import 'package:web/web.dart' as web; 

class PasswordResetTokenStorageService {
  static void saveTempToken(String token) {
    web.window.sessionStorage.setItem('reset_token', token);
  }

  static String? getTempToken() {
    return web.window.sessionStorage.getItem('reset_token');
  }

  static void clearToken() {
    web.window.sessionStorage.removeItem('reset_token');
  }
}