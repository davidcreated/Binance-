import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class MarketSentimentCard extends StatefulWidget {
  const MarketSentimentCard({super.key});

  @override
  State<MarketSentimentCard> createState() => _MarketSentimentCardState();
}

class _MarketSentimentCardState extends State<MarketSentimentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFFF9E6),
                Color.lerp(
                  const Color(0xFFFFF9E6),
                  const Color(0xFFFFEFCC),
                  (_shimmerAnimation.value.clamp(0.0, 1.0)),
                )!,
                const Color(0xFFFFF9E6),
              ],
              stops: [
                0,
                _shimmerAnimation.value.clamp(0.0, 1.0),
                1,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryYellow.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppTheme.primaryYellow,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Today's Market",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Content
              Text(
                'Market sentiment is in Fear territory, indicating caution. ETF flows show volatility, with recent inflows and outflows.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
