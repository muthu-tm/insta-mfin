enum TransactionType { Collection, DocCharge, Surcharge, Journal, Miscellaneous }

extension TransactionTypeExtension on TransactionType {
  int get name {
    switch (this) {
      case TransactionType.Collection:
        return 0;
        break;
      case TransactionType.DocCharge:
        return 1;
        break;
      case TransactionType.Surcharge:
        return 2;
        break;
      case TransactionType.Journal:
        return 3;
        break;
      case TransactionType.Miscellaneous:
        return 3;
        break;
      default:
        return 0;
    }
  }
}
