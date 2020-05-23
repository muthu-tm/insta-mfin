enum CollectionStatus { Upcoming, Paid, PaidLate, Current, Pending }

extension CollectionStatusExtension on CollectionStatus {
  int get name {
    switch (this) {
      case CollectionStatus.Upcoming:
        return 0;
        break;
      case CollectionStatus.Paid:
        return 1;
        break;
      case CollectionStatus.PaidLate:
        return 2;
        break;
      case CollectionStatus.Current:
        return 3;
        break;
      case CollectionStatus.Pending:
        return 4;
        break;
      default:
        return 0;
    }
  }
}
