enum NotificationType { MFIN, Promotion, User }

extension NotificationTypeExtension on NotificationType {
  int get name {
    switch (this) {
      case NotificationType.MFIN:
        return 0;
        break;
      case NotificationType.User:
        return 1;
        break;
      case NotificationType.Promotion:
        return 2;
        break;
      default:
        return 1;
    }
  }
}
