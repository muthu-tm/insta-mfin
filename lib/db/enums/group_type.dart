enum GroupByType { Daily, Weekly, Monthly, Yearly }

extension GroupByTypeExtension on GroupByType {
  int get name {
    switch (this) {
      case GroupByType.Daily:
        return 0;
        break;
      case GroupByType.Weekly:
        return 1;
        break;
      case GroupByType.Monthly:
        return 2;
        break;
      case GroupByType.Yearly:
        return 3;
        break;
      default:
        return 0;
    }
  }
}
