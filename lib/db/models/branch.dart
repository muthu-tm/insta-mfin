import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:instamfin/db/models/address.dart';

part 'branch.g.dart';

@JsonSerializable(explicitToJson: true)
class Branch {
  Finance finance = Finance();

  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'emails', nullable: true)
  List<String> emails;
  @JsonKey(name: 'admins', nullable: true)
  List<int> admins;
  @JsonKey(name: 'users', nullable: true)
  List<int> users;
  @JsonKey(name: 'display_profile_path', nullable: true)
  String displayProfilePath;
  @JsonKey(name: 'date_of_registration', nullable: true)
  String dateOfRegistration;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Branch();

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  addEmails(List<String> emails) {
    this.emails.addAll(emails);
  }

  addAdmins(List<int> admins) {
    this.admins.addAll(admins);
  }

  addUsers(List<int> users) {
    this.users.addAll(users);
  }

  setDOR(DateTime date) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.dateOfRegistration = formatter.format(date);
  }

  setDisplayProfilePath(String profilePath) {
    this.displayProfilePath = profilePath;
  }

  setAddress(Address address) {
    this.address = address;
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

  Future<List<Branch>> getAllBranches(String financeID) async {
    var branchDocs = await getBranchCollectionRef(financeID).getDocuments();

    if (branchDocs.documents.isEmpty) {
      return null;
    }

    List<Branch> branches = [];

    for (var doc in branchDocs.documents) {
      var branch = Branch.fromJson(doc.data);
      branches.add(branch);
    }

    return branches;
  }

  Future<Branch> getBranchByName(String financeID, String branchName) async {
    var branchSnap = await getBranchCollectionRef(financeID)
        .where('brach_name', isEqualTo: branchName)
        .snapshots()
        .toList();
    if (branchSnap.isEmpty || branchSnap.first.documents.isEmpty) {
      return null;
    }

    return Branch.fromJson(branchSnap.first.documents.first.data);
  }

  Future<List<Branch>> getBranchByUserID(
      String financeID, String userID) async {
    List<DocumentSnapshot> docSnapshot =
        (await getBranchCollectionRef(financeID)
                .where('users', arrayContains: userID)
                .getDocuments())
            .documents;

    if (docSnapshot.isEmpty) {
      return null;
    }

    List<Branch> branches;

    for (var doc in docSnapshot) {
      Branch branch = Branch.fromJson(doc.data);
      branches.add(branch);
    }

    return branches;
  }

  Future<Branch> update(String financeID) async {
    this.updatedAt = DateTime.now();

    await getDocumentReference(financeID, this.branchName)
        .updateData(this.toJson());

    return this;
  }
}
