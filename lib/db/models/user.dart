import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
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
  @JsonKey(name: 'last_signed_in_at', nullable: true)
  DateTime lastSignInTime;
  @JsonKey(name: 'is_active', defaultValue: true)
  bool isActive;
  @JsonKey(name: 'deactivated_at', nullable: true)
  DateTime deactivatedAt;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  AccountPreferences accPreferences;

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
    this.isActive = true;

    await super.add(this.toJson());

    return this;
  }

  Future<User> replace() async {
    var user = await getByID("");

    await super.upsert(this.toJson(), user['created_at']);

    return this;
  }

  DocumentReference getFinanceDocReference() {
    if (this.primary.subBranchName != "") {
      return SubBranch().getDocumentReference(
          this.primary.financeID, this.primary.branchName, this.primary.subBranchName);
    } else if (this.primary.branchName != "") {
      return Branch()
          .getDocumentReference(this.primary.financeID, this.primary.branchName);
    } else {
      return Finance().getDocumentRef(this.primary.financeID);
    }
  }

  Future updatePlatformDetails(Map<String, dynamic> data) async {
    this.update(data);
  }
}
