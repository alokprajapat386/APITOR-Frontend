import 'dart:convert';
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
      throw Exception("Failed to fetch user profile: ${response.body}");
    }
  }

  static Future<UserDetailsDTO> updateUserProfile(UserUpdateRequestDTO request) async{

    String? token= await JwtTokenStorage.getToken();
    final response = await ApiClient.put(ApiConfiguration.updateUserDetailsEndpoint, request.toJson(), token:token);
    if(response.statusCode >= 200 && response.statusCode<300){
      return UserDetailsDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update user profile: ${response.body}");
    }
  }

  static Future<bool> changePassword(PasswordChangeRequestDTO request) async{
    String ? token = await JwtTokenStorage.getToken();
    final response = await ApiClient.put(ApiConfiguration.changePasswordEndpoint,request.toJson(),token: token);
    if(response.statusCode >= 200 && response.statusCode<300){
      return true;
    } else {
      throw Exception("Failed to change Password: ${response.body}");
    }
  }
}