import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/payment.dart';
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
  @JsonKey(name: 'joined_at', nullable: true)
  int joinedAt;
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
  @JsonKey(name: 'profile_path_org', defaultValue: "")
  String profilePathOrg;
  @JsonKey(name: 'profile_path', defaultValue: "")
  String profilePath;
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

  setGender(String gender) {
    this.gender = gender;
  }

  setName(String name) {
    this.name = name;
  }

  setAge(int age) {
    this.age = age;
  }

  setJoinedAt(int joinedAt) {
    this.joinedAt = joinedAt;
  }

  setProfession(String profession) {
    this.profession = profession;
  }

  setGuarantiedBy(int guarantiedBy) {
    this.guarantiedBy = guarantiedBy;
  }

  setProfilePathOrg(String displayPath) {
    this.profilePathOrg = displayPath;
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

  String getProfilePicPath() {
    if (this.profilePath != "")
      return this.profilePath;
    else if (this.profilePathOrg != "")
      return this.profilePathOrg;
    else
      return "";
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  CollectionReference getCollectionRef() {
    return _customerCollRef;
  }

  String getDocumentID(int mobileNumber) {
    return HashGenerator.hmacGenerator(
        user.primary.financeID +
            user.primary.branchName +
            user.primary.subBranchName,
        mobileNumber.toString());
  }

  String getID() {
    return getDocumentID(this.mobileNumber);
  }

  Stream<QuerySnapshot> streamAllCustomers() {
    return getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .orderBy('joined_at', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getAllCustomers() {
    return getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .getDocuments();
  }

  Future<List<Customer>> getAllByDate(int epoch) async {
    var custDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('joined_at', isEqualTo: epoch)
        .getDocuments();

    List<Customer> customers = [];
    if (custDocs.documents.isNotEmpty) {
      for (var doc in custDocs.documents) {
        customers.add(Customer.fromJson(doc.data));
      }
    }

    return customers;
  }

  Future<List<Customer>> getAllByDateRange(int start, int end) async {
    var custDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('joined_at', isGreaterThanOrEqualTo: start)
        .where('joined_at', isLessThanOrEqualTo: end)
        .getDocuments();

    List<Customer> customers = [];
    if (custDocs.documents.isNotEmpty) {
      for (var doc in custDocs.documents) {
        customers.add(Customer.fromJson(doc.data));
      }
    }

    return customers;
  }

  Future<int> getStatus(int number) async {
    try {
      QuerySnapshot allSnap = await Payment()
          .getGroupQuery()
          .where('finance_id', isEqualTo: user.primary.financeID)
          .where('branch_name', isEqualTo: user.primary.branchName)
          .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
          .where('customer_number', isEqualTo: number)
          .getDocuments();

      if (allSnap.documents.length == 0) return 0; //New
      int status = 3; //Settled

      for (var paysnap in allSnap.documents) {
        Payment pay = Payment.fromJson(paysnap.data);
        if (!pay.isSettled) {
          List<int> aDetails = await pay.getAmountDetails();

          if (aDetails[1] > 0) {
            status = 2; //Pending
            break;
          } else if (aDetails[2] > 0 || aDetails[3] > 0) {
            status = 1; //Active
          }
        }
      }

      return status;
    } catch (err) {
      throw err;
    }
  }

  Future<List<Payment>> getPayments(int number) async {
    var snap = await Payment().getAllPaymentsForCustomer(number);

    if (snap.length == 0) {
      return null;
    } else {
      return snap;
    }
  }

  Future<Customer> getByMobileNumber(int number) async {
    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('mobile_number', isEqualTo: number)
        .getDocuments();

    if (snap.documents.isEmpty) {
      return null;
    }

    return Customer.fromJson(snap.documents.first.data);
  }

  Future<List<Map<String, dynamic>>> getByRange(
      int minNumber, int maxNumber) async {
    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('mobile_number', isGreaterThanOrEqualTo: minNumber)
        .where('mobile_number', isLessThanOrEqualTo: maxNumber)
        .getDocuments();

    List<Map<String, dynamic>> custList = [];
    if (snap.documents.isNotEmpty) {
      snap.documents.forEach((cust) {
        custList.add(cust.data);
      });
    }

    return custList;
  }

  Future<List<Map<String, dynamic>>> getByNameRange(String startsWith) async {
    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('customer_name', isGreaterThanOrEqualTo: startsWith)
        .getDocuments();

    List<Map<String, dynamic>> custList = [];
    if (snap.documents.isNotEmpty) {
      snap.documents.forEach((cust) {
        custList.add(cust.data);
      });
    }

    return custList;
  }

  Stream<QuerySnapshot> streamCustomersByRange(int minNumber, int maxNumber) {
    return getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('mobile_number', isGreaterThanOrEqualTo: minNumber)
        .where('mobile_number', isLessThanOrEqualTo: maxNumber)
        .snapshots();
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
