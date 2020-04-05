import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/auth_wrapper.dart';
import 'services/authenticate/auth.dart';
import 'package:provider/provider.dart';
import 'db/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return StreamProvider<User>.value(
      value: AuthService().user,
      catchError: (_, err) => null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
