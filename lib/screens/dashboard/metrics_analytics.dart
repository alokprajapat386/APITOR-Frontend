import 'package:apitor/analytics/data/metrics_analytics_dto.dart';
import 'package:apitor/analytics/data/periodic_analytics_dto.dart';
import 'package:apitor/analytics/data/route_analytics_dto.dart';
import 'package:apitor/analytics/service/metrics_analytics_service.dart';
import 'package:apitor/components/analytics_date_filter.dart';
import 'package:apitor/screens/charts/dynamic_bar_chart.dart';
import 'package:apitor/screens/charts/dynamic_line_chart.dart';
import 'package:apitor/screens/dashboard/project_token_field.dart';
import 'package:flutter/material.dart';
import 'package:apitor/analytics/data/project_details_dto.dart';

class MetricsAnalyticsPage extends StatefulWidget {
  final ProjectDetailsDTO project;
  const MetricsAnalyticsPage({
    super.key,
    required this.project,
  });

  @override
  State<MetricsAnalyticsPage> createState() => _MetricsAnalyticsPageState();
}

class _MetricsAnalyticsPageState extends State<MetricsAnalyticsPage> {
  bool showPeriodicAnalytics = true;
  late Future<MetricsAnalyticsDTO> metricsFuture;


   DateTime startTime = DateTime.now();
   DateTime endTime = DateTime.now().subtract(Duration(days:7));
   TimeGranularity granularity= TimeGranularity.daily;

  @override
  void initState() {
    super.initState();
     endTime = DateTime.now();
     startTime = DateTime.now().subtract( Duration(days: 7));
     granularity = TimeGranularity.daily;
  
    metricsFuture = MetricsAnalyticsService.getAnalytics(widget.project.id, startTime: startTime, endTime: endTime, analyticsTimeGranularity: granularity.value);
  }

  void _refreshMetrics() {
    setState(() {
     metricsFuture = MetricsAnalyticsService.getAnalytics(widget.project.id, startTime: startTime, endTime: endTime, analyticsTimeGranularity: granularity.value);

    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.analytics_outlined,
                        color: theme.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'API Analytics',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.project.projectName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[200]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectDetailRow(
                        'Project ID',
                        widget.project.id.toString(),
                      ),
                      const SizedBox(height: 8),
                      _buildProjectDetailRow(
                        'Target URL',
                        widget.project.targetURL,
                      ),
                      const SizedBox(height: 8),
                      _buildTokenDetailRow(widget.project.projectToken),
                      const SizedBox(height: 8),
                      _buildProjectDetailRow(
                        'Created At',
                        widget.project.createdAt.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          AnalyticsFilterCard(
            onFiltersChanged: ( startTime,  endTime,  granularity){
                setState((){
                  startTime=startTime;
                  endTime=endTime;
                  granularity=granularity;
                  metricsFuture=MetricsAnalyticsService.getAnalytics(widget.project.id, startTime: startTime, endTime: endTime, analyticsTimeGranularity: granularity.value);
                });
            },
          ),
          SizedBox(height: 10,),
          _buildToggleSwitch(theme),
          FutureBuilder<MetricsAnalyticsDTO>(
            future: metricsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to fetch analytics',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _refreshMetrics,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry Fetching'),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasData) {
                final metricsData = snapshot.data!;

                return showPeriodicAnalytics
                    ? _buildPeriodicAnalyticsView(theme, metricsData)
                    : _buildRouteAnalyticsView(theme, metricsData);
              }

              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text('No data found'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTokenDetailRow(String token) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Token: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: ProjectTokenField(token: token),
        ),
      ],
    );
  }

  Widget _buildProjectDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(ThemeData theme) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20),
    
    child: Align(
      alignment: Alignment.centerLeft, 
      child: SegmentedButton<bool>(
        style: ButtonStyle(
          visualDensity: VisualDensity.comfortable,
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.primaryColor;
            }
            return Colors.grey[100];
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.grey[700];
          }),
          side: WidgetStateProperty.all(
            BorderSide(color: theme.primaryColor.withValues(alpha: 0.2)),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
        ),
        selected: {showPeriodicAnalytics},
        onSelectionChanged: (Set<bool> newSelection) {
          setState(() {
            showPeriodicAnalytics = newSelection.first;
          });
        },
        showSelectedIcon: false, 
        segments: const <ButtonSegment<bool>>[
          ButtonSegment<bool>(
            value: true,
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'Periodic Analytics',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          ButtonSegment<bool>(
            value: false,
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'Route Analytics',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildPeriodicAnalyticsView(
    ThemeData theme,
    MetricsAnalyticsDTO data,
  ) {
    if (data.periodicAnalytics.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Text(
          'No periodic analytics data yet',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final periods = data.periodicAnalytics;
    final periodicLineData = _toPeriodicLineData(periods);
    final httpMethodData = _toMapFrequencyBarData(
      periods,
      (period) => period.httpMethodFrequencies,
    );


    final statusCodeData = _toMapFrequencyBarData(
      periods,
      (period) => period.statusCodeFrequencies,
    );

    final statusCodeKeys = _extractMapKeys(statusCodeData, 'periodLabel');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ChartCard(
                title: 'API Hits',
                legendLabels: const ['API Hits'],
                legendColors: [Colors.purple.shade400],
                chart: DynamicLineChart(
                  dataList: periodicLineData,
                  xAxisKey: 'periodLabel',
                  dataKeys: const ['apiHitCount'],
                  lineColors: [Colors.purple.shade400],
                  chartHeight: 240,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChartCard(
                title: 'Unique IPs',
                legendLabels: const ['Unique IPs'],
                legendColors: const [Color(0xFF10B981)],
                chart: DynamicLineChart(
                  dataList: periodicLineData,
                  xAxisKey: 'periodLabel',
                  dataKeys: const ['uniqueIpCount'],
                  lineColors: const [Color(0xFF10B981)],
                  chartHeight: 240,
                ),
              ),
            ),
          ],
        ),
        ChartCard(
          title: 'HTTP Methods',
          legendLabels:  ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
          legendColors: [ Colors.green.shade400, Colors.orange.shade300, Colors.blue.shade400, Colors.red.shade400, Colors.purple.shade400],
          chart: DynamicBarChart(
            dataList: httpMethodData,
            xAxisKey: 'periodLabel',
            dataKeys: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
            barColors:[ Colors.green.shade400, Colors.orange.shade300, Colors.blue.shade400, Colors.red.shade400, Colors.purple.shade400],
            chartHeight: 280,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ChartCard(
                title: 'Latency (ms)',
                legendLabels: const ['Avg', 'P50', 'P99'],
                legendColors:  [
                  Colors.green.shade400,
                  Colors.orange.shade400,
                  Colors.red.shade400,
                ],
                chart: DynamicLineChart(
                  dataList: periodicLineData,
                  xAxisKey: 'periodLabel',
                  dataKeys: const ['latencyAvg', 'latencyP50', 'latencyP99'],
                  lineColors: [
                    Colors.green.shade400,
                    Colors.orange.shade400,
                    Colors.red.shade400,
                  ],
                  chartHeight: 240,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChartCard(
                title: 'Payload Size (bytes)',
                legendLabels: const ['Avg', 'Max'],
                legendColors:  [
                  Colors.green.shade400,
                  Colors.red.shade400,
                ],
                chart: DynamicLineChart(
                  dataList: periodicLineData,
                  xAxisKey: 'periodLabel',
                  dataKeys: const ['avgPayloadSize', 'maxPayloadSize'],
                  lineColors: [
                    Colors.green.shade400,
                    Colors.red.shade400,
                  ],
                  chartHeight: 240,
                ),
              ),
            ),
          ],
        ),
        ChartCard(
          title: 'Status Codes',
          legendLabels: statusCodeKeys,
          legendColors:  [
              Colors.green.shade400,
              Colors.teal.shade400,
              Colors.yellow.shade400,
              Colors.orange.shade400,
              Colors.red.shade400,
              Colors.pink.shade400,
              Colors.purple.shade400
            ],
          chart: DynamicBarChart(
            dataList: statusCodeData,
            xAxisKey: 'periodLabel',
            dataKeys: ['200', '201', '400', '401', '403', '404', '500'],
            barColors: [
              Colors.green.shade400,
              Colors.teal.shade400,
              Colors.yellow.shade400,
              Colors.orange.shade400,
              Colors.red.shade400,
              Colors.pink.shade400,
              Colors.purple.shade400
            ],
            chartHeight: 280,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteAnalyticsView(
    ThemeData theme,
    MetricsAnalyticsDTO data,
  ) {
    if (data.routeAnalytics.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Text(
          'No route analytics data yet',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final routes = data.routeAnalytics;
    final routeLineData = _toRouteLineData(routes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartCard(
          title: 'Request Hits',
          legendLabels: const ['Request Hits'],
          legendColors: [Colors.purple.shade400],
          chart: DynamicBarChart(
            dataList: routeLineData,
            xAxisKey: 'endpointPath',
            dataKeys: const ['requestHits'],
            barColors: [Colors.purple.shade400],
            chartHeight: 280,
            angle: -0.15, 
          ),
        ),
        ChartCard(
          title: 'Latency (ms)',
          legendLabels: const ['Avg', 'P50', 'P99'],
          legendColors:  [
            Colors.green.shade400,
            Colors.orange.shade400,
            Colors.red.shade400,
          ],
          chart: DynamicBarChart(
            dataList: routeLineData,
            xAxisKey: 'endpointPath',
            dataKeys: const ['latencyAvg', 'latencyP50', 'latencyP99'],
            barColors:  [
            Colors.green.shade400,
            Colors.orange.shade400,
            Colors.red.shade400,
          ],
            chartHeight: 280,
            angle: -0.15,
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _toPeriodicLineData(
    List<PeriodicAnalyticsDTO> periods,
  ) {
    return periods
        .map(
          (period) => {
            'periodLabel': period.periodLabel,
            'apiHitCount': period.apiHitCount,
            'uniqueIpCount': period.uniqueIpCount,
            'latencyAvg': period.latencyAvg,
            'latencyP50': period.latencyP50,
            'latencyP99': period.latencyP99,
            'avgPayloadSize': period.avgPayloadSize,
            'maxPayloadSize': period.maxPayloadSize,
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> _toRouteLineData(
    List<RouteAnalyticsDTO> routes,
  ) {
    return routes
        .map(
          (route) => {
            'endpointPath': route.endpointPath,
            'requestHits': route.requestHits,
            'latencyAvg': route.latencyAvg,
            'latencyP50': route.latencyP50,
            'latencyP99': route.latencyP99,
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> _toMapFrequencyBarData(
    List<PeriodicAnalyticsDTO> periods,
    Map<String, int> Function(PeriodicAnalyticsDTO) frequencySelector,
  ) {
    final keys = <String>{};
    for (final period in periods) {
      keys.addAll(frequencySelector(period).keys);
    }
    final sortedKeys = keys.toList()..sort();

    return periods.map((period) {
      final frequencies = frequencySelector(period);
      final row = <String, dynamic>{'periodLabel': period.periodLabel};
      for (final key in sortedKeys) {
        row[key] = frequencies[key] ?? 0;
      }
      return row;
    }).toList();
  }

  List<String> _extractMapKeys(
    List<Map<String, dynamic>> dataList,
    String xAxisKey,
  ) {
    if (dataList.isEmpty) return [];
    return dataList.first.keys.where((key) => key != xAxisKey).toList();
  }

 

}

class ChartCard extends StatefulWidget {
  
  final String title;
  final Widget chart;
  final List<String> legendLabels;
  final List<Color> legendColors;
  final Color backgroundColor;

  const ChartCard({
    super.key,
    required this.title,
    required this.chart,
    required this.legendLabels,
    required this.legendColors,
    this.backgroundColor=Colors.white
  });

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
     return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(left:16, right:24, bottom: 16, top:16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.legendLabels.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: List.generate(widget.legendLabels.length, (index) {
                final color = widget.legendColors[index % widget.legendColors.length];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.legendLabels[index],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
          const SizedBox(height: 12),
          widget.chart,
        ],
      ),
    );

  }
}

