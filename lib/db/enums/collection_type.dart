enum CollectionType { Collection, DocCharge, Surcharge, Settlement, Penalty, Commission }

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
      case CollectionType.Settlement:
        return 3;
        break;
      case CollectionType.Penalty:
        return 4;
        break;
      case CollectionType.Commission:
        return 5;
        break;
      default:
        return 0;
    }
  }
}
