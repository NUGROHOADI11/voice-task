import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:voice_task/utils/extensions/date_formatter.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';

Widget buildTaskTile({
  required String taskId,
  required Task task,
  required String title,
  required String desc,
  DateTime? startDate,
  DateTime? dueDate,
  required String status,
  required String priority,
  required bool isPinned,
  bool? showPin = true,
  required Color backgroundColor,
  required VoidCallback onTap,
  required VoidCallback onComplete,
  required VoidCallback onDelete,
  bool? onHold,
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
      child: Slidable(
        key: ValueKey(taskId),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          dismissible: DismissiblePane(onDismissed: onComplete),
          children: [
            SlidableAction(
              onPressed: (context) => onComplete(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Complete'.tr,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          dismissible: DismissiblePane(onDismissed: onDelete),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete'.tr,
            ),
          ],
        ),
        child: Container(
          color: backgroundColor,
          child: InkWell(
            onLongPress: (onHold ?? false)
                ? () => _showOptionsDialog(controller, taskId, task)
                : null,
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
                      if (showPin ?? true)
                        InkWell(
                          onTap: () {
                            controller.togglePinStatus(taskId, task);
                          },
                          child: isPinned
                              ? Icon(
                                  Icons.push_pin,
                                  size: 20.sp,
                                )
                              : Icon(
                                  Icons.push_pin_outlined,
                                  size: 20.sp,
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
                    alignment: Alignment.topRight,
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

void _showOptionsDialog(controller, String taskId, Task task) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Hidden Task'.tr),
        content: Text('Are you sure you want to hide this task?'.tr),
        actions: <Widget>[
          TextButton(
            child:
                Text('Cancel'.tr, style: const TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Hide'.tr, style: const TextStyle(color: Colors.red)),
            onPressed: () {
              controller.hideTask(taskId, task);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
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
