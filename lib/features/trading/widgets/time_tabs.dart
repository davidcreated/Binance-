import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class TimeTabs extends StatefulWidget {
  const TimeTabs({super.key});

  @override
  State<TimeTabs> createState() => _TimeTabsState();
}

class _TimeTabsState extends State<TimeTabs> {
  int _selectedIndex = 5; // 30m selected by default
  final List<String> _times = ['Time', '15m', '1h', '4h', '1d', '30m', 'Depth'];

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
              itemCount: _times.length,
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
                      _times[index],
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
          const SizedBox(width: 8),
          // Grid Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.darkTextSecondary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.grid_view,
              color: AppTheme.darkTextSecondary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
