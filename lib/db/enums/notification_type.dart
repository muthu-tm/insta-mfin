enum NotificationType { IFIN, General, Promotion, Alert, Customer, Finance, User }

extension NotificationTypeExtension on NotificationType {
  int get name {
    switch (this) {
      case NotificationType.IFIN:
        return 0;
        break;
      case NotificationType.General:
        return 1;
        break;
      case NotificationType.Promotion:
        return 2;
        break;
      case NotificationType.Alert:
        return 3;
        break;
      case NotificationType.Customer:
        return 4;
        break;
      case NotificationType.Finance:
        return 5;
        break;
      case NotificationType.User:
        return 6;
        break;
      default:
        return 1;
    }
  }
}
