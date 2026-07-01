import 'dart:async';
import 'dart:convert';
import 'package:apitor/analytics/data/login_response_dto.dart';
import 'package:apitor/analytics/service/api_client.dart';
import 'package:apitor/analytics/service/api_config.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';
import 'package:apitor/analytics/service/storage/user_profile_storage_service.dart';
import 'package:apitor/routing/router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleSignIn _signIn = GoogleSignIn.instance;



  static Future<void> initialize() async {

      final String configString = await rootBundle.loadString('assets/config.json');
      final Map<String, dynamic> configJson = jsonDecode(configString);
      final String? webClientId = configJson['GOOGLE_CLIENT_ID'];
    await _signIn.initialize(
      clientId: webClientId
    );

    _signIn.authenticationEvents
        .listen(_handleAuthenticationEvent)
        .onError(_handleAuthenticationError);

    // tries silent/auto sign-in if the user has a valid session already
    unawaited(_signIn.attemptLightweightAuthentication());
  }

  static void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    switch (event) {
      case GoogleSignInAuthenticationEventSignIn():
        final idToken = event.user.authentication.idToken;
        if (idToken != null) {
          sendTokenToBackend(idToken).then((loginResponse) {
            JwtTokenStorage.saveToken(loginResponse.token);
            UserProfileStorageService.saveProfile(loginResponse.userDetails);
          });

          router.go('/dashboard');
        }
        break;
      case GoogleSignInAuthenticationEventSignOut():
        break;
    }
  }

  static void _handleAuthenticationError(Object error) {

  }

  static Future<void> signInWithGoogle() async {
    if (!kIsWeb && _signIn.supportsAuthenticate()) {
      await _signIn.authenticate();
    }
  }

  static Future<LoginResponseDTO> sendTokenToBackend(String tokenId) async {
    final response = await ApiClient.post(
      ApiConfiguration.oAuth2GoogleEndpoint,
      {'tokenId': tokenId},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return LoginResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }
}