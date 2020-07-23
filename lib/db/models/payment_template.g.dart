part of 'payment_template.dart';

PaymentTemplate _$PaymentTemplateFromJson(Map<String, dynamic> json) {
  return PaymentTemplate()
    ..name = json['template_name'] as String
    ..totalAmount = json['total_amount'] as int
    ..principalAmount = json['principal_amount'] as int
    ..docCharge = json['doc_charge'] as int
    ..surcharge = json['surcharge'] as int
    ..tenure = json['tenure'] as int
    ..collectionMode = json['collection_mode'] as int
    ..collectionDays = (json['collection_days'] as List)
            ?.map((e) => e == null ? null : e as int)
            ?.toList() ??
        []
    ..collectionAmount = json['collection_amount'] as int
    ..interestAmount = json['interest_amount'] as int
    ..addedBy = json['added_by'] as int
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp))
    ..updatedAt = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['updated_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$PaymentTemplateToJson(PaymentTemplate instance) =>
    <String, dynamic>{
      'template_name': instance.name,
      'total_amount': instance.totalAmount ?? 0,
      'principal_amount': instance.principalAmount ?? 0,
      'doc_charge': instance.docCharge ?? 0,
      'surcharge': instance.surcharge ?? 0,
      'tenure': instance.tenure ?? 0,
      'collection_mode': instance.collectionMode ?? 0,
      'collection_days': instance.collectionDays,
      'collection_amount': instance.collectionAmount ?? 0,
      'interest_amount': instance.interestAmount ?? 0,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
