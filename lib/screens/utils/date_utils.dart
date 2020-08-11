import 'package:intl/intl.dart';

class DateUtils {
  static DateFormat dateFormatter = new DateFormat('dd-MMM-yyyy');
  static DateFormat dateTimeFormatter = new DateFormat('dd-MMM-yyyy h:mm a');

  static String getFormattedDateFromEpoch(int epoch) {
    return dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(epoch));
  }

  static int getUTCDateEpoch(DateTime dateTime) {
    return DateTime.utc(
            dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0)
        .millisecondsSinceEpoch;
  }

  static String formatDate(DateTime dateTime) {
    if (dateTime == null) {
      return "";
    }

    return dateFormatter.format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    if (dateTime == null) {
      return "";
    }

    return dateTimeFormatter.format(dateTime);
  }

  static DateTime getCurrentUTCDate() {
    DateTime thisInstant = DateTime.now();
    return DateTime.utc(
        thisInstant.year, thisInstant.month, thisInstant.day, 0, 0, 0, 0, 0);
  }

  static DateTime getCurrentDate() {
    DateTime thisInstant = DateTime.now();
    return DateTime(
        thisInstant.year, thisInstant.month, thisInstant.day, 0, 0, 0, 0, 0);
  }

  static List<int> getDaysInBeteween(
      DateTime startDate, DateTime endDate) {
    List<int> days = [];

    for (int index = 0;
        index <= endDate.difference(startDate).inDays;
        index++) {
      DateTime newDate = startDate.add(Duration(days: index));

      days.add(
          DateTime.utc(newDate.year, newDate.month, newDate.day, 0, 0, 0, 0, 0)
              .millisecondsSinceEpoch);
    }
    return days;
  }
}
