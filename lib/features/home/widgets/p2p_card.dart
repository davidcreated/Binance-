import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/crypto_icon.dart';

class P2PCard extends StatelessWidget {
  const P2PCard({super.key});

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
                'P2P',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // USDT/USD Row
          Row(
            children: [
              CryptoIcon(
                imageUrl: AppConstants.usdtIconUrl,
                size: 24,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'USDT/USD',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Buy',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Price
          Text(
            '\$0.997',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          
          // Divider line
          Container(
            height: 2,
            width: 20,
            color: AppTheme.textTertiary,
          ),
        ],
      ),
    );
  }
}
