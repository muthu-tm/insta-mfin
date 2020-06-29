import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  @JsonKey(name: 'primary_finance', defaultValue: "")
  String primaryFinance;
  @JsonKey(name: 'primary_branch', defaultValue: "")
  String primaryBranch;
  @JsonKey(name: 'primary_sub_branch', defaultValue: "")
  String primarySubBranch;
  @JsonKey(name: 'last_signed_in_at', nullable: true)
  DateTime lastSignInTime;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  User(int mobileNumber) {
    this.mobileNumber = mobileNumber;
    this.address = new Address();
  }

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

  setPrimaryFinance(String financeID) {
    this.primaryFinance = financeID;
  }

  setPrimaryBranch(String branchID) {
    this.primaryBranch = branchID;
  }

  setPrimarySubBranchID(String subBranchID) {
    this.primarySubBranch = subBranchID;
  }

  setAddress(Address address) {
    this.address = address;
  }

  setPreferences(UserPreferences preferences) {
    this.preferences = preferences;
  }

  String getProfilePicPath() {
    if (this.profilePath != "")
      return this.profilePath;
    else if (this.profilePathOrg != "")
      return this.profilePathOrg;
    else
      return "";
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  CollectionReference getCollectionRef() {
    return _userCollRef;
  }

  String getID() {
    return this.mobileNumber.toString();
  }

  Future<User> create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    await super.add(this.toJson());

    return this;
  }

  Future<User> replace() async {
    var user = await getByID("");

    await super.upsert(this.toJson(), user['created_at']);

    return this;
  }

  DocumentReference getFinanceDocReference() {
    if (this.primarySubBranch != "") {
      return SubBranch().getDocumentReference(
          this.primaryFinance, this.primaryBranch, this.primarySubBranch);
    } else if (this.primaryBranch != "") {
      return Branch()
          .getDocumentReference(this.primaryFinance, this.primaryBranch);
    } else {
      return Finance().getDocumentRef(this.primaryFinance);
    }
  }

  Future updatePlatformDetails(Map<String, dynamic> data) async {
    this.update(data);
  }
}
