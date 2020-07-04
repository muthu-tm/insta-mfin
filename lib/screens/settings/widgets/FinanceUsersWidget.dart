import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/screens/settings/FinanceViewUser.dart';
import 'package:instamfin/screens/settings/add/AddAdminPage.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class FinanceUsersWidget extends StatelessWidget {
  FinanceUsersWidget(this.financeID);
  final Finance _finance = Finance();

  final String financeID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _finance.getCollectionRef().document(financeID).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.data['admins'] != null &&
              snapshot.data.data['admins'].length > 0) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.data['admins'].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue:
                          snapshot.data.data['admins'][index].toString(),
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        suffixIcon: customIconButton(Icons.navigate_next, 35.0,
                            CustomColors.mfinBlue, null),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinGrey)),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinanceUser(
                              snapshot.data.data['admins'][index].toString()),
                          settings:
                              RouteSettings(name: '/settings/finance/admin'),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        size: 35.0,
                        color: CustomColors.mfinAlertRed,
                      ),
                      onPressed: () {
                        int userID = snapshot.data.data['admins'][index];
                        UserController _uc = UserController();
                        if (userID == _uc.getCurrentUserID()) {
                          CustomDialogs.information(
                              context,
                              "Warning",
                              CustomColors.mfinAlertRed,
                              "You cannot remove yourself");
                        } else {
                          String financeName =
                              snapshot.data.data['finance_name'];
                          CustomDialogs.confirm(
                            context,
                            "Confirm",
                            "Are you sure to remove $userID from $financeName",
                            () async {
                              FinanceController _fc = FinanceController();
                              await _fc.updateFinanceAdmins(
                                  false, [userID], financeID);
                              Navigator.pop(context);
                            },
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ];
          } else {
            children = <Widget>[
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    Text(
                      "No Admins yet!",
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                      ),
                    ),
                    new Spacer(
                      flex: 2,
                    ),
                    Text(
                      "Add admins to manage your Finance!",
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                title: new Text(
                  "User Details",
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.add_box,
                    size: 35.0,
                    color: CustomColors.mfinBlue,
                  ),
                  onPressed: () async {
                    String financeName = snapshot.data.data['finance_name'];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAdminPage(
                            'Add Admin - $financeName', financeName, financeID),
                      ),
                    );
                  },
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
                thickness: 1,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
