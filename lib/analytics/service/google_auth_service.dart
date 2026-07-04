import 'dart:async';
import 'dart:convert';
import 'package:apitor/analytics/data/login_response_dto.dart';
import 'package:apitor/analytics/service/api_client.dart';
import 'package:apitor/analytics/service/api_config.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';
import 'package:apitor/analytics/service/storage/user_profile_storage_service.dart';
import 'package:apitor/components/custom_snack_bar.dart';
import 'package:apitor/routing/global_scaffold_messenger_key.dart';
import 'package:apitor/routing/router.dart';
import 'package:apitor/routing/user_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleSignIn _signIn = GoogleSignIn.instance;

  static void Function(bool isLoading)? onLoadingChanged;


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
    // unawaited(_signIn.attemptLightweightAuthentication());
  }

  static void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) async {
    switch (event)  {
      case GoogleSignInAuthenticationEventSignIn():
        final idToken = event.user.authentication.idToken;
        if (idToken != null) {
          try{ 
            onLoadingChanged?.call(true);
            final loginResponse = await sendTokenToBackend(idToken);
            await JwtTokenStorage.saveToken(loginResponse.token);
            await UserProfileStorageService.saveProfile(loginResponse.userDetails);
            UserSession.instance.setUser(loginResponse.userDetails);
            scaffoldMessengerKey.currentState?.showSnackBar(
              CustomSnackBar.success('Signed In Sucessfully', 'Verified credentials with google')
            );
            router.go('/dashboard');
          }catch(e){
            scaffoldMessengerKey.currentState?.showSnackBar(
              CustomSnackBar.error('Failed To Login', e)
            );
          }finally{
            onLoadingChanged?.call(false);
          }
        }
        break;
      case GoogleSignInAuthenticationEventSignOut():
        break;
    }
  }

  static void _handleAuthenticationError(Object e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        CustomSnackBar.error('Failed To Authenticate', e)
      );
  }

  static Future<void> signInWithGoogle() async {
    if (!kIsWeb && _signIn.supportsAuthenticate()) {
      await _signIn.authenticate();
    }
  }

  static Future<LoginResponseDTO> sendTokenToBackend(String tokenId) async {
    final response = await ApiClient.post(
      ApiConfiguration.oAuth2GoogleEndpoint,
      {'tokenId':tokenId},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return LoginResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }
}