// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..customerNumber = json['customer_number'] as int
    ..dateOfPayment = json['date_of_payment'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['date_of_payment'] as Timestamp))
    ..collectionStartsFrom = json['collection_starts_from'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['collection_starts_from'] as Timestamp))
    ..closingDate = json['closing_date'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['closing_date'] as Timestamp))
    ..totalAmount = json['total_amount'] as int
    ..principalAmount = json['principal_amount'] as int
    ..docCharge = json['doc_charge'] as int
    ..surcharge = json['surcharge'] as int
    ..tenure = json['tenure'] as int
    ..tenureType = json['tenure_type'] as int
    ..collectionDay = json['collection_day'] as int
    ..interestRate = (json['interest_rate'] as num)?.toDouble()
    ..collectionAmount = json['collection_amount'] as int
    ..status = json['status'] as int
    ..givenBy = json['given_by'] as String
    ..givenTo = json['given_to'] as String
    ..notes = json['notes'] as String ?? ''
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

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'customer_number': instance.customerNumber,
      'date_of_payment': instance.dateOfPayment,
      'collection_starts_from': instance.collectionStartsFrom,
      'closing_date': instance.closingDate,
      'total_amount': instance.totalAmount,
      'principal_amount': instance.principalAmount,
      'doc_charge': instance.docCharge == null ? 0 : instance.docCharge,
      'surcharge': instance.surcharge == null ? 0 : instance.surcharge,
      'tenure': instance.tenure,
      'tenure_type': instance.tenureType,
      'collection_day': instance.collectionDay,
      'interest_rate':
          instance.interestRate == null ? 0 : instance.interestRate,
      'collection_amount': instance.collectionAmount,
      'given_by': instance.givenBy == null ? '' : instance.givenBy,
      'given_to': instance.givenTo == null ? '' : instance.givenTo,
      'status': instance.status,
      'notes': instance.notes == null ? '' : instance.notes,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
