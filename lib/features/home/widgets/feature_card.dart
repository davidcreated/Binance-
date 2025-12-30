import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? child;
  final bool showArrow;

  const FeatureCard({
    super.key,
    required this.title,
    this.subtitle,
    this.child,
    this.showArrow = false,
  });

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
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              if (showArrow)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppTheme.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Content
          if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
