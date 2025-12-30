import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class OrderBookTabs extends StatefulWidget {
  const OrderBookTabs({super.key});

  @override
  State<OrderBookTabs> createState() => _OrderBookTabsState();
}

class _OrderBookTabsState extends State<OrderBookTabs> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Order Book', 'Trades', 'Network'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == _selectedIndex;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected 
                      ? AppTheme.primaryYellow 
                      : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tab,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected 
                    ? AppTheme.darkTextPrimary 
                    : AppTheme.darkTextSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
