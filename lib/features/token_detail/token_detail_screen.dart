import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/crypto_icon.dart';
import 'widgets/ai_recommendation_card.dart';
import 'widgets/ai_rating_chart.dart';
import 'widgets/rating_stats_list.dart';

class TokenDetailScreen extends StatelessWidget {
  const TokenDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    
                    // Token Info
                    _buildTokenInfo(),
                    
                    const SizedBox(height: 24),
                    
                    // AI Recommendation Card
                    const AIRecommendationCard(),
                    
                    const SizedBox(height: 32),
                    
                    // AI Rating Title
                    Text(
                      'AI Rating',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Diamond Rating Chart
                    const AIRatingChart(
                      overallScore: 7.82,
                      socialMedia: 9.99,
                      news: 7.41,
                      kol: 6.17,
                      socialSentiment: 7.72,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Rating Stats List
                    const RatingStatsList(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Bar
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenInfo() {
    return Row(
      children: [
        // BNB Icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF3BA2F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const CryptoIcon(
            imageUrl: AppConstants.bnbIconUrl,
            size: 48,
          ),
        ),
        const SizedBox(width: 12),
        
        // Token Name and Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BNB',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Row(
              children: [
                Text(
                  '\$1,252.41',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '-3.36%',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Favorite Button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.star_border,
                color: AppTheme.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // Trade Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/trading');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.textPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Trade',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
