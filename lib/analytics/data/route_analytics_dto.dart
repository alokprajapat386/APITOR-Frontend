class RouteAnalyticsDTO{
  final String endpointPath;
  final int requestHits;
  final double latencyAvg;
  final double latencyP50;
  final double latencyP99;

  RouteAnalyticsDTO({
    required this.endpointPath,
    required this.requestHits,
    required this.latencyAvg,
    required this.latencyP50,
    required this.latencyP99
  });

  factory RouteAnalyticsDTO.fromJson(Map<String, dynamic> json) {
    return RouteAnalyticsDTO(
      endpointPath: json['endpointPath'],
      requestHits: json['requestHits'],
      latencyAvg: json['latencyAvg'],
      latencyP50: json['latencyP50'],
      latencyP99: json['latencyP99']
    );
  }
}