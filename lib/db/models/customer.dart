import 'package:instamfin/db/enums/customer_status.dart';
import 'package:instamfin/db/enums/gender.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends Model {
  User user = UserController().getCurrentUser();

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
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'customer_status', nullable: true)
  int status;
  @JsonKey(name: 'display_profile_path', defaultValue: "")
  String displayProfilePath;
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

  setCustomerStatus(int status) {
    this.status = status;
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

  String getDocumentID(int mobileNumber) {
    return HashGenerator.hmacGenerator(
        user.primaryFinance + user.primaryBranch + user.primarySubBranch,
        mobileNumber.toString());
  }

  String getID() {
    return getDocumentID(this.mobileNumber);
  }

  Stream<QuerySnapshot> getCustomerByStatus(int status, bool fetchAll) {
    if (fetchAll) {
      return getCollectionRef()
          .where('finance_id', isEqualTo: user.primaryFinance)
          .where('branch_name', isEqualTo: user.primaryBranch)
          .where('sub_branch_name', isEqualTo: user.primarySubBranch)
          .snapshots();
    } else {
      return getCollectionRef()
          .where('finance_id', isEqualTo: user.primaryFinance)
          .where('branch_name', isEqualTo: user.primaryBranch)
          .where('sub_branch_name', isEqualTo: user.primarySubBranch)
          .where('customer_status', isEqualTo: status)
          .snapshots();
    }
  }

  Future<dynamic> getPayments(int number) async {
    String docID = getDocumentID(mobileNumber);

    var snap = await getCollectionRef()
        .document(docID)
        .collection('payments')
        .getDocuments();

    if (snap.documents.isEmpty) {
      return null;
    } else {
      return snap.documents.first;
    }
  }

  Future<Customer> getByMobileNumber(int number) async {
    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primaryFinance)
        .where('branch_name', isEqualTo: user.primaryBranch)
        .where('sub_branch_name', isEqualTo: user.primarySubBranch)
        .where('mobile_number', isEqualTo: number)
        .getDocuments();

    if (snap.documents.isEmpty) {
      return null;
    }

    return Customer.fromJson(snap.documents.first.data);
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

  remove(int number) async {
    String docID = getDocumentID(number);
    await delete(docID);
  }
}
