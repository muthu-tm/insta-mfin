import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instamfin/screens/home/Authenticate.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/db/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      
      final user = Provider.of<User>(context);
      if (user == null) {
        return Authenticate();
      } else {
        return UserHomeScreen(); 
      }
  }
}