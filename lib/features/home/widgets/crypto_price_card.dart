import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/mini_line_chart.dart';

class CryptoPriceCard extends StatefulWidget {
  final String symbol;
  final String iconUrl;
  final String price;
  final String change;
  final bool isPositive;
  final List<double> chartData;
  final VoidCallback onTap;

  const CryptoPriceCard({
    super.key,
    required this.symbol,
    required this.iconUrl,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.chartData,
    required this.onTap,
  });

  @override
  State<CryptoPriceCard> createState() => _CryptoPriceCardState();
}

class _CryptoPriceCardState extends State<CryptoPriceCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pulseController;
  bool _hasAlert = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showPriceAlertDialog() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PriceAlertSheet(
        symbol: widget.symbol,
        currentPrice: widget.price,
        onSetAlert: (alertPrice, isAbove) {
          setState(() {
            _hasAlert = true;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Alert set for ${widget.symbol} ${isAbove ? 'above' : 'below'} \$$alertPrice',
                style: GoogleFonts.inter(),
              ),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onLongPress: _showPriceAlertDialog,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isPressed 
              ? AppTheme.surfaceGray 
              : AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hasAlert 
                ? AppTheme.primaryYellow 
                : AppTheme.borderLight,
            width: _hasAlert ? 2 : 1,
          ),
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row
            Row(
              children: [
                // Icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: widget.iconUrl,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          widget.symbol[0],
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Symbol
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.symbol,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        if (_hasAlert) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.notifications_active,
                            size: 12,
                            color: AppTheme.primaryYellow,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      'Binance Coin',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Mini Chart
            SizedBox(
              height: 40,
              child: MiniLineChart(
                data: widget.chartData,
                isPositive: widget.isPositive,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Price
            Text(
              '\$${widget.price}',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Change
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: widget.isPositive 
                    ? AppTheme.successLight 
                    : AppTheme.errorLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.change,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: widget.isPositive 
                      ? AppTheme.success 
                      : AppTheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Price Alert Sheet
class _PriceAlertSheet extends StatefulWidget {
  final String symbol;
  final String currentPrice;
  final Function(String, bool) onSetAlert;

  const _PriceAlertSheet({
    required this.symbol,
    required this.currentPrice,
    required this.onSetAlert,
  });

  @override
  State<_PriceAlertSheet> createState() => _PriceAlertSheetState();
}

class _PriceAlertSheetState extends State<_PriceAlertSheet> {
  final TextEditingController _priceController = TextEditingController();
  bool _isAbove = true;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.currentPrice.replaceAll(',', '');
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Set Price Alert',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get notified when ${widget.symbol} reaches your target price.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Current Price
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Price',
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${widget.currentPrice}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Alert Type Toggle
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAbove = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isAbove 
                            ? AppTheme.success.withOpacity(0.2) 
                            : AppTheme.surfaceGray,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isAbove 
                              ? AppTheme.success 
                              : AppTheme.borderLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: _isAbove 
                                ? AppTheme.success 
                                : AppTheme.textSecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Above',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: _isAbove 
                                  ? FontWeight.w600 
                                  : FontWeight.w400,
                              color: _isAbove 
                                  ? AppTheme.success 
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAbove = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isAbove 
                            ? AppTheme.error.withOpacity(0.2) 
                            : AppTheme.surfaceGray,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: !_isAbove 
                              ? AppTheme.error 
                              : AppTheme.borderLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            color: !_isAbove 
                                ? AppTheme.error 
                                : AppTheme.textSecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Below',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: !_isAbove 
                                  ? FontWeight.w600 
                                  : FontWeight.w400,
                              color: !_isAbove 
                                  ? AppTheme.error 
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Price Input
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                labelText: 'Alert Price',
                labelStyle: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                ),
                prefixText: '\$ ',
                prefixStyle: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryYellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Set Alert Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_priceController.text.isNotEmpty) {
                    HapticFeedback.mediumImpact();
                    widget.onSetAlert(_priceController.text, _isAbove);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Set Alert',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
