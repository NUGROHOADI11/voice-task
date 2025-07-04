import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/task_controller.dart';

Widget buildTaskTile({
  required String taskId,
  required String title,
  required String desc,
  String? startDate,
  String? dueDate,
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
    child: Dismissible(
      key: Key(taskId),
      background: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
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
      ),
      secondaryBackground: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
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
      ),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await TaskController.to
              .deleteTask(taskId, title, attachmentUrl: attachmentUrl);
        } else if (direction == DismissDirection.startToEnd) {
          await controller.completeTask(taskId, title);
        }
      },
      child: Card(
        color: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            ),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
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
                    InkWell(
                        onTap: () =>
                            controller.togglePinStatus(taskId, isPinned),
                        child: Icon(
                            isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            size: 18.sp))
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
                      controller, startDate, dueDate, subtleIconAndDateColor),
                ),
              ],
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

Widget _buildDateDisplay(TaskController controller, String? startDateIso,
    String? dueDateIso, Color textColor) {
  String displayStartDate = controller.formatDate(startDateIso);
  String displayDueDate = controller.formatDate(dueDateIso);
  String dateText;

  if (displayStartDate.isNotEmpty && displayDueDate.isNotEmpty) {
    dateText = "$displayStartDate - $displayDueDate";
  } else if (displayStartDate.isNotEmpty) {
    dateText = displayStartDate;
  } else if (displayDueDate.isNotEmpty) {
    dateText = displayDueDate;
  } else {
    return Text(
      "No dates",
      style: TextStyle(
          fontSize: 12.sp, color: textColor, fontStyle: FontStyle.italic),
      textAlign: TextAlign.end,
    );
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
