import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class AIRecommendationCard extends StatelessWidget {
  const AIRecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI recommendation',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'Strong Positive',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Recommendation Text
          Text(
            'In the last 24 hours, BNB sentiment is overwhelmingly bullish, fueled by strong community support, successful projects, and...',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          
          // Expand Icon
          Center(
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
