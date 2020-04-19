import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/services/utils/hash_generator.dart';

part 'sub_branch.g.dart';

@JsonSerializable(explicitToJson: true)
class SubBranch {
  Branch branch = Branch();

  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
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

  SubBranch();

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
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

  factory SubBranch.fromJson(Map<String, dynamic> json) =>
      _$SubBranchFromJson(json);
  Map<String, dynamic> toJson() => _$SubBranchToJson(this);

  CollectionReference getSubBranchCollectionRef(
      String financeID, String branchName) {
    return branch
        .getDocumentReference(financeID, branchName)
        .collection("sub_branches");
  }

  String getDocumentID(branchName, subBranchName) {
    return HashGenerator.hmacGenerator(subBranchName, branchName);
  }

  DocumentReference getDocumentReference(financeID, branchName, subBranchName) {
    return getSubBranchCollectionRef(financeID, branchName)
        .document(getDocumentID(branchName, subBranchName));
  }

  Future<SubBranch> create(String financeID, String branchName) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    await getDocumentReference(financeID, branchName, this.subBranchName)
        .setData(this.toJson());

    return this;
  }

  Future<bool> isExist(
      String financeID, String branchName, String subBranchName) async {
    var branchSnap =
        await getDocumentReference(financeID, branchName, subBranchName).get();

    return branchSnap.exists;
  }

  updateArrayField(bool isAdd, Map<String, dynamic> data, String financeID,
      String branchName, String subBranchName) async {
    Map<String, dynamic> fields = Map();
    fields['updated_at'] = DateTime.now();

    data.forEach((key, value) {
      if (isAdd) {
        fields[key] = FieldValue.arrayUnion(value);
      } else {
        fields[key] = FieldValue.arrayRemove(value);
      }
    });

    String docId = getDocumentID(branchName, subBranchName);

    if (docId != null || docId != "") {
      docId = docId;
    }

    await getDocumentReference(financeID, branchName, subBranchName)
        .updateData(fields);
    return data;
  }

  Future<List<SubBranch>> getAllSubBranches(
      String financeID, String branchName) async {
    var subBranchDocs =
        await getSubBranchCollectionRef(financeID, branchName).getDocuments();

    if (subBranchDocs.documents.isEmpty) {
      return null;
    }

    List<SubBranch> subBranches = [];

    for (var doc in subBranchDocs.documents) {
      var subBranch = SubBranch.fromJson(doc.data);
      subBranches.add(subBranch);
    }

    return subBranches;
  }

  Future<SubBranch> getSubBranchByName(
      String financeID, String branchName, String subBranchName) async {
    var subBranchSnap = await getSubBranchCollectionRef(financeID, branchName)
        .where('sub_brach_name', isEqualTo: subBranchName)
        .snapshots()
        .toList();
    if (subBranchSnap.isEmpty || subBranchSnap.first.documents.isEmpty) {
      return null;
    }

    return SubBranch.fromJson(subBranchSnap.first.documents.first.data);
  }

  Future<List<SubBranch>> getSubBranchByUserID(
      String financeID, String branchName, String userID) async {
    List<DocumentSnapshot> docSnapshot =
        (await getSubBranchCollectionRef(financeID, branchName)
                .where('users', arrayContains: userID)
                .getDocuments())
            .documents;

    if (docSnapshot.isEmpty) {
      return null;
    }

    List<SubBranch> subBranches;

    for (var doc in docSnapshot) {
      SubBranch subBranch = SubBranch.fromJson(doc.data);
      subBranches.add(subBranch);
    }

    return subBranches;
  }

  Future<SubBranch> update(String financeID, String branchName) async {
    this.updatedAt = DateTime.now();

    await getDocumentReference(financeID, branchName, this.subBranchName)
        .updateData(this.toJson());

    return this;
  }
}
