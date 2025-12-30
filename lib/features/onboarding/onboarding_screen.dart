import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../splash/splash_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<Offset> _option1SlideAnimation;
  late Animation<Offset> _option2SlideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _option1SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
    ));

    _option2SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cardWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    
                    // Animated Logo
                    AnimatedBuilder(
                      animation: _logoAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoAnimation.value,
                          child: Opacity(
                            opacity: _logoAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryYellow.withOpacity(0.1),
                        ),
                        child: Center(
                          child: BinanceLogo(size: 80),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Animated Title
                    AnimatedBuilder(
                      animation: _titleAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _titleAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - _titleAnimation.value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Tell us about\nyourself!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Option 1 - New to crypto
                    SlideTransition(
                      position: _option1SlideAnimation,
                      child: FadeTransition(
                        opacity: _controller,
                        child: _OnboardingOption(
                          title: "I'm new to crypto",
                          subtitle: "I've heard about Bitcoin and I'm willing to trade more popular coins.",
                          onTap: () {
                            _navigateToHome();
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Option 2 - Familiar with crypto
                    SlideTransition(
                      position: _option2SlideAnimation,
                      child: FadeTransition(
                        opacity: _controller,
                        child: _OnboardingOption(
                          title: "I'm familiar with crypto",
                          subtitle: "I'm experienced in spot or futures trading, open to advanced features.",
                          onTap: () {
                            _navigateToHome();
                          },
                        ),
                      ),
                    ),
                    
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

class _OnboardingOption extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OnboardingOption({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_OnboardingOption> createState() => _OnboardingOptionState();
}

class _OnboardingOptionState extends State<_OnboardingOption> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isPressed ? AppTheme.surfaceGray : AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPressed ? AppTheme.primaryYellow : AppTheme.borderLight,
            width: _isPressed ? 2 : 1,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isPressed 
                    ? AppTheme.primaryYellow 
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: _isPressed 
                    ? AppTheme.textPrimary 
                    : AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
