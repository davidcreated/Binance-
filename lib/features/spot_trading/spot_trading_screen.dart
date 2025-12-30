import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../home/widgets/bottom_nav_bar.dart';
import 'widgets/order_book.dart';
import 'widgets/trade_form.dart';

class SpotTradingScreen extends StatefulWidget {
  const SpotTradingScreen({super.key});

  @override
  State<SpotTradingScreen> createState() => _SpotTradingScreenState();
}

class _SpotTradingScreenState extends State<SpotTradingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _topTabController;
  int _selectedNavIndex = 2;
  
  final List<String> _topTabs = ['Convert', 'Spot', 'Margin', 'Buy/Sell', 'P2P'];

  @override
  void initState() {
    super.initState();
    _topTabController = TabController(
      length: _topTabs.length, 
      vsync: this,
      initialIndex: 1, // Spot selected
    );
  }

  @override
  void dispose() {
    _topTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cardWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Top Tab Bar
            _buildTopTabBar(),
            
            // Trading Pair Header
            _buildPairHeader(),
            
            // Main Content
            Expanded(
              child: Row(
                children: [
                  // Left Side - Order Book
                  const Expanded(
                    flex: 4,
                    child: OrderBook(),
                  ),
                  
                  // Right Side - Trade Form
                  const Expanded(
                    flex: 5,
                    child: TradeForm(),
                  ),
                ],
              ),
            ),
            
            // Chart Section Header
            _buildChartHeader(),
            
            // Bottom Nav
            BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTap: (index) => setState(() => _selectedNavIndex = index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _topTabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppTheme.textPrimary,
              unselectedLabelColor: AppTheme.textSecondary,
              labelStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: _topTabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPairHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Pair Name with Dropdown
          Row(
            children: [
              Text(
                'BTC/USDT',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppTheme.textPrimary),
            ],
          ),
          const SizedBox(width: 8),
          
          // Change Percentage
          Text(
            '-0.59%',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.error,
            ),
          ),
          
          const Spacer(),
          
          // Action Icons
          const Icon(Icons.copy_outlined, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 16),
          const Icon(Icons.more_horiz, color: AppTheme.textSecondary, size: 20),
        ],
      ),
    );
  }

  Widget _buildChartHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: Row(
        children: [
          Text(
            'BTC/USDT Chart',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
        ],
      ),
    );
  }
}
