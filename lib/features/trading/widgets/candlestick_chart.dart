import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';

class CandlestickChartWidget extends StatelessWidget {
  const CandlestickChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // MA Lines Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                _buildMALabel('MA(7):', '122,770.90', const Color(0xFFF3BA2F)),
                const SizedBox(width: 8),
                _buildMALabel('MA(25):', '122,020.97', const Color(0xFFE377C2)),
                const SizedBox(width: 8),
                _buildMALabel('MA(99):', '123,396.81', const Color(0xFF9467BD)),
              ],
            ),
          ),
          
          // Chart
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: CandlestickPainter(),
            ),
          ),
          
          // Volume Section
          SizedBox(
            height: 50,
            child: CustomPaint(
              size: Size.infinite,
              painter: VolumePainter(),
            ),
          ),
          
          // Volume Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Vol: 210.38037',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.darkTextSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'MA(5): 336.52219',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFFF3BA2F),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'MA(10): 392.80752',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFFE377C2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMALabel(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: color,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: color,
          ),
        ),
      ],
    );
  }
}

class CandlestickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent display
    
    // Sample candlestick data
    final candleCount = 30;
    final candleWidth = size.width / candleCount * 0.7;
    final spacing = size.width / candleCount;
    
    // Price range
    const minPrice = 120600.0;
    const maxPrice = 123500.0;
    const priceRange = maxPrice - minPrice;
    
    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppTheme.darkTextSecondary.withOpacity(0.1)
      ..strokeWidth = 0.5;
    
    // Horizontal grid lines
    for (int i = 0; i <= 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    
    // Price labels on right side
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    final priceLabels = [123941.22, 123246.97, 122552.73, 121858.49, 121470.24, 122900.00];
    for (int i = 0; i < priceLabels.length; i++) {
      final y = size.height * i / 5;
      textPainter.text = TextSpan(
        text: priceLabels[i].toStringAsFixed(2),
        style: GoogleFonts.inter(
          fontSize: 9,
          color: AppTheme.darkTextSecondary,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width - textPainter.width - 4, y - 6));
    }
    
    // Draw MA lines
    final ma7Paint = Paint()
      ..color = const Color(0xFFF3BA2F)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    final ma25Paint = Paint()
      ..color = const Color(0xFFE377C2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    final ma7Path = Path();
    final ma25Path = Path();
    
    // Generate and draw candlesticks
    List<double> closes = [];
    
    for (int i = 0; i < candleCount; i++) {
      final x = spacing * i + spacing / 2;
      
      // Generate random candle data
      final open = minPrice + random.nextDouble() * priceRange;
      final close = minPrice + random.nextDouble() * priceRange;
      final high = math.max(open, close) + random.nextDouble() * 500;
      final low = math.min(open, close) - random.nextDouble() * 500;
      
      closes.add(close);
      
      final isGreen = close >= open;
      final paint = Paint()
        ..color = isGreen ? AppTheme.success : AppTheme.error
        ..strokeWidth = 1;
      
      // Draw wick
      final highY = size.height - ((high - minPrice) / priceRange * size.height);
      final lowY = size.height - ((low - minPrice) / priceRange * size.height);
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);
      
      // Draw body
      final openY = size.height - ((open - minPrice) / priceRange * size.height);
      final closeY = size.height - ((close - minPrice) / priceRange * size.height);
      
      final bodyRect = Rect.fromLTRB(
        x - candleWidth / 2,
        math.min(openY, closeY),
        x + candleWidth / 2,
        math.max(openY, closeY),
      );
      
      if (isGreen) {
        canvas.drawRect(bodyRect, paint..style = PaintingStyle.fill);
      } else {
        canvas.drawRect(bodyRect, paint..style = PaintingStyle.fill);
      }
    }
    
    // Draw MA lines
    for (int i = 0; i < closes.length; i++) {
      final x = spacing * i + spacing / 2;
      
      // MA7 (simplified - just offset the close slightly)
      final ma7Value = closes[i] + (random.nextDouble() - 0.5) * 200;
      final ma7Y = size.height - ((ma7Value - minPrice) / priceRange * size.height);
      
      if (i == 0) {
        ma7Path.moveTo(x, ma7Y);
      } else {
        ma7Path.lineTo(x, ma7Y);
      }
      
      // MA25
      final ma25Value = closes[i] + (random.nextDouble() - 0.5) * 400;
      final ma25Y = size.height - ((ma25Value - minPrice) / priceRange * size.height);
      
      if (i == 0) {
        ma25Path.moveTo(x, ma25Y);
      } else {
        ma25Path.lineTo(x, ma25Y);
      }
    }
    
    canvas.drawPath(ma7Path, ma7Paint);
    canvas.drawPath(ma25Path, ma25Paint);
    
    // Draw current price indicator
    final currentPriceY = size.height - ((122900 - minPrice) / priceRange * size.height);
    final dashPaint = Paint()
      ..color = AppTheme.darkTextPrimary
      ..strokeWidth = 1;
    
    // Dashed line
    double dashX = 0;
    while (dashX < size.width - 60) {
      canvas.drawLine(
        Offset(dashX, currentPriceY),
        Offset(dashX + 4, currentPriceY),
        dashPaint,
      );
      dashX += 8;
    }
    
    // Price box
    final priceBoxRect = RRect.fromLTRBR(
      size.width - 70,
      currentPriceY - 10,
      size.width - 4,
      currentPriceY + 10,
      const Radius.circular(2),
    );
    canvas.drawRRect(priceBoxRect, Paint()..color = AppTheme.darkSurface);
    canvas.drawRRect(priceBoxRect, Paint()
      ..color = AppTheme.darkTextPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);
    
    textPainter.text = TextSpan(
      text: '122,900.00',
      style: GoogleFonts.inter(
        fontSize: 9,
        color: AppTheme.darkTextPrimary,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 68, currentPriceY - 5));
    
    // Watermark
    textPainter.text = TextSpan(
      text: 'BINANCE',
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: AppTheme.darkTextSecondary.withOpacity(0.1),
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VolumePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final barCount = 30;
    final barWidth = size.width / barCount * 0.7;
    final spacing = size.width / barCount;
    
    for (int i = 0; i < barCount; i++) {
      final x = spacing * i + spacing / 2;
      final height = random.nextDouble() * size.height * 0.8;
      final isGreen = random.nextBool();
      
      final paint = Paint()
        ..color = isGreen 
          ? AppTheme.success.withOpacity(0.7)
          : AppTheme.error.withOpacity(0.7);
      
      canvas.drawRect(
        Rect.fromLTWH(
          x - barWidth / 2,
          size.height - height,
          barWidth,
          height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
