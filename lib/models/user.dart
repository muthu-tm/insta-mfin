import 'package:instamfin/models/address.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'gender_enum.dart';
part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String email;
  String name;
  int mobileNumber;
  String password;
  String gender;
  String dateOfBirth;
  Address address;

  User(String email, String name, int mobileNumber, String password, Gender gender, String dateOfBirth, Address address) {
    this.email = email;
    this.name = name;
    this.mobileNumber = mobileNumber;
    this.password = password;
    this.address = address;

    setGender(gender);
    formatDOB(dateOfBirth);
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

  formatDOB(date) {
    var formatter = new DateFormat('dd-MM-yyyy');
    this.dateOfBirth = formatter.format(date);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}