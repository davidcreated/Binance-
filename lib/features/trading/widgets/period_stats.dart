import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class PeriodStats extends StatelessWidget {
  const PeriodStats({super.key});

  @override
  Widget build(BuildContext context) {
    final periods = [
      {'label': 'Today', 'value': '0.87%', 'isPositive': true},
      {'label': '7 Days', 'value': '8.66%', 'isPositive': true},
      {'label': '30 Days', 'value': '10.40%', 'isPositive': true},
      {'label': '90 Days', 'value': '12.68%', 'isPositive': true},
      {'label': '180 Days', 'value': '55.93%', 'isPositive': true},
      {'label': '1 Year', 'value': '93.08%', 'isPositive': true},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: periods.map((period) {
          return Column(
            children: [
              Text(
                period['label'] as String,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                period['value'] as String,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: (period['isPositive'] as bool) 
                    ? AppTheme.success 
                    : AppTheme.error,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
