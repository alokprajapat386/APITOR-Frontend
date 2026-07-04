import 'dart:async';
import 'dart:convert';

import 'package:apitor/analytics/data/login_request_dto.dart';
import 'package:apitor/analytics/data/login_response_dto.dart';
import 'package:apitor/analytics/data/password_reset_token_response_dto.dart';
import 'package:apitor/analytics/data/register_request_dto.dart';
import 'package:apitor/analytics/data/reset_password_request_dto.dart';
import 'package:apitor/analytics/data/reset_request_verification_dto.dart';
import 'package:apitor/analytics/service/api_client.dart';
import 'package:apitor/analytics/service/api_config.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';
import 'package:apitor/analytics/service/storage/user_profile_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {

  static Future<PasswordResetTokenResponseDTO> generatePasswordResetToken(
    ResetPasswordRequestDTO request,
  ) async {
    final response = await ApiClient.post(
      ApiConfiguration.generatePasswordResetEndpoint,
      request.toJson(),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PasswordResetTokenResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<void> verifyPasswordResetToken(
    ResetRequestVerificationDTO request,
  ) async {
    final response = await ApiClient.post(
      ApiConfiguration.verifyPasswordResetTokenEndpoint,
      request.toJson(),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<LoginResponseDTO> login(LoginRequestDTO request) async {
    final response =
        await ApiClient.post(ApiConfiguration.loginEndpoint, request.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return LoginResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<bool> register(RegisterRequestDTO request) async {
    final response =
        await ApiClient.post(ApiConfiguration.registerEndpoint, request.toJson());
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return true;
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<bool> isLoggedin() async{
    final token = await JwtTokenStorage.getToken();
    if(token==null || token.trim().isEmpty){
        return false;
    }else{
      try{
        if(!JwtDecoder.isExpired(token)){
          return true;
        }else{
          JwtTokenStorage.clearToken();
          UserProfileStorageService.clearProfile();
          return false;
        }
      }catch(e){
        return false;
      }
    }
  }
}
