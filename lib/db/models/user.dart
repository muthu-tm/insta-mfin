import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/db/models/user_wallet.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/db/models/user_referees.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/account_preferences.dart';
part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Model {
  static CollectionReference _userCollRef = Model.db.collection("users");

  @JsonKey(name: 'guid', nullable: false)
  String guid;
  @JsonKey(name: 'user_name', defaultValue: "")
  String name;
  @JsonKey(name: 'mobile_number', nullable: false)
  int mobileNumber;
  @JsonKey(name: 'country_code', defaultValue: 91)
  int countryCode;
  @JsonKey(name: 'referrer_number', nullable: false)
  int referrerNumber;
  @JsonKey(name: 'emailID', defaultValue: "")
  String emailID;
  @JsonKey(name: 'password', nullable: false)
  String password;
  @JsonKey(name: 'gender', defaultValue: "")
  String gender;
  @JsonKey(name: 'profile_path_org', defaultValue: "")
  String profilePathOrg;
  @JsonKey(name: 'profile_path', defaultValue: "")
  String profilePath;
  @JsonKey(name: 'date_of_birth', defaultValue: "")
  int dateOfBirth;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'preferences')
  UserPreferences preferences;
  @JsonKey(name: 'primary')
  UserPrimary primary;
  @JsonKey(name: 'wallet')
  UserWallet wallet;
  @JsonKey(name: 'last_signed_in_at', nullable: true)
  DateTime lastSignInTime;
  @JsonKey(name: 'is_active', defaultValue: true)
  bool isActive;
  @JsonKey(name: 'deactivated_at', nullable: true)
  int deactivatedAt;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  AccountPreferences accPreferences;
  int financeSubscription;
  int chitSubscription;

  User();

  setGuid(String uid) {
    this.guid = uid;
  }

  setPassword(String password) {
    this.password = password;
  }

  setGender(String gender) {
    this.gender = gender;
  }

  setEmailID(String emailID) {
    this.emailID = emailID;
  }

  setName(String name) {
    this.name = name;
  }

  setDOB(DateTime date) {
    this.dateOfBirth = DateUtils.getUTCDateEpoch(date);
  }

  setLastSignInTime(DateTime dateTime) {
    this.lastSignInTime = dateTime;
  }

  setProfilePathOrg(String displayPath) {
    this.profilePathOrg = displayPath;
  }

  setPrimary(UserPrimary primary) {
    this.primary = primary;
  }

  setAddress(Address address) {
    this.address = address;
  }

  setPreferences(UserPreferences preferences) {
    this.preferences = preferences;
  }

  String getProfilePicPath() {
    if (this.profilePath != null && this.profilePath != "")
      return this.profilePath;
    else if (this.profilePathOrg != null && this.profilePathOrg != "")
      return this.profilePathOrg;
    else
      return "";
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  CollectionReference getCollectionRef() {
    return _userCollRef;
  }

  DocumentReference getDocumentReference() {
    return _userCollRef.document(getID());
  }

  String getID() {
    return this.countryCode.toString() + this.mobileNumber.toString();
  }

  int getIntID() {
    return int.parse(
        this.countryCode.toString() + this.mobileNumber.toString());
  }

  Stream<DocumentSnapshot> streamUserData() {
    return getDocumentReference().snapshots();
  }

  Future<User> create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.isActive = true;

    await super.add(this.toJson());

    return this;
  }

  DocumentReference getFinanceDocReference() {
    if (this.primary.subBranchName != "") {
      return SubBranch().getDocumentReference(this.primary.financeID,
          this.primary.branchName, this.primary.subBranchName);
    } else if (this.primary.branchName != "") {
      return Branch().getDocumentReference(
          this.primary.financeID, this.primary.branchName);
    } else {
      return Finance().getDocumentRef(this.primary.financeID);
    }
  }

  Future updatePlatformDetails(Map<String, dynamic> data) async {
    this.update(data);
  }

  Future<void> claimRegistrationBonus(int bonus) async {
    try {
      // QuerySnapshot snap = await UserReferees()
      //     .getCollectionRef(getID())
      //     .where('type', isEqualTo: 0)
      //     .getDocuments();

      // if (snap.documents.isNotEmpty) {
      //   throw 'Already you have claimed your Registration Bonus!';
      // } else {
      DocumentReference userDocRef = getDocumentReference();

      try {
        Map<String, dynamic> regData = {
          "user_number": this.mobileNumber,
          "guid": this.guid,
          "amount": bonus,
          "type": 0,
          "registered_at": DateUtils.getUTCDateEpoch(this.createdAt),
          "created_at": DateTime.now()
        };

        await Model.db.runTransaction(
          (tx) {
            return tx.get(userDocRef).then(
              (doc) async {
                User _u = User.fromJson(doc.data);
                int tAmount = bonus;
                int aAmount = bonus;
                if (_u.wallet != null && _u.wallet.totalAmount != null) {
                  tAmount += _u.wallet.totalAmount;
                  aAmount += _u.wallet.availableBalance;
                }

                Map<String, dynamic> data = {
                  'wallet': {
                    'total_amount': tAmount,
                    'available_balance': aAmount
                  }
                };

                txCreate(
                    tx,
                    UserReferees().getCollectionRef(getID()).document(),
                    regData);
                txUpdate(tx, userDocRef, data);
              },
            );
          },
        );
      } catch (err) {
        print("Transaction Error Claiming Bonus" + err.toString());
        throw err;
      }
      // }
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateReferralCode(int referrerNumber, int bonus) async {
    try {
      WriteBatch bWrite = Model.db.batch();
      var userJSON = await getByID(referrerNumber.toString());

      if (userJSON == null)
        throw 'Error, Referrer not Found!';
      else {
        User referrer = User.fromJson(userJSON);
        Map<String, dynamic> referrerData = {
          "user_number": this.mobileNumber,
          "guid": this.guid,
          "amount": bonus,
          "type": 1,
          "registered_at": DateUtils.getUTCDateEpoch(this.createdAt),
          "created_at": DateTime.now()
        };

        int tAmount = bonus;
        int aAmount = bonus;
        if (referrer.wallet != null && referrer.wallet.totalAmount != null) {
          tAmount += referrer.wallet.totalAmount;
          aAmount += referrer.wallet.availableBalance;
        }

        Map<String, dynamic> data = {
          'wallet': {'total_amount': tAmount, 'available_balance': aAmount}
        };

        bWrite.updateData(referrer.getDocumentReference(), data);
        bWrite.setData(
            UserReferees().getCollectionRef(referrer.getID()).document(),
            referrerData);
      }
      bWrite.updateData(
          this.getDocumentReference(), {'referrer_number': referrerNumber});
      await bWrite.commit();

      cachedLocalUser.referrerNumber = referrerNumber;
    } catch (err) {
      throw err;
    }
  }

  Future updatePrimaryDetails(
      String financeID, String branchName, String subBranchName) async {
    var data = {
      'primary': {
        'finance_id': financeID,
        'branch_name': branchName,
        'sub_branch_name': subBranchName
      }
    };
    // get batch instance
    WriteBatch bWrite = Model.db.batch();

    Subscriptions sub = Subscriptions();
    QuerySnapshot subSnap = await sub.getCollectionRef().getDocuments();
    int validityDays = 1;
    int smsCredits = 0;
    bool isExist = false;

    if (subSnap.documents.isEmpty) {
      validityDays = 28;
      smsCredits = 0;
    } else {
      for (int i = 0; i < subSnap.documents.length; i++) {
        Subscriptions _sub = Subscriptions.fromJson(subSnap.documents[i].data);
        if (financeID == _sub.financeID) {
          isExist = true;
          break;
        }
      }
    }

    if (!isExist) {
      var subData = {
        "user_number": cachedLocalUser.getIntID(),
        "guid": guid,
        "payment_id": "",
        "purchase_id": "",
        "recently_paid": 0,
        "available_sms_credit": smsCredits,
        "finance_id": financeID,
        "chit_valid_till": DateUtils.getUTCDateEpoch(DateTime.now()) +
            (validityDays * 86400000),
        "notes": "",
        "finance_valid_till": DateUtils.getUTCDateEpoch(DateTime.now()) +
            (validityDays * 86400000),
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      };
      bWrite.setData(sub.getCollectionRef().document(), subData);
    }

    bWrite.updateData(
        getCollectionRef().document(cachedLocalUser.getID()), data);
    await bWrite.commit();
  }
}
