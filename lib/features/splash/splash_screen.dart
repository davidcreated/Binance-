import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Text fade controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo scale animation with bounce
    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_logoController);

    // Subtle rotation for 3D effect
    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // Text fade in
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _pulseController.repeat(reverse: true);
    
    // Navigate to onboarding after splash
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cardWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedBuilder(
              animation: Listenable.merge([
                _logoController,
                _pulseController,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value * _pulseAnimation.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_logoRotationAnimation.value),
                    child: child,
                  ),
                );
              },
              child: const BinanceLogo(size: 100),
            ),
            
            const SizedBox(height: 24),
            
            // Animated Text
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textFadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _textFadeAnimation.value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                'BINANCE',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryYellow,
                  letterSpacing: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Binance Diamond Logo
class BinanceLogo extends StatelessWidget {
  final double size;
  
  const BinanceLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: BinanceLogoPainter(),
    );
  }
}

class BinanceLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryYellow
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final unit = size.width / 8;

    // Draw the Binance diamond logo (4 rotated squares)
    _drawDiamond(canvas, center, unit * 3.5, paint);
    
    // Inner diamonds
    canvas.save();
    canvas.translate(center.dx, center.dy - unit * 1.8);
    _drawSmallDiamond(canvas, Offset.zero, unit * 1.2, paint);
    canvas.restore();
    
    canvas.save();
    canvas.translate(center.dx, center.dy + unit * 1.8);
    _drawSmallDiamond(canvas, Offset.zero, unit * 1.2, paint);
    canvas.restore();
    
    canvas.save();
    canvas.translate(center.dx - unit * 1.8, center.dy);
    _drawSmallDiamond(canvas, Offset.zero, unit * 1.2, paint);
    canvas.restore();
    
    canvas.save();
    canvas.translate(center.dx + unit * 1.8, center.dy);
    _drawSmallDiamond(canvas, Offset.zero, unit * 1.2, paint);
    canvas.restore();
    
    // Center diamond
    _drawSmallDiamond(canvas, center, unit * 1.2, paint);
  }

  void _drawDiamond(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius, center.dy);
    path.close();
    
    // Only stroke for outer diamond
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = 3);
  }

  void _drawSmallDiamond(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius, center.dy);
    path.close();
    
    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
