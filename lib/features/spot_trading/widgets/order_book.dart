import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';

class OrderBook extends StatefulWidget {
  const OrderBook({super.key});

  @override
  State<OrderBook> createState() => _OrderBookState();
}

class _OrderBookState extends State<OrderBook> with TickerProviderStateMixin {
  late AnimationController _priceAnimController;
  final List<OrderEntry> _sellOrders = [];
  final List<OrderEntry> _buyOrders = [];
  double _currentPrice = 121146.83;
  bool _isPriceUp = true;

  @override
  void initState() {
    super.initState();
    _priceAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _generateOrders();
    _simulatePriceChanges();
  }

  void _generateOrders() {
    final random = math.Random();
    
    // Generate sell orders (asks) - higher prices
    for (int i = 0; i < 10; i++) {
      _sellOrders.add(OrderEntry(
        price: 121148.53 - (i * 0.01),
        amount: (random.nextDouble() * 0.5).toStringAsFixed(5),
        isNew: false,
      ));
    }

    // Generate buy orders (bids) - lower prices
    for (int i = 0; i < 15; i++) {
      _buyOrders.add(OrderEntry(
        price: 121146.82 - (i * 0.01),
        amount: (random.nextDouble() * 0.5).toStringAsFixed(5),
        isNew: false,
      ));
    }
  }

  void _simulatePriceChanges() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          final random = math.Random();
          final change = random.nextDouble() * 2 - 1;
          final oldPrice = _currentPrice;
          _currentPrice += change;
          _isPriceUp = _currentPrice > oldPrice;
          _priceAnimController.forward(from: 0);
        });
      }
    }
  }

  @override
  void dispose() {
    _priceAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Column Headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Price\n(USDT)',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Amount\n(BTC)',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Sell Orders (Asks) - Red
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: EdgeInsets.zero,
            itemCount: _sellOrders.length,
            itemBuilder: (context, index) {
              final order = _sellOrders[index];
              return _OrderRow(
                price: order.price.toStringAsFixed(2),
                amount: order.amount,
                isSell: true,
                depth: (index + 1) / _sellOrders.length,
              );
            },
          ),
        ),
        
        // Current Price
        _buildCurrentPrice(),
        
        // Buy Orders (Bids) - Green
        Expanded(
          flex: 2,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _buyOrders.length,
            itemBuilder: (context, index) {
              final order = _buyOrders[index];
              return _OrderRow(
                price: order.price.toStringAsFixed(2),
                amount: order.amount,
                isSell: false,
                depth: (index + 1) / _buyOrders.length,
              );
            },
          ),
        ),
        
        // Depth Indicator
        _buildDepthIndicator(),
      ],
    );
  }

  Widget _buildCurrentPrice() {
    return AnimatedBuilder(
      animation: _priceAnimController,
      builder: (context, child) {
        final flashOpacity = (1 - _priceAnimController.value) * 0.3;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: (_isPriceUp ? AppTheme.success : AppTheme.error)
              .withOpacity(flashOpacity),
          child: Row(
            children: [
              Text(
                _currentPrice.toStringAsFixed(2),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _isPriceUp ? AppTheme.success : AppTheme.error,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isPriceUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: _isPriceUp ? AppTheme.success : AppTheme.error,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDepthIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '4.35%',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.success,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: 4,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 96,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.success,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '95.65%',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '0.01',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.grid_view, color: AppTheme.textSecondary, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatefulWidget {
  final String price;
  final String amount;
  final bool isSell;
  final double depth;

  const _OrderRow({
    required this.price,
    required this.amount,
    required this.isSell,
    required this.depth,
  });

  @override
  State<_OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<_OrderRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant _OrderRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      _flashController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isSell ? AppTheme.error : AppTheme.success;
    
    return AnimatedBuilder(
      animation: _flashController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          color: color.withOpacity((1 - _flashController.value) * 0.1),
          child: Stack(
            children: [
              // Depth indicator background
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15 * widget.depth,
                  color: color.withOpacity(0.1),
                ),
              ),
              // Content
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.price,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.amount,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class OrderEntry {
  final double price;
  final String amount;
  final bool isNew;

  OrderEntry({
    required this.price,
    required this.amount,
    required this.isNew,
  });
}
