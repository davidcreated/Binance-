import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  
  List<SearchResult> _searchResults = [];
  List<String> _recentSearches = ['BTC', 'ETH', 'BNB', 'SOL'];
  bool _isSearching = false;

  final List<SearchResult> _allCoins = [
    SearchResult(symbol: 'BTC', name: 'Bitcoin', price: 107250.00, change: 2.34),
    SearchResult(symbol: 'ETH', name: 'Ethereum', price: 3380.50, change: -1.25),
    SearchResult(symbol: 'BNB', name: 'BNB', price: 705.30, change: 0.89),
    SearchResult(symbol: 'SOL', name: 'Solana', price: 185.40, change: 5.67),
    SearchResult(symbol: 'XRP', name: 'XRP', price: 2.15, change: -0.45),
    SearchResult(symbol: 'ADA', name: 'Cardano', price: 0.98, change: 1.23),
    SearchResult(symbol: 'DOGE', name: 'Dogecoin', price: 0.32, change: -2.10),
    SearchResult(symbol: 'AVAX', name: 'Avalanche', price: 38.50, change: 3.45),
    SearchResult(symbol: 'DOT', name: 'Polkadot', price: 7.25, change: 0.78),
    SearchResult(symbol: 'MATIC', name: 'Polygon', price: 0.52, change: -1.56),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    
    _animController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allCoins
            .where((coin) =>
                coin.symbol.toLowerCase().contains(query.toLowerCase()) ||
                coin.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _addToRecent(String symbol) {
    setState(() {
      _recentSearches.remove(symbol);
      _recentSearches.insert(0, symbol);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    });
  }

  void _clearRecent() {
    HapticFeedback.lightImpact();
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Search Header
              _buildSearchHeader(),
              
              // Content
              Expanded(
                child: _isSearching
                    ? _buildSearchResults()
                    : _buildRecentAndTrending(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _onSearch,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search coins, pairs, news...',
                  hintStyle: GoogleFonts.inter(
                    color: AppTheme.textTertiary,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.textSecondary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAndTrending() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: _clearRecent,
                  child: Text(
                    'Clear',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    _onSearch(search);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceGray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          search,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _recentSearches.remove(search);
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          
          // Trending
          Text(
            'Trending 🔥',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          ...List.generate(5, (index) {
            final coin = _allCoins[index];
            return _TrendingItem(
              rank: index + 1,
              coin: coin,
              onTap: () {
                _addToRecent(coin.symbol);
                Navigator.pop(context, coin);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final coin = _searchResults[index];
        return _SearchResultItem(
          coin: coin,
          onTap: () {
            _addToRecent(coin.symbol);
            Navigator.pop(context, coin);
          },
        );
      },
    );
  }
}

class _TrendingItem extends StatelessWidget {
  final int rank;
  final SearchResult coin;
  final VoidCallback onTap;

  const _TrendingItem({
    required this.rank,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.borderLight.withOpacity(0.5)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$rank',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  coin.symbol[0],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryYellow,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.symbol,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    coin.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${coin.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${coin.change >= 0 ? '+' : ''}${coin.change.toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: coin.change >= 0 ? AppTheme.success : AppTheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final SearchResult coin;
  final VoidCallback onTap;

  const _SearchResultItem({
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.borderLight.withOpacity(0.5)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  coin.symbol[0],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryYellow,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.symbol,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    coin.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${coin.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: coin.change >= 0 
                        ? AppTheme.successLight 
                        : AppTheme.errorLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${coin.change >= 0 ? '+' : ''}${coin.change.toStringAsFixed(2)}%',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: coin.change >= 0 ? AppTheme.success : AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResult {
  final String symbol;
  final String name;
  final double price;
  final double change;

  SearchResult({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });
}
