import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscriptions.g.dart';

@JsonSerializable()
class Subscriptions extends Model {
  @JsonKey(name: 'user_number', nullable: true)
  int userNumber;
  @JsonKey(name: 'guid', nullable: true)
  String guid;
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'recently_paid', nullable: true)
  int recentlyPaid;
  @JsonKey(name: 'payment_id', nullable: true)
  String paymentID;
  @JsonKey(name: 'purchase_id', nullable: true)
  String purchaseID;
  @JsonKey(name: 'available_sms_credit', nullable: true)
  int smsCredit;
  @JsonKey(name: 'chit_valid_till', nullable: true)
  int chitValidTill;
  @JsonKey(name: 'finance_valid_till', nullable: true)
  int finValidTill;
  @JsonKey(name: 'notes', nullable: true)
  String notes;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Subscriptions();

  factory Subscriptions.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionsToJson(this);

  CollectionReference getCollectionRef() {
    return user.getDocumentReference().collection('subscriptions');
  }

  Map<String, dynamic> getSubscriptionJSON(String pDocID, int tAmount,
      sValidity, sSmsCredit, cValidity, cSmsCredit, String payID) {
    return {
      "user_number": user.mobileNumber,
      "guid": user.guid,
      "payment_id": payID,
      "purchase_id": pDocID,
      "recently_paid": tAmount,
      "available_sms_credit": cSmsCredit + sSmsCredit,
      "finance_id": user.primary.financeID,
      "chit_valid_till":
          DateUtils.getUTCDateEpoch(DateTime.now()) + (cValidity * 86400000),
      "notes": "",
      "finance_valid_till":
          DateUtils.getUTCDateEpoch(DateTime.now()) + (sValidity * 86400000),
      "created_at": DateTime.now(),
      "updated_at": DateTime.now()
    };
  }

  Stream<QuerySnapshot> streamSubscriptions() {
    try {
      return getCollectionRef()
          .where('finance_id', isEqualTo: user.primary.financeID)
          .snapshots();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> updateSuccessStatus(String purchaseID, List<Plans> plans,
      int tAmount, String payID, int wAmount) async {
    try {
      QuerySnapshot subSnap = await getCollectionRef()
          .where('finance_id', isEqualTo: user.primary.financeID)
          .getDocuments();

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
            (sub.finValidTill < today) ? today : sub.finValidTill;
        int chitValidTill =
            (sub.chitValidTill < today) ? today : sub.chitValidTill;

        Map<String, dynamic> subJSON = {
          "payment_id": payID,
          "purchase_id": purchaseID,
          "recently_paid": tAmount,
          "chit_valid_till": chitValidTill + (cVal * 86400000),
          "available_sms_credit": sub.smsCredit + cSMS + sSMS,
          "finance_valid_till": finValidTill + (sVal * 86400000),
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

      if (wAmount > 0) {
        Map<String, dynamic> uData = await user.getByID(user.getID());
        User _u = User.fromJson(uData);
        int tAmount = 0;
        int aAmount = 0;
        if (_u.wallet != null && _u.wallet.totalAmount != null) {
          tAmount = _u.wallet.totalAmount;
          aAmount = _u.wallet.availableBalance - wAmount;
        }

        var data = {
          'wallet': {'total_amount': tAmount, 'available_balance': aAmount}
        };
        bWrite.updateData(user.getDocumentReference(), data);
      }

      await bWrite.commit();
      return true;
    } catch (err) {
      throw err;
    }
  }
}
