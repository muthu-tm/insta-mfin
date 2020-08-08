import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/account_preferences.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'finance.g.dart';

@JsonSerializable(explicitToJson: true)
class Finance extends Model {
  static CollectionReference _financeCollRef =
      Model.db.collection("finance_companies");

  @JsonKey(name: 'registration_id', nullable: true)
  String registrationID;
  @JsonKey(name: 'finance_name', nullable: true)
  String financeName;
  @JsonKey(name: 'email', nullable: true)
  String emailID;
  @JsonKey(name: 'contact_number', nullable: true)
  String contactNumber;
  @JsonKey(name: 'admins', nullable: true)
  List<int> admins;
  @JsonKey(name: 'users', nullable: true)
  List<int> users;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'accounts_data', nullable: true)
  AccountsData accountsData;
  @JsonKey(name: 'preferences')
  AccountPreferences preferences;
  @JsonKey(name: 'date_of_registration', nullable: true)
  int dateOfRegistration;
  @JsonKey(name: 'profile_path_org', defaultValue: "")
  String profilePathOrg;
  @JsonKey(name: 'profile_path', defaultValue: "")
  String profilePath;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'is_active', defaultValue: true)
  bool isActive;
  @JsonKey(name: 'deactivated_at', nullable: true)
  int deactivatedAt;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Finance();

  setFianceName(String name) {
    this.financeName = name;
  }

  setRegistrationID(String registrationID) {
    this.registrationID = registrationID;
  }

  setEmail(String emailID) {
    this.emailID = emailID;
  }

  setContactNumber(String number) {
    this.contactNumber = number;
  }

  addAdmins(List<int> admins) {
    if (this.admins == null) {
      this.admins = admins;
    } else {
      this.admins.addAll(admins);
    }
  }

  addUsers(List<int> users) {
    if (this.users == null) {
      this.users = users;
    } else {
      this.users.addAll(users);
    }
  }

  setDOR(int date) {
    this.dateOfRegistration = date;
  }

  setAddress(Address address) {
    this.address = address;
  }

  setAccountsData(AccountsData accountsData) {
    this.accountsData = accountsData;
  }

  setProfilePathOrg(String displayPath) {
    this.profilePathOrg = displayPath;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  String getProfilePicPath() {
    if (this.profilePath != "")
      return this.profilePath;
    else if (this.profilePathOrg != "")
      return this.profilePathOrg;
    else
      return "";
  }

  factory Finance.fromJson(Map<String, dynamic> json) =>
      _$FinanceFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceToJson(this);

  CollectionReference getCollectionRef() {
    return _financeCollRef;
  }

  String getID() {
    return this.createdAt.millisecondsSinceEpoch.toString();
  }

  Future<DocumentSnapshot> getFinance(String financeID) async {
    return await getCollectionRef().document(financeID).get();
  }

  Future<List<Finance>> getFinanceByUserID(int userID) async {
    if (userID == null) {
      return null;
    }

    List<DocumentSnapshot> docSnapshot = (await getCollectionRef()
            .where('users', arrayContains: userID)
            .where('is_active', isEqualTo: true)
            .getDocuments())
        .documents;

    if (docSnapshot.isEmpty) {
      return null;
    }

    List<Finance> finances = [];

    for (var doc in docSnapshot) {
      Finance finance = Finance.fromJson(doc.data);
      finances.add(finance);
    }

    return finances;
  }

  Future<Finance> create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.accountsData = new AccountsData();
    this.isActive = true;

    Subscriptions sub = Subscriptions();

    QuerySnapshot subSnap = await sub.getCollectionRef().getDocuments();
    int validityDays = 1;
    int smsCredits = 0;
    if (subSnap.documents.isEmpty) {
      validityDays = 28;
      smsCredits = 100;
    }
    var data = {
      "user_number": user.mobileNumber,
      "guid": user.guid,
      "payment_id": "",
      "purchase_id": "",
      "recently_paid": 0,
      "available_sms_credit": smsCredits,
      "finance_id": this.getID(),
      "chit_valid_till":
          DateUtils.getUTCDateEpoch(DateTime.now()) + (validityDays * 86400000),
      "notes": "",
      "finance_valid_till":
          DateUtils.getUTCDateEpoch(DateTime.now()) + (validityDays * 86400000),
      "created_at": DateTime.now(),
      "updated_at": DateTime.now()
    };

    WriteBatch bWrite = Model.db.batch();
    bWrite.setData(sub.getCollectionRef().document(), data);
    bWrite.setData(getCollectionRef().document(this.getID()), this.toJson());
    await bWrite.commit();
    return this;
  }
}
