import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final VoidCallback onPressed;

  const NavBarItem({
    super.key, 
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r), 
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
          size: 24.sp, 
        ),
      ),
    );
  }
}