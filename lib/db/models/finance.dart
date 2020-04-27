import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'finance.g.dart';

@JsonSerializable(explicitToJson: true)
class Finance extends Model {
  static CollectionReference _companyCollRef =
      Model.db.collection("finance_companies");

  @JsonKey(name: 'registration_id', nullable: true)
  String registrationID;
  @JsonKey(name: 'finance_name', nullable: true)
  String financeName;
  @JsonKey(name: 'email', nullable: true)
  String emailID;
  @JsonKey(name: 'contact_number', nullable: true)
  String contactNumber;
  @JsonKey(name: 'admins', nullable: true)
  List<int> admins;
  @JsonKey(name: 'users', nullable: true)
  List<int> users;
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

  Finance();

  setFianceName(String name) {
    this.financeName = name;
  }

  setRegistrationID(String registrationID) {
    this.registrationID = registrationID;
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

  setDOR(String date) {
    this.dateOfRegistration = date;
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

  factory Finance.fromJson(Map<String, dynamic> json) =>
      _$FinanceFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceToJson(this);

  CollectionReference getCollectionRef() {
    return _companyCollRef;
  }

  String getID() {
    return this.createdAt.millisecondsSinceEpoch.toString();
  }

  Future<DocumentSnapshot> getFinance(String financeID) async {
    return await getCollectionRef().document(financeID).get();
  }

  Future<List<Finance>> getFinanceByUserID(int userID) async {
    List<DocumentSnapshot> docSnapshot = (await getCollectionRef()
            .where('users', arrayContains: userID)
            .getDocuments())
        .documents;
    
    if (docSnapshot.isEmpty) {
      return null;
    }

    List<Finance> finances = [];

    for (var doc in docSnapshot) {
      Finance finance = Finance.fromJson(doc.data);
      finances.add(finance);
    }

    return finances;
  }

  Future<Finance> create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    dynamic result = await super.add(this.toJson());
    print(result);
    return this;
  }

  replace() async {
    var finance = await getByID("");
    dynamic result = await super.upsert(this.toJson(), finance['created_at']);
    print(result);
  }
}
