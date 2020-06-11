// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..financeID = json['finance_id'] as String
    ..paymentID = json['payment_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..customerNumber = json['customer_number'] as int
    ..dateOfPayment = json['date_of_payment'] as int
    ..collectionStartsFrom = json['collection_starts_from'] as int
    ..closedDate = json['closed_date'] as int
    ..totalAmount = json['total_amount'] as int
    ..principalAmount = json['principal_amount'] as int
    ..docCharge = json['doc_charge'] as int
    ..surcharge = json['surcharge'] as int
    ..tenure = json['tenure'] as int
    ..collectionMode = json['collection_mode'] as int
    ..collectionDay = json['collection_day'] as int
    ..interestRate = (json['interest_rate'] as num)?.toDouble()
    ..collectionAmount = json['collection_amount'] as int
    ..isSettled = json['is_settled'] as bool
    ..givenBy = json['given_by'] as String
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
      'payment_id': instance.paymentID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'customer_number': instance.customerNumber,
      'date_of_payment': instance.dateOfPayment,
      'collection_starts_from': instance.collectionStartsFrom,
      'closed_date': instance.closedDate,
      'total_amount': instance.totalAmount,
      'principal_amount': instance.principalAmount,
      'doc_charge': instance.docCharge == null ? 0 : instance.docCharge,
      'surcharge': instance.surcharge == null ? 0 : instance.surcharge,
      'tenure': instance.tenure,
      'collection_mode': instance.collectionMode,
      'collection_day': instance.collectionDay,
      'interest_rate':
          instance.interestRate == null ? 0 : instance.interestRate,
      'collection_amount': instance.collectionAmount,
      'is_settled': instance.isSettled,
      'given_by': instance.givenBy == null ? '' : instance.givenBy,
      'notes': instance.notes == null ? '' : instance.notes,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
