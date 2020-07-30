import 'package:json_annotation/json_annotation.dart';

part 'user_wallet.g.dart';

@JsonSerializable(explicitToJson: true)
class UserWallet {
  
  @JsonKey(name: 'total_amount', defaultValue: 0)
  int totalAmount;
  @JsonKey(name: 'available_balance', defaultValue: 0)
  int availableBalance;

  factory UserWallet.fromJson(Map<String, dynamic> json) => _$UserWalletFromJson(json);
  Map<String, dynamic> toJson() => _$UserWalletToJson(this);

  UserWallet();
}