import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import 'widgets/portfolio_card.dart';
import 'widgets/earn_card.dart';
import 'widgets/promo_banner.dart';
import 'widgets/crypto_price_card.dart';
import 'widgets/p2p_card.dart';
import 'widgets/feature_card.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/discover_tabs.dart';
import 'widgets/search_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  bool _showExchange = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search Bar
                    _buildSearchBar(),
                    
                    const SizedBox(height: 16),
                    
                    // Portfolio Section
                    const PortfolioCard(),
                    
                    const SizedBox(height: 12),
                    
                    // Earn Section
                    const EarnCard(),
                    
                    const SizedBox(height: 12),
                    
                    // Promo Banner
                    const PromoBanner(),
                    
                    const SizedBox(height: 12),
                    
                    // Crypto Cards Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // BNB Card
                          Expanded(
                            child: CryptoPriceCard(
                              symbol: 'BNB',
                              iconUrl: AppConstants.bnbIconUrl,
                              price: '1,219.61',
                              change: '+3.56%',
                              isPositive: true,
                              chartData: const [
                                100, 105, 103, 108, 106, 112, 110, 115, 
                                118, 116, 120, 122, 119, 125, 123
                              ],
                              onTap: () {
                                Navigator.pushNamed(context, '/token-detail');
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // P2P Card
                          const Expanded(
                            child: P2PCard(),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Feature Cards Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Fear & Greed Card
                          Expanded(
                            child: FeatureCard(
                              title: 'Fear & Greed',
                              child: _buildFearGreedIndicator(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Send Cash Card
                          const Expanded(
                            child: FeatureCard(
                              title: 'Send Cash',
                              subtitle: 'Send Crypto and\nReceive Fiat',
                              showArrow: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Discover Tabs
                    const DiscoverTabs(),
                    
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          switch (index) {
            case 1: // Markets
              Navigator.pushNamed(context, '/opportunity');
              break;
            case 2: // Trade
              Navigator.pushNamed(context, '/spot-trading');
              break;
            case 3: // Futures
              Navigator.pushNamed(context, '/trading');
              break;
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.cardWhite,
      child: Row(
        children: [
          // Hamburger Menu
          const Icon(Icons.menu, size: 24, color: AppTheme.textPrimary),
          const SizedBox(width: 12),
          
          // Cart with Badge
          Stack(
            children: [
              const Icon(Icons.shopping_cart_outlined, 
                size: 24, color: AppTheme.textPrimary),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '10',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Exchange/Wallet Toggle
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceGray,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildToggleButton('Exchange', _showExchange),
                _buildToggleButton('Wallet', !_showExchange),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Headphones Icon
          const Icon(Icons.headset_mic_outlined, 
            size: 24, color: AppTheme.textPrimary),
          const SizedBox(width: 16),
          
          // Gift Icon
          const Icon(Icons.card_giftcard_outlined, 
            size: 24, color: AppTheme.textPrimary),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showExchange = text == 'Exchange';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cardWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();
          final result = await Navigator.push<SearchResult>(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchOverlay(),
            ),
          );
          if (result != null) {
            // Navigate to token detail with the selected coin
            Navigator.pushNamed(context, '/token-detail');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppTheme.textTertiary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search coins, pairs, news...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '🔥 Trending',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.primaryYellow,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFearGreedIndicator() {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE74C3C), // Fear (Red)
                  Color(0xFFF39C12), // Neutral (Orange)
                  Color(0xFF27AE60), // Greed (Green)
                ],
              ),
            ),
          ),
          // Indicator
          Positioned(
            left: 80, // Position for "Greed" area
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.textPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
