import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/widgets/UserProfileWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class FinanceUser extends StatelessWidget {
  final UserController _userController = UserController();
  FinanceUser(this.userID);

  final String userID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _userController.getUserByID(userID),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          Container container;

          if (snapshot.hasData) {
            container = Container(
              child: UserProfileWidget(snapshot.data, "User Details"),
            );
          } else if (snapshot.hasError) {
            container = Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: AsyncWidgets.asyncError(),
                ),
              ),
            );
          } else {
            container = Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: AsyncWidgets.asyncWaiting(),
                ),
              ),
            );
          }

          return new Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(userID),
              backgroundColor: CustomColors.mfinBlue,
            ),
            body: container,
          );
        });
  }
}
