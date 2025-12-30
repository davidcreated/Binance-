import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/crypto_icon.dart';

class ETFFlowCard extends StatefulWidget {
  const ETFFlowCard({super.key});

  @override
  State<ETFFlowCard> createState() => _ETFFlowCardState();
}

class _ETFFlowCardState extends State<ETFFlowCard>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _controller;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _chartAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Selector
          Row(
            children: [
              _buildTab('BTC ETF', 0),
              const SizedBox(width: 12),
              _buildTab('ETH ETF', 1),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Price Row
          Row(
            children: [
              CryptoIcon(
                imageUrl: AppConstants.btcIconUrl,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                '109,006.93',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.successLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_drop_up,
                      color: AppTheme.success,
                      size: 16,
                    ),
                    Text(
                      '0.85%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Date', '2025/10/22'),
              _buildStat('ETF Net Outflow', '-\$101.40M', isNegative: true),
              _buildStat('Total Net Assets', '\$154.11B'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Chart
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return SizedBox(
                height: 120,
                child: Opacity(
                  opacity: _chartAnimation.value,
                  child: _buildChart(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceGray : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.borderLight,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {bool isNegative = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isNegative ? AppTheme.error : AppTheme.textPrimary,
              ),
            ),
            if (isNegative) ...[
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildChart() {
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.3,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.borderLight,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                String label = '';
                if (value == 0.6) label = '0.6B';
                if (value == 0.9) label = '0.9B';
                if (value == 1.2) label = '1.2B';
                return Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.textTertiary,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _generateBarGroups(),
        maxY: 1.5,
        minY: 0,
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    final data = [
      0.7, 0.6, 0.65, 0.8, 0.75, 0.85, 0.9, 1.1, 0.8, 0.75, 0.7, 0.8, 0.85
    ];

    return List.generate(data.length, (index) {
      final isHighlight = index == 7;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index] * _chartAnimation.value,
            color: isHighlight ? AppTheme.success : AppTheme.textTertiary.withOpacity(0.3),
            width: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }
}
