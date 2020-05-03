enum PaymentStatus { New, Active, Pending, Closed }

extension PaymentStatusExtension on PaymentStatus {
  int get name {
    switch (this) {
      case PaymentStatus.New:
        return 0;
        break;
      case PaymentStatus.Active:
        return 1;
        break;
      case PaymentStatus.Pending:
        return 2;
        break;
      case PaymentStatus.Closed:
        return 3;
        break;
      default:
        return 0;
    }
  }
}
