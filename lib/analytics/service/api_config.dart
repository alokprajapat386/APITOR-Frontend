import 'dart:convert';

import 'package:flutter/services.dart';

class ApiConfiguration{
  // * BASE URL

  static  String baseUrl = "_baseURL";
  static Future<void> loadConfiguration() async {
    try {
       final String configString = await rootBundle.loadString('assets/config.json');
      final Map<String, dynamic> configJson = jsonDecode(configString);
      final String? data = configJson['BACKEND_URL'];
      baseUrl = data ?? "http://localhost:8080";
    } catch (e) {
       baseUrl = "http://localhost:8080";
    }
  }  

  // authentication endpoints
  static const String loginEndpoint = "/auth/login";
  static const String registerEndpoint = "/auth/register";
  static const String oAuth2GoogleEndpoint = "/auth/google";
  static const String generatePasswordResetEndpoint = "/auth/reset-password/get-token";
  static const String verifyPasswordResetTokenEndpoint = "/auth/reset-password/verify";
  

  // user-service endpoints
  static const String userDetailsEndpoint = "/user";
  static const String updateUserDetailsEndpoint = "/user/update";
  static const String changePasswordEndpoint = "/user/change-password";

  // project-service endpoints
  static const String createProjectEndpoint = "/project/create";
  static const String getAllProjectsEndpoint = "/project/all";
  static String getProjectByIdEndpoint(int id)=> "/project/$id";

  // metrics-analytics endpoints
  static String getAnalyticsByProjectIdEndpoint(int projectId, {DateTime? startTime, DateTime? endTime, String? anlyticsTimeGranularity, String? timezone}){
      final Uri base = Uri.parse("/analytics/$projectId");
      final Map<String, String> queryParams = {};
      if (startTime != null)  queryParams['startTime'] = startTime.toUtc().toIso8601String();
      if (endTime != null)  queryParams['endTime'] = endTime.toUtc().toIso8601String();
      if (timezone!=null)  queryParams['timezone'] = timezone;
      if (anlyticsTimeGranularity != null)  queryParams['analyticsTimePeriod'] = anlyticsTimeGranularity;
      final Uri uri= base.replace(queryParameters: queryParams);

      return uri.toString();
  }

  static Uri getFullUri(String endpoint){
    return 
    Uri.parse(baseUrl + endpoint);
  }


}