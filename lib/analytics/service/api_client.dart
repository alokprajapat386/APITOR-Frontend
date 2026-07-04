import 'dart:convert';

import 'package:apitor/analytics/service/api_config.dart';
import 'package:http/http.dart' as http;

class HttpException implements Exception{
  final int statusCode;
  final String message;

  HttpException({required this.statusCode, required this.message});

  @override
  String toString(){
    return 'Http Exception [$statusCode]: $message';
  }
}


class ApiClient {
  static Future<http.Response> get(String endpoint, {String? token}) async {
      final headers = {
        "Content-Type": "application/json",
      };

      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }

    
      final response = await http.get(
        ApiConfiguration.getFullUri(endpoint),
        headers: headers,
      ).timeout(const Duration(seconds: 12));

      return response;

  
  
  }

  static Future<http.Response> put(String endpoint,
      Map<String, dynamic> body,
      {String? token}) async {

        final headers = {
        "Content-Type": "application/json",
      };

      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
        return await http.put(
          ApiConfiguration.getFullUri(endpoint),
          headers: headers,
          body: jsonEncode(body),
        ).timeout(const Duration(seconds: 12));
      }

  static Future<http.Response> post(String endpoint,
      Map<String, dynamic> body,
      {String? token}) async {
      
      final headers = {
        "Content-Type": "application/json",
      };

      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }

    return await http.post(
      ApiConfiguration.getFullUri(endpoint),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 12));
  }

  static Future<http.Response> delete(String endpoint, {String? token}) async {
    final headers = {
      "Content-Type": "application/json",
    };

    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return await http.delete(
      ApiConfiguration.getFullUri(endpoint),
      headers: headers,
    ).timeout(const Duration(seconds: 12));
  }
}