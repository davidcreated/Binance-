import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  
  final List<NavItem> _items = [
    NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Markets'),
    NavItem(icon: Icons.swap_horiz, activeIcon: Icons.swap_horiz, label: 'Trade'),
    NavItem(icon: Icons.candlestick_chart_outlined, activeIcon: Icons.candlestick_chart, label: 'Futures'),
    NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: 'Wallets'),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    
    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTap(int index) {
    if (index == widget.selectedIndex) return;
    
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Animate the tapped item
    _controllers[index].forward().then((_) {
      _controllers[index].reverse();
    });
    
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == widget.selectedIndex;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => _handleTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedBuilder(
                    animation: _scaleAnimations[index],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isSelected ? 1.0 : _scaleAnimations[index].value,
                        child: child,
                      );
                    },
                    child: _NavBarItem(
                      item: item,
                      isSelected: isSelected,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon with animated container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppTheme.primaryYellow.withOpacity(0.2) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isSelected ? item.activeIcon : item.icon,
              key: ValueKey(isSelected),
              size: 24,
              color: isSelected 
                  ? AppTheme.textPrimary 
                  : AppTheme.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        
        // Label
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected 
                ? AppTheme.textPrimary 
                : AppTheme.textSecondary,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
