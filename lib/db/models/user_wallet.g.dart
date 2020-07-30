part of 'user_wallet.dart';

UserWallet _$UserWalletFromJson(Map<String, dynamic> json) {
  return UserWallet()
    ..totalAmount = json['total_amount'] as int ?? 0
    ..availableBalance = json['available_balance'] as int ?? 0;
}

Map<String, dynamic> _$UserWalletToJson(UserWallet instance) =>
    <String, dynamic>{
      'total_amount': instance.totalAmount ?? 0,
      'available_balance': instance.availableBalance ?? 0
    };
