import 'package:instamfin/db/enums/action_type.dart';
import 'package:instamfin/db/enums/gender.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends Model {
  static CollectionReference _customerCollRef =
      Model.db.collection("customers");

  @JsonKey(name: 'customer_id', nullable: true)
  String customerID;
  @JsonKey(name: 'mobile_number', nullable: false)
  int mobileNumber;
  @JsonKey(name: 'customer_name', nullable: true)
  String name;
  @JsonKey(name: 'gender', nullable: true)
  String gender;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'age', nullable: true)
  int age;
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'customer_profession', defaultValue: "")
  String profession;
  @JsonKey(name: 'guarantied_by', nullable: true)
  int guarantiedBy;
  @JsonKey(name: 'display_profile_path', defaultValue: "")
  String displayProfilePath;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Customer();

  setCustomerID(String customerID) {
    this.customerID = customerID;
  }

  setMobileNumber(int mobileNumber) {
    this.mobileNumber = mobileNumber;
  }

  setGender(Gender gender) {
    this.gender = gender.name;
  }

  setName(String name) {
    this.name = name;
  }

  setAge(int age) {
    this.age = age;
  }

  setProfession(String profession) {
    this.profession = profession;
  }

  setGuarantiedBy(int guarantiedBy) {
    this.guarantiedBy = guarantiedBy;
  }

  setDisplayProfilePath(String profilePath) {
    this.displayProfilePath = profilePath;
  }

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setAddress(Address address) {
    this.address = address;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  CollectionReference getCollectionRef() {
    return _customerCollRef;
  }

  String getDocumentID(int mobileNumber, String financeID, String branchName,
      String subBranchName) {
    return HashGenerator.hmacGenerator(
        financeID + branchName + subBranchName, mobileNumber.toString());
  }

  String getID() {
    return getDocumentID(
        this.mobileNumber, this.financeID, this.branchName, this.subBranchName);
  }

  create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    dynamic result = await super.add(this.toJson());
    print(result);
  }

  replace() async {
    var user = await getByID("");
    dynamic result = await super.upsert(this.toJson(), user['created_at']);
    print(result);
  }
}
