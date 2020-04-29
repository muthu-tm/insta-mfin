enum ActionType {
  UserAdd,
  UserEdit,
  UserDelete,
  PaymentAdd,
  PaymentEdit,
  PaymentDelete,
  CollectionAdd,
  CollectionEdit,
  CollectionDelete,
  ActionNotUpdated
}

extension ActionTypeExtension on ActionType {
  String get name {
    switch (this) {
      case ActionType.UserAdd:
        return "User Added";
        break;
      case ActionType.UserEdit:
        return "User Edited";
        break;
      case ActionType.UserDelete:
        return "User Removed";
        break;
      case ActionType.PaymentAdd:
        return "Payment added";
        break;
      case ActionType.PaymentEdit:
        return "Payment Edited";
        break;
      case ActionType.PaymentDelete:
        return "Payment Removed";
        break;
      case ActionType.CollectionAdd:
        return "Collection Added";
        break;
      case ActionType.CollectionEdit:
        return "Collection Edited";
        break;
      case ActionType.CollectionDelete:
        return "Collection Removed";
        break;
      case ActionType.ActionNotUpdated:
        return "Action not Updated";
        break;
      default:
        return null;
    }
  }
}
