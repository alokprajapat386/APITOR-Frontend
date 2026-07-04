import 'dart:convert';
import 'package:apitor/analytics/data/login_response_dto.dart';
import 'package:apitor/analytics/data/password_change_request_dto.dart';
import 'package:apitor/analytics/data/user_details_dto.dart';
import 'package:apitor/analytics/data/user_update_request_dto.dart';
import 'package:apitor/analytics/service/api_client.dart';
import 'package:apitor/analytics/service/api_config.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';

class UserService {

  static Future<UserDetailsDTO> getProfile() async{
    String? token = await JwtTokenStorage.getToken();
    final response = await ApiClient.get(ApiConfiguration.userDetailsEndpoint, token: token);
     if(response.statusCode >= 200 && response.statusCode<300){
      return UserDetailsDTO.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<LoginResponseDTO> updateUserProfile(UserUpdateRequestDTO request) async{

    String? token= await JwtTokenStorage.getToken();
    final response = await ApiClient.put(ApiConfiguration.updateUserDetailsEndpoint, request.toJson(), token:token);
    if(response.statusCode >= 200 && response.statusCode<300){
      return LoginResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<bool> changePassword(PasswordChangeRequestDTO request) async{
    String ? token = await JwtTokenStorage.getToken();
    final response = await ApiClient.put(ApiConfiguration.changePasswordEndpoint,request.toJson(),token: token);
    if(response.statusCode >= 200 && response.statusCode<300){
      return true;
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }
}