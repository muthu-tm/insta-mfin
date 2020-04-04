import 'package:json_annotation/json_annotation.dart' as json;
import 'package:instamfin/db/sqlite/address_converter.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'sql_users.g.dart';

@json.JsonSerializable()
class UserAddress {
  
  @json.JsonKey(name: 'street', nullable: false)
  String street;
  @json.JsonKey(name: 'city', nullable: true)
  String city;
  @json.JsonKey(name: 'state', nullable: false)
  String state;
  @json.JsonKey(name: 'country', defaultValue: 'India')
  String country;
  @json.JsonKey(name: 'pincode', nullable: false)
  int pincode;

  UserAddress(this.street, this.city, this.state, this.pincode);

  factory UserAddress.fromJson(Map<String, dynamic> json) => _$UserAddressFromJson(json);
  Map<String, dynamic> toJson() => _$UserAddressToJson(this);
}

@DataClassName('User')
class UserModel extends Table {
  TextColumn get id => text().named('id')();
  TextColumn get name => text().named('user_name').nullable()();
  TextColumn get email => text().named('email')();
  IntColumn get mobileNumber => integer().named('mobile_number').nullable()();
  TextColumn get password => text().named('password')();
  TextColumn get gender => text().named('gender').nullable()();
  DateTimeColumn get dateOfBirth =>
      dateTime().named('date_of_birth').nullable()();
  DateTimeColumn get lastSignInTime =>
      dateTime().named('last_signed_in_at').nullable()();
  TextColumn get address =>
      text().map(const AddressConverter()).nullable()();
}

@UseMoor(tables: [UserModel])
class UserDatabase extends _$UserDatabase {
  UserDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'test.db', logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<User>> getAllUsers() => select(userModel).get();
  Stream<List<User>> watchAllUsers() => select(userModel).watch();
  Future insertUser(User user) => into(userModel).insert(user);
  Future updateUser(User user) => update(userModel).replace(user);
  Future deleteUser(User user) => delete(userModel).delete(user);
}
