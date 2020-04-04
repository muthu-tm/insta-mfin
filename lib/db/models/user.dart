import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'gender_enum.dart';
part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Model {
  
  static CollectionReference _userCollRef = Model.db.collection("user");
  
  @JsonKey(name: 'id', nullable: false)
  String id;
  @JsonKey(name: 'email', nullable: false)
  String email;
  @JsonKey(name: 'user_name', nullable: true)
  String name;
  @JsonKey(name: 'mobile_number', nullable: true)
  int mobileNumber;
  @JsonKey(name: 'password', nullable: false)
  String password;
  @JsonKey(name: 'gender', nullable: true)
  String gender;
  @JsonKey(name: 'date_of_birth', nullable: true)
  String dateOfBirth;
  @JsonKey(name: 'last_signed_in_at', nullable: true)
  DateTime lastSignInTime;
  @JsonKey(name: 'address', nullable: true)
  Address address;

  User(id, email) {
    this.id = id;
    this.email = email;
  }

  setPassword(String password) {
    this.password = password;
  }

  setGender(Gender val) {
    switch(val) {
      case Gender.Male:
        this.gender = "Male";
        break;
      case Gender.Female:
        this.gender = "Female";
        break;
    }
  }

  setName(String name) {
    this.name = name;
  }

  setMobileNumber(int number) {
    this.mobileNumber = number;
  }

  setDOB(date) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.dateOfBirth = formatter.format(date);
  }

  setLastSignInTime(DateTime dateTime) {
    this.lastSignInTime = dateTime;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  CollectionReference getCollectionRef() {
    return _userCollRef;
  }

  create() async {
    dynamic result = await super.add(this.toJson());
    print(result);
  }

}