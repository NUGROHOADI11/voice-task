import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toFormattedString({String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(this);
  }
}