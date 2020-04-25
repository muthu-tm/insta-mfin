import 'package:flutter/material.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/screens/settings/editors/EditFinanceProfile.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';

class FinanceProfileWidget extends StatelessWidget {
  final FinanceController _financeController = FinanceController();

  FinanceProfileWidget(this.financeID);

  final String financeID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Finance>(
        future: _financeController.getFinanceByID(financeID),
        builder: (BuildContext context, AsyncSnapshot<Finance> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            children = <Widget>[
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: snapshot.data.financeName,
                  decoration: InputDecoration(
                    hintText: 'Finance Name',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: snapshot.data.registrationID,
                  decoration: InputDecoration(
                    hintText: 'Registered ID',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: snapshot.data.dateOfRegistration,
                  decoration: InputDecoration(
                    hintText: 'Registered Date',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: snapshot.data.contactNumber,
                  decoration: InputDecoration(
                    hintText: 'Contact Number',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: new TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: snapshot.data.emailID,
                  decoration: InputDecoration(
                    hintText: 'Finance EmailID',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinWhite)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: snapshot.data.address.toString(),
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Finance Address',
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
            ];
          } else if (snapshot.hasError) {
            children = AsyncWidgets.asyncError();
          } else {
            children = AsyncWidgets.asyncWaiting();
          }

          return new Card(
            color: CustomColors.mfinLightGrey,
            child: new Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.account_balance,
                      size: 30,
                      color: CustomColors.mfinButtonGreen,
                    ),
                    title: new Text(
                      "Finance Details",
                      style: TextStyle(color: CustomColors.mfinBlue),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 30,
                        color: CustomColors.mfinBlue,
                      ),
                      onPressed: () {
                        if (snapshot.hasData) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditFinanceProfile(snapshot.data)),
                          );
                        } else {
                          Scaffold.of(context).showSnackBar(
                              CustomSnackBar.errorSnackBar("Unable to open Editor! Finance not loaded correctly!", 3));
                        }
                      },
                    )),
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
        });
  }
}
