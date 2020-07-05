import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_data.g.dart';

@JsonSerializable(explicitToJson: true)
class SubscriptionData {

  @JsonKey(name: 'valid_till', nullable: true)
  int validTill;
  @JsonKey(name: 'notes', nullable: true)
  String notes;
  @JsonKey(name: 'available_sms_credit', nullable: true)
  int smsCredit;
  @JsonKey(name: 'type', nullable: true)
  int type;

  SubscriptionData();

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDataFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionDataToJson(this);


}
