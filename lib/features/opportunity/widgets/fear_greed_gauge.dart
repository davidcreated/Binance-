import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';

class FearGreedGauge extends StatefulWidget {
  final double value; // 0-100

  const FearGreedGauge({super.key, required this.value});

  @override
  State<FearGreedGauge> createState() => _FearGreedGaugeState();
}

class _FearGreedGaugeState extends State<FearGreedGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gaugeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _gaugeAnimation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _sentiment {
    if (widget.value < 25) return 'Extreme Fear';
    if (widget.value < 45) return 'Fear';
    if (widget.value < 55) return 'Neutral';
    if (widget.value < 75) return 'Greed';
    return 'Extreme Greed';
  }

  Color get _sentimentColor {
    if (widget.value < 25) return const Color(0xFFE74C3C);
    if (widget.value < 45) return const Color(0xFFF39C12);
    if (widget.value < 55) return const Color(0xFFF1C40F);
    if (widget.value < 75) return const Color(0xFF27AE60);
    return const Color(0xFF2ECC71);
  }

  void _showDetails() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FearGreedDetailSheet(
        value: widget.value,
        sentiment: _sentiment,
        color: _sentimentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDetails,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Column(
          children: [
            // Gauge
            SizedBox(
              height: 100,
              child: AnimatedBuilder(
                animation: _gaugeAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(150, 100),
                    painter: GaugePainter(value: _gaugeAnimation.value),
                  );
                },
              ),
            ),
            
            // Value and Label
            AnimatedBuilder(
              animation: _gaugeAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _gaugeAnimation.value),
                      duration: const Duration(milliseconds: 1500),
                      builder: (context, value, child) {
                        return Text(
                          value.round().toString(),
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _sentimentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _sentiment,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _sentimentColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 8),
            
            // Tap for details
            Text(
              'Tap for details',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;

  GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.45;

    // Background arc (gradient)
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Draw gradient arc segments
    final segments = [
      {'startAngle': math.pi, 'sweepAngle': math.pi * 0.25, 'color': const Color(0xFFE74C3C)},
      {'startAngle': math.pi * 1.25, 'sweepAngle': math.pi * 0.25, 'color': const Color(0xFFF39C12)},
      {'startAngle': math.pi * 1.5, 'sweepAngle': math.pi * 0.25, 'color': const Color(0xFFF1C40F)},
      {'startAngle': math.pi * 1.75, 'sweepAngle': math.pi * 0.25, 'color': const Color(0xFF27AE60)},
    ];

    for (final segment in segments) {
      backgroundPaint.color = segment['color'] as Color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segment['startAngle'] as double,
        segment['sweepAngle'] as double,
        false,
        backgroundPaint,
      );
    }

    // Draw needle
    final needleAngle = math.pi + (value / 100) * math.pi;
    final needleLength = radius * 0.7;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = AppTheme.textPrimary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center dot
    canvas.drawCircle(
      center,
      8,
      Paint()..color = AppTheme.textPrimary,
    );
    canvas.drawCircle(
      center,
      4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

// Detail Sheet
class _FearGreedDetailSheet extends StatelessWidget {
  final double value;
  final String sentiment;
  final Color color;

  const _FearGreedDetailSheet({
    required this.value,
    required this.sentiment,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Fear & Greed Index',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${value.round()} - $sentiment',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            'What does this mean?',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getDescription(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Historical Data',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildHistoryRow('Yesterday', '31', 'Fear'),
          _buildHistoryRow('Last Week', '45', 'Neutral'),
          _buildHistoryRow('Last Month', '72', 'Greed'),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _getDescription() {
    if (value < 25) {
      return 'Extreme Fear can be a sign that investors are too worried. This could be a buying opportunity for contrarian investors.';
    } else if (value < 45) {
      return 'The market is in a state of fear. Some investors may be selling off their holdings, potentially creating buying opportunities.';
    } else if (value < 55) {
      return 'The market sentiment is neutral. Neither fear nor greed is dominating the market at the moment.';
    } else if (value < 75) {
      return 'Investors are becoming greedy, which could be a sign that the market is getting overvalued. Be cautious with new investments.';
    } else {
      return 'Extreme Greed often correlates with market tops. Many investors may be buying out of FOMO rather than fundamentals.';
    }
  }

  Widget _buildHistoryRow(String period, String indexValue, String sentiment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            period,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            indexValue,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            sentiment,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
