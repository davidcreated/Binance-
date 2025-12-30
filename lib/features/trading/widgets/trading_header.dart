import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class TradingHeader extends StatelessWidget {
  final String pair;
  final VoidCallback onBack;

  const TradingHeader({
    super.key,
    required this.pair,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back,
              color: AppTheme.darkTextPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // Pair Name with Dropdown
          Row(
            children: [
              Text(
                pair,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkTextPrimary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                color: AppTheme.darkTextPrimary,
                size: 24,
              ),
            ],
          ),
          
          const Spacer(),
          
          // AI Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: AppTheme.primaryYellow,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          
          // Star Icon
          const Icon(
            Icons.star,
            color: AppTheme.primaryYellow,
            size: 24,
          ),
          const SizedBox(width: 16),
          
          // Notification Icon
          const Icon(
            Icons.notifications_outlined,
            color: AppTheme.darkTextPrimary,
            size: 24,
          ),
        ],
      ),
    );
  }
}
