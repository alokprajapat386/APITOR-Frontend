import 'dart:convert';
import 'package:apitor/analytics/data/metrics_analytics_dto.dart';
import 'package:apitor/analytics/service/api_client.dart';
import 'package:apitor/analytics/service/api_config.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';

class MetricsAnalyticsService {

  static Future<MetricsAnalyticsDTO> getAnalytics(int projectId, {DateTime? startTime, DateTime? endTime, String? analyticsTimeGranularity}) async{
    String? token =  await JwtTokenStorage.getToken();

    final response = await ApiClient.get(ApiConfiguration.getAnalyticsByProjectIdEndpoint(projectId, endTime:  endTime, startTime: startTime, anlyticsTimeGranularity:  analyticsTimeGranularity), token: token);
      if(response.statusCode >= 200 && response.statusCode<300){
      return MetricsAnalyticsDTO.fromJson(jsonDecode(response.body));
    } else {
     throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }
}