import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:instamfin/db/models/address.dart';

part 'sub_branch.g.dart';

@JsonSerializable(explicitToJson: true)
class SubBranch {
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'emails', nullable: true)
  List<String> emails;
  @JsonKey(name: 'admins', nullable: true)
  List<int> admins;
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

  addEmails(List<String> emails) {
    this.emails.addAll(emails);
  }

  addAdmins(List<int> admins) {
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

  factory SubBranch.fromJson(Map<String, dynamic> json) => _$SubBranchFromJson(json);
  Map<String, dynamic> toJson() => _$SubBranchToJson(this);
}
