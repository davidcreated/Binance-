import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Price
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Price
                Text(
                  '122,900.01',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                  ),
                ),
                // USD Price and Change
                Row(
                  children: [
                    Text(
                      '\$122,900.01',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.darkTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '-1.23%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // POW, Vol, Price Protection
                Row(
                  children: [
                    Text(
                      'POW',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Vol',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Price Protection',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Right side - 24h Stats
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatRow('24h High', '125,126.00'),
                const SizedBox(height: 4),
                _buildStatRow('24h Low', '120,574.94'),
                const SizedBox(height: 8),
                _buildStatRow('24h Vol(BTC)', '23,517.17'),
                const SizedBox(height: 4),
                _buildStatRow('24h Vol(USDT)', '2.87B'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppTheme.darkTextSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppTheme.darkTextPrimary,
          ),
        ),
      ],
    );
  }
}
