import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class EarnCard extends StatelessWidget {
  const EarnCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Row(
          children: [
            // Earn Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Earn',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Vault Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 18,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            
            // Earn Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'Earn up to '),
                        TextSpan(
                          text: '20.00% APR',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'with USDT',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Subscribe Button
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: const BorderSide(color: AppTheme.borderLight),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Subscribe',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
