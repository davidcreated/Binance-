import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';
import 'features/token_detail/token_detail_screen.dart';
import 'features/trading/trading_screen.dart';
import 'features/feed/feed_screen.dart';
import 'features/opportunity/opportunity_screen.dart';
import 'features/spot_trading/spot_trading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const BinanceApp());
}

class BinanceApp extends StatelessWidget {
  const BinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binance Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Custom page transitions
        switch (settings.name) {
          case '/':
            return _buildPageRoute(const SplashScreen(), settings);
          case '/onboarding':
            return _buildFadeRoute(const OnboardingScreen(), settings);
          case '/home':
            return _buildSlideRoute(const HomeScreen(), settings);
          case '/token-detail':
            return _buildSlideRoute(const TokenDetailScreen(), settings);
          case '/trading':
            return _buildSlideRoute(const TradingScreen(), settings);
          case '/feed':
            return _buildSlideRoute(const FeedScreen(), settings);
          case '/opportunity':
            return _buildSlideRoute(const OpportunityScreen(), settings);
          case '/spot-trading':
            return _buildSlideRoute(const SpotTradingScreen(), settings);
          default:
            return _buildPageRoute(const HomeScreen(), settings);
        }
      },
    );
  }

  // Standard page route (no animation)
  PageRoute _buildPageRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }

  // Fade transition
  PageRoute _buildFadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Slide from right transition (iOS-style)
  PageRoute _buildSlideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        // Add a subtle fade effect
        var fadeAnimation = Tween(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
