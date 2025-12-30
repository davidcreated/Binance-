import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class TradeForm extends StatefulWidget {
  const TradeForm({super.key});

  @override
  State<TradeForm> createState() => _TradeFormState();
}

class _TradeFormState extends State<TradeForm>
    with SingleTickerProviderStateMixin {
  bool _isBuy = true;
  String _orderType = 'Limit';
  double _sliderValue = 0.5;
  bool _showTPSL = true;
  bool _isAdvanced = false;
  
  final TextEditingController _priceController = TextEditingController(text: '121120.00');
  final TextEditingController _amountController = TextEditingController(text: '0.00005');
  final TextEditingController _tpController = TextEditingController(text: '123542.40');
  final TextEditingController _slTriggerController = TextEditingController(text: '119908.80');
  final TextEditingController _slLimitController = TextEditingController(text: '119908.80');

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    _tpController.dispose();
    _slTriggerController.dispose();
    _slLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buy/Sell Toggle
            _buildBuySellToggle(),
            
            const SizedBox(height: 12),
            
            // Order Type Selector
            _buildOrderTypeSelector(),
            
            const SizedBox(height: 12),
            
            // Price Input
            _buildInputField(
              label: 'Price (USDT)',
              controller: _priceController,
              showButtons: true,
            ),
            
            const SizedBox(height: 8),
            
            // Amount Input
            _buildInputField(
              label: 'Amount (BTC)',
              controller: _amountController,
              showButtons: true,
            ),
            
            const SizedBox(height: 12),
            
            // Slider
            _buildSlider(),
            
            const SizedBox(height: 12),
            
            // Total
            _buildTotalField(),
            
            const SizedBox(height: 12),
            
            // TP/SL Section
            _buildTPSLSection(),
            
            const SizedBox(height: 12),
            
            // Available Balance
            _buildBalanceInfo(),
            
            const SizedBox(height: 16),
            
            // Buy/Sell Button
            _buildTradeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBuySellToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isBuy = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _isBuy ? AppTheme.success : AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  'Buy',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isBuy ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isBuy = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: !_isBuy ? AppTheme.error : AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  'Sell',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !_isBuy ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTypeSelector() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.textTertiary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceGray,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _orderType,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool showButtons = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (showButtons)
            GestureDetector(
              onTap: () {
                // Decrease value
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.remove,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
                TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    filled: false,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          if (showButtons)
            GestureDetector(
              onTap: () {
                // Increase value
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.textPrimary,
            inactiveTrackColor: AppTheme.borderLight,
            thumbColor: AppTheme.textPrimary,
            overlayColor: AppTheme.textPrimary.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: _sliderValue,
            onChanged: (value) => setState(() => _sliderValue = value),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSliderMarker(0),
            _buildSliderMarker(0.25),
            _buildSliderMarker(0.5),
            _buildSliderMarker(0.75),
            _buildSliderMarker(1.0),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderMarker(double position) {
    final isActive = _sliderValue >= position;
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppTheme.textPrimary : AppTheme.borderLight,
        border: Border.all(
          color: isActive ? AppTheme.textPrimary : AppTheme.borderLight,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildTotalField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total (USDT)',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            '6.056',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTPSLSection() {
    return Column(
      children: [
        // TP/SL Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showTPSL = !_showTPSL),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _showTPSL ? AppTheme.primaryYellow : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _showTPSL ? AppTheme.primaryYellow : AppTheme.borderLight,
                      ),
                    ),
                    child: _showTPSL
                        ? const Icon(Icons.check, size: 14, color: AppTheme.textPrimary)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'TP/SL',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => setState(() => _isAdvanced = !_isAdvanced),
              child: Row(
                children: [
                  Text(
                    'Advanced',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Icon(
                    _isAdvanced ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        if (_showTPSL) ...[
          const SizedBox(height: 12),
          
          // Take Profit
          _buildTPSLInput('Take Profit', 'TP Limit (USDT)', _tpController),
          
          const SizedBox(height: 8),
          
          // Stop Loss
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stop Loss',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              _buildTPSLInput('', 'SL Trigger (USDT)', _slTriggerController),
              const SizedBox(height: 4),
              _buildTPSLInput('', 'SL Limit', _slLimitController),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Iceberg
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.borderLight),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Iceberg',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTPSLInput(String label, String placeholder, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.remove, size: 14, color: AppTheme.textSecondary),
          Expanded(
            child: Column(
              children: [
                Text(
                  placeholder,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: AppTheme.textSecondary,
                  ),
                ),
                TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    filled: false,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.add, size: 14, color: AppTheme.textSecondary),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo() {
    return Column(
      children: [
        _buildBalanceRow('Avbl', '12.49272484 USDT', showPlus: true),
        _buildBalanceRow('Max Buy', '0.0001 BTC'),
        _buildBalanceRow('Est. Fee', '0.00000003 BTC'),
      ],
    );
  }

  Widget _buildBalanceRow(String label, String value, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              if (showPlus) ...[
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 14, color: AppTheme.textSecondary),
              ],
            ],
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (showPlus) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 10, color: AppTheme.textPrimary),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _isBuy ? AppTheme.success : AppTheme.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          _isBuy ? 'Buy BTC' : 'Sell BTC',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
