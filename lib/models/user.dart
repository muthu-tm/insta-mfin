import 'package:instamfin/models/address.dart';
import 'package:instamfin/models/model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'gender_enum.dart';
part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Model {
  
  static CollectionReference _userCollRef = Model.db.collection("user");

  String id;
  String email;
  String name;
  int mobileNumber;
  String password;
  String gender;
  String dateOfBirth;
  DateTime lastSignInTime;
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

  setLastSignInTime(dateTime) {
    this.lastSignInTime = dateTime;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  CollectionReference getCollectionRef() {
    return _userCollRef;
  }

  create() async {
    var data = {
      'id': this.id,
      'email': this.email,
      'password': this.password,
      'user_name': this.name,
      'mobile_number': this.mobileNumber,
      'gender': this.gender,
      'date_of_birth': this.dateOfBirth,
      'last_signed_in_at': this.lastSignInTime,
      'address': this.address
    };

    dynamic result = await super.add(data);
    print(result);

  }

}