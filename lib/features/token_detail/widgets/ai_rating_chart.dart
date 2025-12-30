import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class AIRatingChart extends StatelessWidget {
  final double overallScore;
  final double socialMedia;
  final double news;
  final double kol;
  final double socialSentiment;

  const AIRatingChart({
    super.key,
    required this.overallScore,
    required this.socialMedia,
    required this.news,
    required this.kol,
    required this.socialSentiment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Diamond Chart with Labels
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Labels positioned around the diamond
              Positioned(
                top: 0,
                child: Text(
                  'Social Media / ${socialMedia.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: Text(
                  'News / ${news.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Text(
                  'KOL / ${kol.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Text(
                  'Social Sentiment / ${socialSentiment.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              
              // Diamond Shape
              Padding(
                padding: const EdgeInsets.all(40),
                child: CustomPaint(
                  size: const Size(140, 140),
                  painter: DiamondPainter(
                    socialMedia: socialMedia / 10,
                    news: news / 10,
                    kol: kol / 10,
                    socialSentiment: socialSentiment / 10,
                  ),
                ),
              ),
              
              // Center Score
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    overallScore.toStringAsFixed(2),
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Strong Positive',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiamondPainter extends CustomPainter {
  final double socialMedia;
  final double news;
  final double kol;
  final double socialSentiment;

  DiamondPainter({
    required this.socialMedia,
    required this.news,
    required this.kol,
    required this.socialSentiment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw background grid lines
    final gridPaint = Paint()
      ..color = AppTheme.borderLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double scale = 0.25; scale <= 1.0; scale += 0.25) {
      final path = Path();
      final r = maxRadius * scale;
      path.moveTo(center.dx, center.dy - r); // Top
      path.lineTo(center.dx + r, center.dy); // Right
      path.lineTo(center.dx, center.dy + r); // Bottom
      path.lineTo(center.dx - r, center.dy); // Left
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axes
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius),
      Offset(center.dx, center.dy + maxRadius),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx - maxRadius, center.dy),
      Offset(center.dx + maxRadius, center.dy),
      gridPaint,
    );

    // Draw filled diamond based on values
    final fillPaint = Paint()
      ..color = AppTheme.success.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppTheme.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final valuePath = Path();
    final topY = center.dy - (maxRadius * socialMedia);
    final rightX = center.dx + (maxRadius * kol);
    final bottomY = center.dy + (maxRadius * socialSentiment);
    final leftX = center.dx - (maxRadius * news);

    valuePath.moveTo(center.dx, topY); // Top (Social Media)
    valuePath.lineTo(rightX, center.dy); // Right (KOL)
    valuePath.lineTo(center.dx, bottomY); // Bottom (Social Sentiment)
    valuePath.lineTo(leftX, center.dy); // Left (News)
    valuePath.close();

    canvas.drawPath(valuePath, fillPaint);
    canvas.drawPath(valuePath, strokePaint);

    // Draw dots at vertices
    final dotPaint = Paint()
      ..color = AppTheme.success
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx, topY), 4, dotPaint);
    canvas.drawCircle(Offset(rightX, center.dy), 4, dotPaint);
    canvas.drawCircle(Offset(center.dx, bottomY), 4, dotPaint);
    canvas.drawCircle(Offset(leftX, center.dy), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
