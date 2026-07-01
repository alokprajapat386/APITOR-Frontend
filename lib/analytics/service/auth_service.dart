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
      throw Exception('Failed to generate token: ${response.body}');
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
      throw Exception('Failed to reset password: ${response.body}');
    }
  }

  static Future<LoginResponseDTO> login(LoginRequestDTO request) async {
    final response =
        await ApiClient.post(ApiConfiguration.loginEndpoint, request.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return LoginResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<bool> register(RegisterRequestDTO request) async {
    final response =
        await ApiClient.post(ApiConfiguration.registerEndpoint, request.toJson());
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return true;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }
}
