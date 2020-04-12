import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'gender_enum.dart';
part 'user.g.dart';

User userState;

@JsonSerializable(explicitToJson: true)
class User extends Model {
  static CollectionReference _userCollRef = Model.db.collection("user");

  @JsonKey(name: 'user_name', nullable: true)
  String name;
  @JsonKey(name: 'mobile_number', nullable: false)
  int mobileNumber;
  @JsonKey(name: 'password', nullable: false)
  String password;
  @JsonKey(name: 'gender', nullable: true)
  String gender;
  @JsonKey(name: 'display_profile_path', defaultValue: "")
  String displayProfilePath;
  @JsonKey(name: 'date_of_birth', nullable: true)
  String dateOfBirth;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'primary_company', nullable: true)
  String primaryCompany;
  @JsonKey(name: 'primary_branch', nullable: true)
  String primaryBranch;
  @JsonKey(name: 'primary_sub_branch', nullable: true)
  String primarySubBranch;
  @JsonKey(name: 'last_signed_in_at', nullable: true)
  DateTime lastSignInTime;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  User(mobileNumber) {
    this.mobileNumber = mobileNumber;
  }

  setUserState() async {
    userState = User.fromJson(await getByID());

    print("USER STATE change occurred: " + userState.toJson().toString());
  }

  setPassword(String password) {
    this.password = password;
  }

  setGender(Gender val) {
    switch (val) {
      case Gender.Male:
        this.gender = "Male";
        break;
      case Gender.Female:
        this.gender = "Female";
        break;
    }
  }

  setName(String name) {
    this.name = name;
  }

  setDOB(date) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.dateOfBirth = formatter.format(date);
  }

  setLastSignInTime(DateTime dateTime) {
    this.lastSignInTime = dateTime;
  }

  setDisplayProfilePath(String profilePath) {
    this.displayProfilePath = profilePath;
  }

  setPrimaryCompany(String companyID) {
    this.primaryCompany = companyID;
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  CollectionReference getCollectionRef() {
    return _userCollRef;
  }

  String getID() {
    return this.mobileNumber.toString();
  }

  create() async {
    dynamic result = await super.add(this.toJson());
    print(result);
  }

  replace() async {
    var user = await getByID();
    dynamic result = await super.upsert(this.toJson(), user['created_at']);
    print(result);
  }
}
