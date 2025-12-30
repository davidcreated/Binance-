import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/trading_header.dart';
import 'widgets/price_info.dart';
import 'widgets/candlestick_chart.dart';
import 'widgets/time_tabs.dart';
import 'widgets/indicator_tabs.dart';
import 'widgets/period_stats.dart';
import 'widgets/order_book_tabs.dart';
import 'widgets/trading_bottom_bar.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Trading Header
            TradingHeader(
              pair: 'BTC/USDT',
              onBack: () => Navigator.pop(context),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab Bar (Price, Info, Trading Data, Square, Trade-X)
                    const _TabBar(),
                    
                    // Price Info Section
                    const PriceInfo(),
                    
                    // Time Interval Tabs
                    const TimeTabs(),
                    
                    // Candlestick Chart
                    const CandlestickChartWidget(),
                    
                    // Technical Indicators
                    const IndicatorTabs(),
                    
                    // Period Stats (Today, 7 Days, etc.)
                    const PeriodStats(),
                    
                    const SizedBox(height: 8),
                    
                    // Order Book Tabs
                    const OrderBookTabs(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            // Bottom Trading Bar
            const TradingBottomBar(),
          ],
        ),
      ),
    );
  }
}

class _TabBar extends StatefulWidget {
  const _TabBar();

  @override
  State<_TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<_TabBar> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Price', 'Info', 'Trading Data', 'Square', 'Trade-X'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: Text(
                _tabs[index],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected 
                    ? AppTheme.darkTextPrimary 
                    : AppTheme.darkTextSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
