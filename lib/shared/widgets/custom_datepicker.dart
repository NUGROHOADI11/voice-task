import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<DateTime?> buildDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? minDate,
  DateTime? maxDate,
}) async {
  DateTime? pickedDate;

  DateTime tempPickedDate = initialDate;

  await showCupertinoModalPopup<DateTime?>(
    context: context,
    builder: (BuildContext builderContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: 250.h,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              children: [
                Container(
                  height: 50.h,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: CupertinoColors.separator,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: const Icon(
                          CupertinoIcons.clear,
                          color: CupertinoColors.black,
                          size: 18,
                        ),
                        onPressed: () => Navigator.of(builderContext).pop(),
                      ),
                      CupertinoButton(
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontSize: 18.sp,
                          ),
                        ),
                        onPressed: () =>
                            Navigator.of(builderContext).pop(tempPickedDate),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: initialDate,
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: minDate ?? DateTime(1900),
                    maximumDate: maxDate ?? DateTime(2100),
                    onDateTimeChanged: (DateTime date) {
                      tempPickedDate = date;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  ).then((value) {
    pickedDate = value;
  });

  return pickedDate;
}
