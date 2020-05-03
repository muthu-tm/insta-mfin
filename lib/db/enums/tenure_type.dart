enum TenureType { Daily, Weekly, Monthly, Yearly }

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
      case TenureType.Yearly:
        return 3;
        break;
      default:
        return 0;
    }
  }
}
