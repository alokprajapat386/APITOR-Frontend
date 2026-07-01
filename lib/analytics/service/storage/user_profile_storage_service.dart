import 'dart:convert';

import 'package:apitor/analytics/data/user_details_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfileStorageService{
  static const storage=FlutterSecureStorage();
  static const profileKey="user-profile";

   static Future<void> saveProfile(UserDetailsDTO profile) async {
    await storage.write(key: profileKey, value: jsonEncode(profile.toJson()));
  }

  static Future<UserDetailsDTO?> fetchProfile() async {
    final String? profileString = await storage.read(key: profileKey);
    if(profileString == null) {
      return null;
    }
    else{
      return UserDetailsDTO.fromJson(jsonDecode(profileString));
    }
  }

  static Future<void> clearProfile() async {
    await storage.delete(key: profileKey);
  }
  
}