enum CustomerStatus { New, Active, Pending, Closed, Block }

extension CustomerStatusExtension on CustomerStatus {
  int get name {
    switch (this) {
      case CustomerStatus.New:
        return 0;
        break;
      case CustomerStatus.Active:
        return 1;
        break;
      case CustomerStatus.Pending:
        return 2;
        break;
      case CustomerStatus.Closed:
        return 3;
        break;
      case CustomerStatus.Block:
        return 4;
        break;
      default:
        return 0;
    }
  }
}
