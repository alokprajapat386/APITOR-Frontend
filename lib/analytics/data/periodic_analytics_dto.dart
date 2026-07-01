class PeriodicAnalyticsDTO {
  final String periodLabel;
  final int apiHitCount;
  final int uniqueIpCount;
  final double latencyAvg;
  final double latencyP50;
  final double latencyP99;
  final Map<String, int> statusCodeFrequencies;
  final Map<String, int> httpMethodFrequencies;
  final double avgPayloadSize;
  final int maxPayloadSize;

  PeriodicAnalyticsDTO({
    required this.periodLabel,
    required this.apiHitCount,
    required this.uniqueIpCount,
    required this.latencyAvg,
    required this.latencyP50,
    required this.latencyP99,
    required this.statusCodeFrequencies,
    required this.httpMethodFrequencies,
    required this.avgPayloadSize,
    required this.maxPayloadSize
  });

  factory PeriodicAnalyticsDTO.fromJson(Map<String, dynamic> json) {
    return PeriodicAnalyticsDTO(
      periodLabel: json['periodLabel'],
      apiHitCount: json['apiHitCount'],
      uniqueIpCount: json['uniqueIpCount'],
      latencyAvg: json['latencyAvg'],
      latencyP50: json['latencyP50'],
      latencyP99: json['latencyP99'],
      statusCodeFrequencies: Map<String, int>.from(json['statusCodesFrequencies']),
      httpMethodFrequencies: Map<String, int>.from(json['httpMethodFrequencies']),
      avgPayloadSize: json['avgPayloadSize'],
      maxPayloadSize: json['maxPayloadSize']
    );
  }
  
}