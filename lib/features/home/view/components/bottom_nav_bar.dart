import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import 'nav_bar_item.dart';

class BottomNavBar extends StatelessWidget {
  final HomeController controller;

  final double navBarHiddenOffset;

  const BottomNavBar({
    super.key,
    required this.controller,
    required this.navBarHiddenOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        bottom: controller.isNavBarVisible.value ? 0 : -navBarHiddenOffset,
        left: 0,
        right: 0,
        child: Obx(() => Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white10,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavBarItem(
                    icon: Icons.home,
                    index: 0,
                    currentIndex: controller.currentIndex.value,
                    onPressed: () => controller.changePage(0),
                  ),
                  NavBarItem(
                    icon: Icons.note_outlined,
                    index: 1,
                    currentIndex: controller.currentIndex.value,
                    onPressed: () => controller.changePage(1),
                  ),
                  const SizedBox(width: 40),
                  NavBarItem(
                    icon: Icons.notes,
                    index: 2,
                    currentIndex: controller.currentIndex.value,
                    onPressed: () => controller.changePage(2),
                  ),
                  NavBarItem(
                    icon: Icons.person,
                    index: 3,
                    currentIndex: controller.currentIndex.value,
                    onPressed: () => controller.changePage(3),
                  ),
                ],
              ),
            )),
      );
    });
  }
}
