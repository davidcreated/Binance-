import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class BTCValuationCard extends StatefulWidget {
  const BTCValuationCard({super.key});

  @override
  State<BTCValuationCard> createState() => _BTCValuationCardState();
}

class _BTCValuationCardState extends State<BTCValuationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 0.83).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Value
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Text(
                (_progressAnimation.value).toStringAsFixed(2),
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.success,
                ),
              );
            },
          ),
          
          const SizedBox(height: 8),
          
          // Label
          Text(
            'Regular Investing',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progress Bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: constraints.maxWidth * _progressAnimation.value,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0ECB81),
                                Color(0xFF27AE60),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
