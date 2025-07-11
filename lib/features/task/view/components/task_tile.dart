import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/utils/extensions/date_formatter.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/task_controller.dart';

Widget buildTaskTile({
  required String taskId,
  required String title,
  required String desc,
  DateTime? startDate,
  DateTime? dueDate,
  required String status,
  required String priority,
  required bool isPinned,
  required Color backgroundColor,
  required VoidCallback onTap,
  String? attachmentUrl,
}) {
  final TaskController controller = TaskController.to;

  final bool useWhiteText = backgroundColor == ColorStyle.primary ||
      backgroundColor == ColorStyle.dark ||
      backgroundColor == Colors.black;

  final Color primaryTextColor = useWhiteText ? Colors.white : Colors.black87;
  final Color secondaryTextColor =
      useWhiteText ? Colors.white70 : Colors.grey.shade700;
  final Color subtleIconAndDateColor =
      useWhiteText ? Colors.white70 : Colors.grey.shade600;

  final statusStyle = controller.getStatusStyle(status, secondaryTextColor);
  final priorityStyle =
      controller.getPriorityStyle(priority, secondaryTextColor);

  return Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Dismissible(
        key: Key(taskId),
        background: Container(
          color: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.check, color: Colors.white, size: 24.sp),
              SizedBox(width: 8.w),
              Text('Complete'.tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Delete'.tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 8.w),
              Icon(Icons.delete, color: Colors.white, size: 24.sp),
            ],
          ),
        ),
        onDismissed: (direction) {
          controller.removeTask(taskId);

          if (direction == DismissDirection.endToStart) {
            controller.deleteTask(taskId, title, attachmentUrl: attachmentUrl);
          } else if (direction == DismissDirection.startToEnd) {
            controller.completeTask(taskId, title);
          }
        },
        child: Container(
          color: backgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: primaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _buildMetaChip(
                        icon: statusStyle['icon'],
                        label: status,
                        color: statusStyle['color'],
                      ),
                      SizedBox(width: 8.w),
                      _buildMetaChip(
                        icon: priorityStyle['icon'],
                        label: priority,
                        color: priorityStyle['color'],
                        isPriority: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _buildDateDisplay(
                        startDate, dueDate, subtleIconAndDateColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildMetaChip({
  required IconData icon,
  required String label,
  required Color color,
  bool isPriority = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isPriority ? 13.sp : 12.sp, color: Colors.white),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDateDisplay(
    DateTime? startDate, DateTime? dueDate, Color textColor) {
  final String displayStartDate = startDate?.toFormattedString() ?? '';
  final String displayDueDate = dueDate?.toFormattedString() ?? '';
  String dateText;

  if (displayStartDate.isNotEmpty && displayDueDate.isNotEmpty) {
    dateText = "$displayStartDate - $displayDueDate";
  } else if (displayStartDate.isNotEmpty) {
    dateText = displayStartDate;
  } else if (displayDueDate.isNotEmpty) {
    dateText = displayDueDate;
  } else {
    return const SizedBox.shrink();
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Icon(Icons.calendar_today_outlined, size: 10.sp, color: textColor),
      SizedBox(width: 4.w),
      Text(
        dateText,
        style: TextStyle(
            fontSize: 12.sp, color: textColor, fontWeight: FontWeight.w400),
        textAlign: TextAlign.end,
      ),
    ],
  );
}
