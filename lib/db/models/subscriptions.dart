import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
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
  @JsonKey(name: 'payment_id', nullable: true)
  String paymentID;
  @JsonKey(name: 'purchase_id', nullable: true)
  String purchaseID;
  @JsonKey(name: 'recently_paid', nullable: true)
  int recentlyPaid;
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

  CollectionReference getCollectionRef() {
    return getUser().getFinanceDocReference().collection('subscriptions');
  }

  User getUser() {
    return super.user;
  }

  Map<String, dynamic> getSubscriptionJSON(String pDocID, int tAmount,
      sValidity, sSmsCredit, cValidity, cSmsCredit, String payID) {
    UserPrimary _primary = user.primary;
    return {
      "payment_id": payID,
      "purchase_id": pDocID,
      "recently_paid": tAmount,
      "finance_id": _primary.financeID,
      "branch_name": _primary.branchName,
      "sub_branch_name": _primary.subBranchName,
      "chit": {
        "valid_till":
            DateUtils.getUTCDateEpoch(DateTime.now()) + (cValidity * 86400000),
        "notes": "",
        "available_sms_credit": cSmsCredit,
        "type": 1,
      },
      "service": {
        "valid_till":
            DateUtils.getUTCDateEpoch(DateTime.now()) + (sValidity * 86400000),
        "notes": "",
        "available_sms_credit": sSmsCredit,
        "type": 0,
      },
      "created_at": DateTime.now(),
      "updated_at": DateTime.now()
    };
  }

  Future<Subscriptions> getSubscriptions() async {
    try {
      QuerySnapshot subSnap = await getCollectionRef().getDocuments();

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

  Stream<QuerySnapshot> streamSubscriptions() {
    try {
      return getCollectionRef().snapshots();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> updateSuccessStatus(
      String purchaseID, List<Plans> plans, int tAmount, String payID) async {
    try {
      QuerySnapshot subSnap = await getCollectionRef().getDocuments();

      int cVal = 0;
      int sVal = 0;
      int sSMS = 0;
      int cSMS = 0;
      plans.forEach((p) {
        if (p.type == "SERVICE") {
          sVal += p.validFor;
          sSMS += p.smsCredits;
        } else if (p.type == "CHIT") {
          cVal += p.validFor;
          cSMS += p.smsCredits;
        } else if (p.type == "SERVICE SMS") {
          sSMS += p.smsCredits;
        } else if (p.type == "CHIT SMS") {
          cSMS += p.smsCredits;
        }
      });

      WriteBatch bWrite = Model.db.batch();
      if (subSnap.documents.isEmpty) {
        bWrite.setData(
            getCollectionRef().document(),
            getSubscriptionJSON(
                purchaseID, tAmount, sVal, sSMS, cVal, cSMS, payID));

        Map<String, dynamic> purchaseJSON = {
          "payment_id": payID,
          "total_paid": tAmount,
          "is_success": true,
          "updated_at": DateTime.now()
        };

        bWrite.updateData(Model.db.collection('purchases').document(purchaseID),
            purchaseJSON);
      } else {
        DocumentSnapshot snap = subSnap.documents[0];
        Subscriptions sub = Subscriptions.fromJson(snap.data);
        int today = DateUtils.getUTCDateEpoch(DateTime.now());
        int finValidTill =
            (sub.service.validTill < today) ? today : sub.service.validTill;
        int chitValidTill =
            (sub.chit.validTill < today) ? today : sub.chit.validTill;
            
        Map<String, dynamic> subJSON = {
          "payment_id": payID,
          "purchase_id": purchaseID,
          "recently_paid": tAmount,
          "chit.valid_till": chitValidTill + (cVal * 86400000),
          "chit.available_sms_credit": sub.chit.smsCredit + cSMS,
          "service.valid_till": finValidTill + (sVal * 86400000),
          "service.available_sms_credit": sub.service.smsCredit + sSMS,
          "updated_at": DateTime.now()
        };

        bWrite.updateData(snap.reference, subJSON);
        Map<String, dynamic> purchaseJSON = {
          "payment_id": payID,
          "total_paid": tAmount,
          "is_success": true,
          "updated_at": DateTime.now()
        };

        bWrite.updateData(Model.db.collection('purchases').document(purchaseID),
            purchaseJSON);
      }

      await bWrite.commit();
      await UserController().refreshCacheSubscription();
      return true;
    } catch (err) {
      throw err;
    }
  }
}
