import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/account_preferences.dart';

part 'branch.g.dart';

@JsonSerializable(explicitToJson: true)
class Branch {
  Finance finance = Finance();

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'accounts_data', nullable: true)
  AccountsData accountsData;
  @JsonKey(name: 'preferences')
  AccountPreferences preferences;
  @JsonKey(name: 'email', nullable: true)
  String emailID;
  @JsonKey(name: 'contact_number', nullable: true)
  String contactNumber;
  @JsonKey(name: 'admins', nullable: true)
  List<int> admins;
  @JsonKey(name: 'users', nullable: true)
  List<int> users;
  @JsonKey(name: 'date_of_registration', nullable: true)
  int dateOfRegistration;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'is_active', defaultValue: true)
  bool isActive;
  @JsonKey(name: 'deactivated_at', nullable: true)
  DateTime deactivatedAt;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Branch();

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
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

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setCreatedAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  setUpdatedAt(DateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
  Map<String, dynamic> toJson() => _$BranchToJson(this);

  CollectionReference getBranchCollectionRef(String financeID) {
    return finance
        .getCollectionRef()
        .document(financeID)
        .collection("branches");
  }

  String getDocumentID(financeID, branchName) {
    return HashGenerator.hmacGenerator(branchName, financeID);
  }

  DocumentReference getDocumentReference(financeID, branchName) {
    return getBranchCollectionRef(financeID)
        .document(getDocumentID(financeID, branchName));
  }

  Future<Branch> create(String financeID) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.accountsData = new AccountsData();
    this.financeID = financeID;
    this.isActive = true;

    await getDocumentReference(financeID, this.branchName)
        .setData(this.toJson());

    return this;
  }

  Future<bool> isExist(String financeID, String branchName) async {
    var branchSnap = await getDocumentReference(financeID, branchName).get();

    return branchSnap.exists;
  }

  updateArrayField(bool isAdd, Map<String, dynamic> data, String financeID,
      String branchName) async {
    Map<String, dynamic> fields = Map();
    fields['updated_at'] = DateTime.now();

    data.forEach((key, value) {
      if (isAdd) {
        fields[key] = FieldValue.arrayUnion(value);
      } else {
        fields[key] = FieldValue.arrayRemove(value);
      }
    });

    String docId = getDocumentID(financeID, branchName);

    if (docId != null || docId != "") {
      docId = docId;
    }

    await getDocumentReference(financeID, branchName).updateData(fields);
    return data;
  }

  Stream<QuerySnapshot> streamAllBranches(String financeID) {
    try {
      return getBranchCollectionRef(financeID)
          .where('is_active', isEqualTo: true)
          .snapshots();
    } catch (err) {
      throw err;
    }
  }

  Future<List<Branch>> getAllBranches(String financeID) async {
    var branchDocs = await getBranchCollectionRef(financeID)
        .where('is_active', isEqualTo: true)
        .getDocuments();

    if (branchDocs.documents.isEmpty) {
      throw 'No branch found for $financeID';
    }

    List<Branch> branches = [];

    for (var doc in branchDocs.documents) {
      var branch = Branch.fromJson(doc.data);
      branches.add(branch);
    }

    return branches;
  }

  Future<Branch> getBranchByName(String financeID, String branchName) async {
    String docId = getDocumentID(financeID, branchName);

    var branchSnap =
        await getBranchCollectionRef(financeID).document(docId).get();
    if (!branchSnap.exists) {
      return null;
    }

    return Branch.fromJson(branchSnap.data);
  }

  Future<List<Branch>> getBranchByUserID(String financeID, int userID) async {
    if (userID == null) {
      return null;
    }

    List<DocumentSnapshot> docSnapshot =
        (await getBranchCollectionRef(financeID)
                .where('users', arrayContains: userID)
                .where('is_active', isEqualTo: true)
                .getDocuments())
            .documents;

    if (docSnapshot.isEmpty) {
      return null;
    }

    List<Branch> branches = [];

    for (var doc in docSnapshot) {
      Branch branch = Branch.fromJson(doc.data);
      branches.add(branch);
    }

    return branches;
  }

  Future<void> update(String financeID, String branchName,
      Map<String, dynamic> branchJSON) async {
    branchJSON['updated_at'] = DateTime.now();

    await getDocumentReference(financeID, branchName).updateData(branchJSON);
  }
}
