import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';

class MiniLineChart extends StatelessWidget {
  final List<double> data;
  final bool isPositive;
  final double height;
  final double width;

  const MiniLineChart({
    super.key,
    required this.data,
    this.isPositive = true,
    this.height = 50,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppTheme.success : AppTheme.error;
    
    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: data.reduce((a, b) => a < b ? a : b) * 0.95,
          maxY: data.reduce((a, b) => a > b ? a : b) * 1.05,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: color,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
