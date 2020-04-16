import 'package:intl/intl.dart';

class DateUtils {
  static DateFormat dateFormatter = new DateFormat('dd-MMM-yyyy');

  static String getCurrentFormattedDate() {
    return dateFormatter.format(DateTime.now());
  }

  static String formatDate(DateTime dateTime) {
    return dateFormatter.format(dateTime);
  }
}
