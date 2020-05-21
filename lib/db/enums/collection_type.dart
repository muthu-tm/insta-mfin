enum CollectionType { Collection, DocCharge, Surcharge, Closing }

extension TransactionTypeExtension on CollectionType {
  int get name {
    switch (this) {
      case CollectionType.Collection:
        return 0;
        break;
      case CollectionType.DocCharge:
        return 1;
        break;
      case CollectionType.Surcharge:
        return 2;
        break;
      case CollectionType.Closing:
        return 3;
        break;
      default:
        return 0;
    }
  }
}
