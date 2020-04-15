import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'company.g.dart';

@JsonSerializable(explicitToJson: true)
class Company extends Model {
  static CollectionReference _companyCollRef =
      Model.db.collection("finance_companies");

  @JsonKey(name: 'registration_id', nullable: true)
  String registrationID;
  @JsonKey(name: 'finance_name', nullable: true)
  String financeName;
  @JsonKey(name: 'emails', nullable: true)
  List<String> emails;
  @JsonKey(name: 'admins', nullable: true)
  List<String> admins;
  @JsonKey(name: 'display_profile_path', nullable: true)
  String displayProfilePath;
  @JsonKey(name: 'address', nullable: true)
  Address address;
  @JsonKey(name: 'date_of_registration', nullable: true)
  String dateOfRegistration;
  @JsonKey(name: 'allocated_branch_count', nullable: true)
  int allocatedBranchCount;
  @JsonKey(name: 'available_branch_count', nullable: true)
  int availableBranchCount;
  @JsonKey(name: 'allocated_users_count', nullable: true)
  int allocatedUsersCount;
  @JsonKey(name: 'available_users_count', nullable: true)
  int availableUsersCount;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Company();

  setFianceName(String name) {
    this.financeName = name;
  }

  setRegistrationID(String registrationID) {
    this.registrationID = registrationID;
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

  setAllocatedBranchCount(int allocBranchCount) {
    this.allocatedBranchCount = allocBranchCount;
  }

  setAllocatedUsersCount(int allocUsersCount) {
    this.allocatedUsersCount = allocUsersCount;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  CollectionReference getCollectionRef() {
    return _companyCollRef;
  }

  String getID() {
    return this.createdAt.millisecondsSinceEpoch.toString();
  }

  Future<DocumentSnapshot> getFinance(String financeID) async {
    return await getCollectionRef().document(financeID).get();
  }

  create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    dynamic result = await super.add(this.toJson());
    print(result);
  }

  replace() async {
    var finance = await getByID();
    dynamic result = await super.upsert(this.toJson(), finance['created_at']);
    print(result);
  }
}
