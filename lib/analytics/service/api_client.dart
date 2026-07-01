import 'dart:convert';

import 'package:apitor/analytics/service/api_config.dart';
import 'package:http/http.dart' as http;


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
      );

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
        );
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
    );
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
    );
  }
}