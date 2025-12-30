import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class DiscoverTabs extends StatefulWidget {
  const DiscoverTabs({super.key});

  @override
  State<DiscoverTabs> createState() => _DiscoverTabsState();
}

class _DiscoverTabsState extends State<DiscoverTabs> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Discover', 'Following', 'Campaign', 'News', 'Ann...'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _tabs[index],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected 
                        ? AppTheme.textPrimary 
                        : AppTheme.textSecondary,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryYellow,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
