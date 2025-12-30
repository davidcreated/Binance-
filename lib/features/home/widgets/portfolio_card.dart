import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class PortfolioCard extends StatefulWidget {
  const PortfolioCard({super.key});

  @override
  State<PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard>
    with SingleTickerProviderStateMixin {
  bool _isBalanceVisible = true;
  late AnimationController _refreshController;
  bool _isRefreshing = false;

  // Simulated portfolio data
  double _btcBalance = 0.0234;
  double _usdBalance = 2516.87;
  double _todayPnl = 0.34;
  double _todayPnlPercent = 0.01;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _toggleBalanceVisibility() {
    HapticFeedback.lightImpact();
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  void _refreshBalance() async {
    if (_isRefreshing) return;
    
    HapticFeedback.mediumImpact();
    setState(() {
      _isRefreshing = true;
    });
    
    _refreshController.repeat();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      // Simulate small balance changes
      _btcBalance += (DateTime.now().millisecond % 10) * 0.0001;
      _usdBalance = _btcBalance * 107500;
      _todayPnl = (DateTime.now().second % 100) / 100;
      _todayPnlPercent = _todayPnl / _usdBalance * 100;
      _isRefreshing = false;
    });
    
    _refreshController.stop();
    _refreshController.reset();
  }

  void _showAddFundsSheet() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddFundsSheet(),
    );
  }

  void _showTransferOptions() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _TransferOptionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF9E6),
            Color(0xFFFFEFCC),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Estimated Total Value',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _toggleBalanceVisibility,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _isBalanceVisible 
                            ? Icons.visibility_outlined 
                            : Icons.visibility_off_outlined,
                        key: ValueKey(_isBalanceVisible),
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _refreshBalance,
                child: AnimatedBuilder(
                  animation: _refreshController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _refreshController.value * 2 * 3.14159,
                      child: Icon(
                        Icons.refresh,
                        size: 18,
                        color: _isRefreshing 
                            ? AppTheme.primaryYellow 
                            : AppTheme.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // BTC Balance
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _isBalanceVisible 
                      ? '${_btcBalance.toStringAsFixed(8)} BTC'
                      : '●●●●●●●● BTC',
                  key: ValueKey('btc_$_isBalanceVisible'),
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          
          // USD Balance
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _isBalanceVisible 
                  ? '≈ \$${_usdBalance.toStringAsFixed(2)}'
                  : '≈ \$●●●●●',
              key: ValueKey('usd_$_isBalanceVisible'),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Today's PNL
          GestureDetector(
            onTap: () {
              // Show PNL details
              _showPnlDetails();
            },
            child: Row(
              children: [
                Text(
                  "Today's PNL",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _isBalanceVisible 
                        ? '+\$${_todayPnl.toStringAsFixed(2)} (+${_todayPnlPercent.toStringAsFixed(2)}%)'
                        : '+\$●●● (+●●●%)',
                    key: ValueKey('pnl_$_isBalanceVisible'),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.success,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Add Funds',
                  icon: Icons.add,
                  isPrimary: true,
                  onTap: _showAddFundsSheet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Transfer',
                  icon: Icons.swap_horiz,
                  isPrimary: false,
                  onTap: _showTransferOptions,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPnlDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PNL Details',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            _buildPnlRow('Today', '+\$${_todayPnl.toStringAsFixed(2)}', true),
            _buildPnlRow('This Week', '+\$12.45', true),
            _buildPnlRow('This Month', '-\$23.67', false),
            _buildPnlRow('All Time', '+\$156.89', true),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildPnlRow(String period, String value, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            period,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPositive ? AppTheme.success : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

// Action Button Widget
class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: widget.isPrimary
              ? (_isPressed ? AppTheme.primaryYellow.withOpacity(0.8) : AppTheme.primaryYellow)
              : (_isPressed ? AppTheme.surfaceGray : AppTheme.cardWhite),
          borderRadius: BorderRadius.circular(8),
          border: widget.isPrimary ? null : Border.all(color: AppTheme.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 18,
              color: AppTheme.textPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add Funds Sheet
class _AddFundsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final options = [
      {'icon': Icons.credit_card, 'label': 'Buy Crypto', 'desc': 'Use card or bank'},
      {'icon': Icons.account_balance, 'label': 'Deposit', 'desc': 'From wallet'},
      {'icon': Icons.qr_code, 'label': 'Receive', 'desc': 'Crypto address'},
      {'icon': Icons.person_add, 'label': 'P2P Trading', 'desc': 'Buy from users'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Funds',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          ...options.map((option) {
            return ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  option['icon'] as IconData,
                  color: AppTheme.primaryYellow,
                ),
              ),
              title: Text(
                option['label'] as String,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                option['desc'] as String,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// Transfer Options Sheet
class _TransferOptionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final options = [
      {'icon': Icons.arrow_upward, 'label': 'Send', 'color': AppTheme.error},
      {'icon': Icons.arrow_downward, 'label': 'Receive', 'color': AppTheme.success},
      {'icon': Icons.swap_horiz, 'label': 'Internal Transfer', 'color': AppTheme.primaryYellow},
      {'icon': Icons.history, 'label': 'Transaction History', 'color': AppTheme.textSecondary},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: options.map((option) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (option['color'] as Color).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        option['icon'] as IconData,
                        color: option['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
