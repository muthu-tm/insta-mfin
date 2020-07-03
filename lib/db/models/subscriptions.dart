import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:instamfin/db/models/subscription_data.dart';

part 'subscriptions.g.dart';

@JsonSerializable()
class Subscriptions extends Model {
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'chit', nullable: true)
  SubscriptionData chit;
  @JsonKey(name: 'service', nullable: true)
  SubscriptionData service;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Subscriptions();

  factory Subscriptions.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionsToJson(this);

  User getUser() {
    return super.user;
  }

  Future<Subscriptions> getSubscriptions() async {
    try {
      QuerySnapshot subSnap = await getUser()
          .getFinanceDocReference()
          .collection('subscriptions')
          .getDocuments();

      if (subSnap.documents.isEmpty) {
        throw 'No Subscriptions for this account!';
      } else {
        return Subscriptions.fromJson(subSnap.documents[0].data);
      }
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }
}
