import 'package:intl/intl.dart';

class DateUtils {
  static DateFormat dateFormatter = new DateFormat('dd-MMM-yyyy');

  static String getCurrentFormattedDate() {
    return dateFormatter.format(DateTime.now());
  }

  static String formatDate(DateTime dateTime) {
    if (dateTime == null) {
      return "";
    }

    return dateFormatter.format(dateTime);
  }

  static DateTime getCurrentDate() {
    DateTime thisInstant = DateTime.now();
    return DateTime(
        thisInstant.year, thisInstant.month, thisInstant.day, 5, 30, 0, 0, 0);
  }

  static DateTime getFormattedCurrentDate(DateTime dateTime) {
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, 5, 30, 0, 0, 0);
  }
}
