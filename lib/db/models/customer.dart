import 'package:instamfin/db/enums/action_type.dart';
import 'package:instamfin/db/enums/gender.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends Model {
  static CollectionReference _customerCollRef = Model.db.collection("customers");

  @JsonKey(name: 'customer_id', nullable: true)
  String customerID;
  @JsonKey(name: 'mobile_number', nullable: false)
  int mobileNumber;
  @JsonKey(name: 'customer_name', nullable: true)
  String name;
  @JsonKey(name: 'gender', nullable: true)
  String gender;
  @JsonKey(name: 'display_profile_path', defaultValue: "")
  String displayProfilePath;
  @JsonKey(name: 'date_of_birth', nullable: true)
  String dateOfBirth;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'age', nullable: true)
  int age;
  @JsonKey(name: 'branch_id', nullable: true)
  String branchID;
  @JsonKey(name: 'sub_branch_id', nullable: true)
  String subBranchID;
  @JsonKey(name: 'guarantied_by', nullable: true)
  int guarantiedBy;
  @JsonKey(name: 'last_transaction_type', defaultValue: "")
  String lastTransactionType;
  @JsonKey(name: 'last_transaction_at', nullable: true)
  DateTime lastTransactionTime;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Customer(String customerID) {
    this.customerID = customerID;
  }

  setMobileNumber(int mobileNumber) {
    this.mobileNumber = mobileNumber;
  }

  setGender(Gender gender) {
    this.gender = gender.name;
  }

  setLastActionType(ActionType actionType) {
    this.lastTransactionType = actionType.name;
  }

  setName(String name) {
    this.name = name;
  }

  setDOB(date) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.dateOfBirth = formatter.format(date);
  }

  setAge(int age) {
    this.age = age;
  }

  setGuarantiedBy(int guarantiedBy) {
    this.guarantiedBy = guarantiedBy;
  }

  setLastTransactionTime(DateTime dateTime) {
    this.lastTransactionTime = dateTime;
  }

  setDisplayProfilePath(String profilePath) {
    this.displayProfilePath = profilePath;
  }

  setBranchID(String branchID) {
    this.branchID = branchID;
  }

  setSubBranchID(String subBranchID) {
    this.subBranchID = subBranchID;
  }

  setAddress(Address address) {
    this.address = address;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  CollectionReference getCollectionRef() {
    return _customerCollRef;
  }

  String getID() {
    return this.customerID;
  }

  create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    
    dynamic result = await super.add(this.toJson());
    print(result);
  }

  replace() async {
    var user = await getByID();
    dynamic result = await super.upsert(this.toJson(), user['created_at']);
    print(result);
  }

}