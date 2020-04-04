import 'dart:convert';
import 'package:moor/moor.dart';
import 'package:instamfin/db/sqlite/sql_users.dart';

class AddressConverter extends TypeConverter<UserAddress, String> {
  const AddressConverter();

  @override
  UserAddress mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return UserAddress.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(UserAddress value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}