import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StatusBar extends StatelessWidget {
  final bool isDark;

  const StatusBar({
    super.key,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ),
          // Right icons
          Row(
            children: [
              // Signal bars
              Icon(Icons.signal_cellular_4_bar, size: 16, color: textColor),
              const SizedBox(width: 4),
              // WiFi
              Icon(Icons.wifi, size: 16, color: textColor),
              const SizedBox(width: 4),
              // Battery
              Icon(Icons.battery_full, size: 20, color: textColor),
            ],
          ),
        ],
      ),
    );
  }
}
