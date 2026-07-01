
import 'package:apitor/analytics/data/periodic_analytics_dto.dart';
import 'package:apitor/analytics/data/route_analytics_dto.dart';

class MetricsAnalyticsDTO{
  List<PeriodicAnalyticsDTO> periodicAnalytics;
  List<RouteAnalyticsDTO> routeAnalytics;

  MetricsAnalyticsDTO({
    required this.periodicAnalytics,
    required this.routeAnalytics
  });

  factory MetricsAnalyticsDTO.fromJson(Map<String, dynamic> json) {
    return MetricsAnalyticsDTO(
      periodicAnalytics: (json['periodicAnalytics'] as List)
          .map((item) => PeriodicAnalyticsDTO.fromJson(item))
          .toList(),
      routeAnalytics: (json['routeAnalytics'] as List)
          .map((item) => RouteAnalyticsDTO.fromJson(item))
          .toList(),
    );
  }
}