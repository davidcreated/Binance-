import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class IndicatorTabs extends StatefulWidget {
  const IndicatorTabs({super.key});

  @override
  State<IndicatorTabs> createState() => _IndicatorTabsState();
}

class _IndicatorTabsState extends State<IndicatorTabs> {
  int _selectedIndex = 5; // VOL selected
  final List<String> _indicators = ['MA', 'EMA', 'BOLL', 'SAR', 'AVL', 'VOL', 'MACD', 'RSI'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _indicators.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Text(
                      _indicators[index],
                      style: GoogleFonts.inter(
                        fontSize: 12,
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
          ),
          // Settings Icon
          const Icon(
            Icons.tune,
            color: AppTheme.darkTextSecondary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
