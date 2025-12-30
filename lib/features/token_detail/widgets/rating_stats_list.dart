import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class RatingStatsList extends StatelessWidget {
  const RatingStatsList({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Ranking', 'value': 'No. 1', 'valueColor': AppTheme.textPrimary},
      {'label': 'Social Volume', 'value': '26591', 'valueColor': AppTheme.textPrimary},
      {'label': 'News', 'value': 'Bullish', 'valueColor': AppTheme.textPrimary},
      {'label': 'Social Sentiment', 'value': 'Bullish', 'valueColor': AppTheme.textPrimary},
      {'label': 'KOL', 'value': 'Neutral', 'valueColor': AppTheme.textPrimary},
    ];

    return Column(
      children: stats.map((stat) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    stat['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Dotted line
                  SizedBox(
                    width: 80,
                    child: CustomPaint(
                      painter: DottedLinePainter(),
                    ),
                  ),
                ],
              ),
              Text(
                stat['value'] as String,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: stat['valueColor'] as Color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.borderLight
      ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
