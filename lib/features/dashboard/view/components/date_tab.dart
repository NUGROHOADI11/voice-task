import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/styles/color_style.dart';
import '../../controllers/dashboard_controller.dart';

Widget buildDateSelector() {
  final scrollController = ScrollController();
  final controller = DashboardController.to;

  return Obx(() {
    final selectedIndex = controller.selectedDateIndex.value;
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 7));

    final dates = List.generate(15, (index) {
      final date = start.add(Duration(days: index));
      return {
        'day': DateFormat.E(Get.locale.toString()).format(date), 
        'date': date.day.toString(),
        'fullDate': date,
      };
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final todayIndex = dates.indexWhere((element) {
        final date = element['fullDate'] as DateTime;
        return date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
      });

      if (scrollController.hasClients && todayIndex != -1) {
        final itemWidth = 60.w;
        scrollController.jumpTo(todayIndex * itemWidth);
      }
    });

    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index]['fullDate'] as DateTime;
          final isSelected = selectedIndex == index;
          final isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          return _buildDateItem(
            index: index,
            day: dates[index]['day'].toString(),
            dateText: dates[index]['date'].toString(),
            isSelected: isSelected,
            isToday: isToday,
            fullDate: date,
          );
        },
      ),
    );
  });
}

Widget _buildDateItem({
  required int index,
  required String day,
  required String dateText,
  required bool isSelected,
  required bool isToday,
  required DateTime fullDate,
}) {
  return GestureDetector(
    onTap: () {
      if (DashboardController.to.selectedDateIndex.value == index) {
        DashboardController.to.selectedDateIndex.value = null;
        DashboardController.to.selectedDate.value = null;
      } else {
        DashboardController.to.selectedDateIndex.value = index;
        DashboardController.to.selectedDate.value = fullDate;
      }
    },
    child: Container(
      width: 50.w,
      margin: EdgeInsets.only(right: 2.w, left: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? ColorStyle.primary : Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? ColorStyle.black : ColorStyle.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            dateText,
            style: TextStyle(
              color: isSelected ? ColorStyle.black : ColorStyle.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          if (isToday)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: ColorStyle.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    ),
  );
}
