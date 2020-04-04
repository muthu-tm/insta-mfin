import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instamfin/screens/authenticate.dart';
import './../customer/profile.dart';
import './../db/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      
      final user = Provider.of<User>(context);
      if (user == null) {
        return Authenticate();
      } else {
        print("SIGNED IN");
        return CustomerTransactionScreen(); 
      }
      // return either the Home or Authenticate screen
  }
}