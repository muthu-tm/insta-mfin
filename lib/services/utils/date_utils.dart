class DateUtils {
  
  static List<DateTime> getDaysInBeteween(
      DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];

    for (int index = 0; index <= endDate.difference(startDate).inDays; index++) {
      days.add(startDate.add(Duration(days: index)));
    }
    return days;
  }
}
