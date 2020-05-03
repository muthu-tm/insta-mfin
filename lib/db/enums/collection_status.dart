enum CollectionStatus { Upcoming, Paid, Pending }

extension CollectionStatusExtension on CollectionStatus {
  int get name {
    switch (this) {
      case CollectionStatus.Upcoming:
        return 0;
        break;
      case CollectionStatus.Paid:
        return 1;
        break;
      case CollectionStatus.Pending:
        return 2;
        break;
      default:
        return 0;
    }
  }
}
