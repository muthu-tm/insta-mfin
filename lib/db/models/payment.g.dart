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
    ..cusomterNumber = json['customer_number'] as int
    ..dateOfPayment = json['date_of_payment'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp))
    ..totalAmount = json['total_amount'] as int
    ..principalAmount = json['principal_amount'] as int
    ..docCharge = json['doc_charge'] as int
    ..surcharge = json['surcharge'] as int
    ..totalPaid = json['total_paid'] as int
    ..tenure = json['tenure'] as int
    ..tenureType = json['tenure_type'] as int
    ..interestRate = (json['interest_rate'] as num)?.toDouble()
    ..collectionAmount = json['collection_amount'] as int
    ..givenBy = json['given_by'] as String
    ..givenTo = json['given_to'] as String
    ..status = json['status'] as int
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
      'customer_number': instance.cusomterNumber,
      'date_of_payment':
          instance.dateOfPayment == null ? '' : instance.dateOfPayment,
      'total_amount': instance.totalAmount,
      'principal_amount': instance.principalAmount,
      'doc_charge': instance.docCharge == null ? 0 : instance.docCharge,
      'surcharge': instance.surcharge == null ? 0 : instance.surcharge,
      'total_paid': instance.totalPaid == null ? 0 : instance.totalPaid,
      'tenure': instance.tenure,
      'tenure_type': instance.tenureType,
      'interest_rate':
          instance.interestRate == null ? 0 : instance.interestRate,
      'collection_amount': instance.collectionAmount,
      'given_by': instance.givenBy == null ? '' : instance.givenBy,
      'given_to': instance.givenTo == null ? '' : instance.givenTo,
      'status': instance.status,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
