enum TenureType { Daily, Weekly, Monthly, OnWeekDays, OnWeekEnds }

extension TenureTypeExtension on TenureType {
  int get name {
    switch (this) {
      case TenureType.Daily:
        return 0;
        break;
      case TenureType.Weekly:
        return 1;
        break;
      case TenureType.Monthly:
        return 2;
        break;
      case TenureType.OnWeekDays:
        return 3;
        break;
      case TenureType.OnWeekEnds:
        return 4;
        break;
      default:
        return 0;
    }
  }
}
