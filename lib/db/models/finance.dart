import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/accounts_data.dart';
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
  @JsonKey(name: 'date_of_registration', nullable: true)
  int dateOfRegistration;
  @JsonKey(name: 'profile_path_org', defaultValue: "")
  String profilePathOrg;
  @JsonKey(name: 'profile_path', defaultValue: "")
  String profilePath;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
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
    List<DocumentSnapshot> docSnapshot = (await getCollectionRef()
            .where('users', arrayContains: userID)
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

    dynamic result = await super.add(this.toJson());
    print(result);
    return this;
  }

  replace() async {
    var finance = await getByID("");
    dynamic result = await super.upsert(this.toJson(), finance['created_at']);
    print(result);
  }
}
