import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
enum TimeGranularity {
   daily('DAILY'), 
   weekly('WEEKLY');

   const TimeGranularity( this.value);
   final String value;
   
}

class AnalyticsFilterCard extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate, TimeGranularity granularity) onFiltersChanged;

  const AnalyticsFilterCard({
    super.key,
    required this.onFiltersChanged,
  });

  @override
  State<AnalyticsFilterCard> createState() => _AnalyticsFilterCardState();
}

class _AnalyticsFilterCardState extends State<AnalyticsFilterCard> {
  TimeGranularity _selectedGranularity = TimeGranularity.daily;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  void _triggerCallback() {
    widget.onFiltersChanged(_startDate, _endDate, _selectedGranularity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    

    return Card(
      elevation: 2, 
      shadowColor: theme.shadowColor.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal:12,vertical: 4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[200]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          mainAxisSize: MainAxisSize.min, 
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.start,
                children: [
                  InkWell(
                    
                    onTap: () async {
                      final DateTimeRange? picked = await showDialog<DateTimeRange>(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            clipBehavior: Clip.antiAlias,
                
                            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40), 
                            child: Container(
                              width: 600, 
                              height: 500, 
                              color: theme.cardColor,
                              child: DateRangePickerDialog(
                                firstDate: DateTime.now().subtract(const Duration(days: 90)),
                                lastDate: DateTime.now(),
                                initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                              ),
                            ),
                          );
                        },
                      );
                
                      if (picked != null) {
                        setState(() {
                          _startDate = picked.start;
                          _endDate = picked.end;
                        });
                        _triggerCallback();
                      }
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.hintColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 16, color: theme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            '${_dateFormat.format(_startDate)}  to  ${_dateFormat.format(_endDate)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, size: 16),
                        ],
                      ),
                    ),
                  ),
              
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    
                    children: [
                      Text(
                        'Interval: ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: theme.hintColor),
                      ),
                      const SizedBox(width: 6),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        
                        onPressed: (int index) {
                          setState(() {
                            _selectedGranularity = TimeGranularity.values[index];
                          });
                          _triggerCallback();
                        },
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        borderRadius: BorderRadius.circular(999),
                        selectedBorderColor: theme.primaryColor,
                        selectedColor: Colors.white,
                        fillColor: theme.primaryColor,
                        color: theme.hintColor,
                        constraints: const BoxConstraints(minHeight: 32.0, minWidth: 62.0),
                        isSelected: TimeGranularity.values.map((g) => g == _selectedGranularity).toList(),
                        children: TimeGranularity.values.map((g) {
                          return Text(
                            g.name.toUpperCase(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}