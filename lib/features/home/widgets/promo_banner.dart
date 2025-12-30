import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.primaryYellow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Discover personalized home experiences!',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Arrow Icon
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.textPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppTheme.primaryYellow,
              ),
            ),
            const SizedBox(width: 8),
            // Close Icon
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.close,
                size: 20,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
