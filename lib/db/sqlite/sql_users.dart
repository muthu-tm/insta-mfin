import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/database_helper.dart';
import 'dart:async';

class UserAuth {
  DatabaseHelper con = new DatabaseHelper();
  
  Future<int> saveUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.insert("users", user.toJson());

    return res;
  }

  Future<int> deleteUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.delete("users");
    
    return res;
  }

  Future getLogin(String emailID, String passkey) async {
    var dbClient = await con.db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM users WHERE email = '$emailID' and password = '$passkey'");

    if (res.length > 0) {
      return res.first;
    }

    return null;
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await con.db;
    var res = await dbClient.query("users");

    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromJson(c)).toList() : null;
    return list;
  }
}
