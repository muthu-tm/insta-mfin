part of 'chit_customers.dart';

ChitCustomers _$ChitCustomersFromJson(Map<String, dynamic> json) {
  return ChitCustomers()
    ..number= json['customer_number'] as int
    ..chits = json['chits'] as int;
}

Map<String, dynamic> _$ChitCustomersToJson(ChitCustomers instance) => <String, dynamic>{
      'customer_number': instance.number,
      'chits': instance.chits,
    };
