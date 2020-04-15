import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/company.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:instamfin/db/models/address.dart';

part 'branch.g.dart';

@JsonSerializable(explicitToJson: true)
class Branch {
  String hmacKey = 'branch';

  Company finance = Company();

  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'emails', nullable: true)
  List<String> emails;
  @JsonKey(name: 'admins', nullable: true)
  List<String> admins;
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

  addAdmins(List<String> admins) {
    this.admins.addAll(admins);
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

  String getDocumentID(branchName) {
    return HashGenerator.hmacGenerator(branchName, hmacKey);
  }

  Future<Branch> create(String financeID) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    await getBranchCollectionRef(financeID)
        .document(getDocumentID(this.branchName))
        .setData(this.toJson());

    return this;
  }

  Future<bool> isExist(String financeID, String branchName) async {
    var branchSnap = await getBranchCollectionRef(financeID)
        .document(getDocumentID(branchName))
        .get();

    return branchSnap.exists;
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

  Future<Branch> getBrachByName(String financeID, String branchName) async {
    var branchSnap = await getBranchCollectionRef(financeID)
        .where('brach_name', isEqualTo: branchName)
        .snapshots()
        .toList();
    if (branchSnap.isEmpty || branchSnap.first.documents.isEmpty) {
      return null;
    }

    return Branch.fromJson(branchSnap.first.documents.first.data);
  }

  Future<Branch> update(String financeID) async {
    this.updatedAt = DateTime.now();

    await getBranchCollectionRef(financeID)
        .document(getDocumentID(this.branchName))
        .updateData(this.toJson());

    return this;
  }
}
