import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/market_sentiment_card.dart';
import 'widgets/fear_greed_gauge.dart';
import 'widgets/btc_valuation_card.dart';
import 'widgets/etf_flow_card.dart';

class OpportunityScreen extends StatefulWidget {
  const OpportunityScreen({super.key});

  @override
  State<OpportunityScreen> createState() => _OpportunityScreenState();
}

class _OpportunityScreenState extends State<OpportunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomTabIndex = 0;
  
  final List<String> _tabs = ['Market', 'Social Echo', 'Coin Radar', 'Top Mover', 'Ex...'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldLight,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Today's Market Card
                      const MarketSentimentCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Fear & Greed and BTC Valuation Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildSectionHeader('Fear & Greed', () {}),
                          ),
                          Expanded(
                            child: _buildSectionHeader('BTC Valuation', () {}),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Row(
                        children: const [
                          Expanded(child: FearGreedGauge(value: 28)),
                          SizedBox(width: 12),
                          Expanded(child: BTCValuationCard()),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // ETF Net Flow Section
                      _buildSectionHeader('ETF Net Flow', () {}),
                      
                      const SizedBox(height: 12),
                      
                      const ETFFlowCard(),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Navigation
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          ),
          const Spacer(),
          Text(
            'Opportunity',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          const Icon(Icons.qr_code_scanner, color: AppTheme.textPrimary),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.card_giftcard, 
              color: AppTheme.textSecondary, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppTheme.textPrimary,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Opportunity'},
      {'icon': Icons.calendar_today_outlined, 'label': 'Calendar'},
      {'icon': Icons.inventory_2_outlined, 'label': 'Portfolio'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        border: Border(
          top: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == _bottomTabIndex;
          
          return GestureDetector(
            onTap: () => setState(() => _bottomTabIndex = index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
