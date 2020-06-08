import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/editors/EditPrimaryFinance.dart';
import 'package:instamfin/screens/utils/AddFinanceWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class PrimaryFinanceWidget extends StatelessWidget {
  final UserController _userController = UserController();

  PrimaryFinanceWidget(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _userController.getPrimaryFinanceDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            if (snapshot.data['finance_name'] != null) {
              children = <Widget>[
                ListTile(
                  leading: Icon(Icons.account_balance,
                      color: CustomColors.mfinBlue, size: 30.0),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: snapshot.data['finance_name'],
                    decoration: InputDecoration(
                      hintText: 'Company Name',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey),
                      ),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.view_stream,
                      color: CustomColors.mfinBlue, size: 30.0),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: snapshot.data['branch_name'],
                    decoration: InputDecoration(
                      hintText: 'Branch Name',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey),
                      ),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.view_headline,
                      color: CustomColors.mfinBlue, size: 30.0),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: snapshot.data['sub_branch_name'],
                    decoration: InputDecoration(
                      hintText: 'SubBranch Name',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      enabled: false,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
              ];
            } else {
              children = <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Registered Financier? Great!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 17,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: CustomColors.mfinButtonGreen,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 50,
                      child: FlatButton.icon(
                        icon: Icon(
                          Icons.edit,
                          size: 35.0,
                          color: CustomColors.mfinButtonGreen,
                        ),
                        label: Text(
                          "Set Primary Finance!",
                          style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 17.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPrimaryFinance(
                                _userController.getCurrentUserID(),
                              ),
                              settings: RouteSettings(
                                  name: '/settings/user/primary/edit'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: new Text(
                    "OR",
                    style: TextStyle(
                      color: CustomColors.mfinGrey,
                      fontSize: 17.0,
                      fontFamily: 'Georgia',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AddFinanceWidget(),
              ];
            }
          } else if (snapshot.hasError) {
            children = AsyncWidgets.asyncError();
          } else {
            children = AsyncWidgets.asyncWaiting();
          }

          return new Card(
            color: CustomColors.mfinLightGrey,
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.work,
                        size: 35.0,
                        color: CustomColors.mfinFadedButtonGreen,
                      ),
                      title: new Text(
                        title,
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 35.0,
                          color: CustomColors.mfinBlue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPrimaryFinance(
                                _userController.getCurrentUserID(),
                              ),
                              settings: RouteSettings(
                                  name: '/settings/user/primary/edit'),
                            ),
                          );
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
            ),
          );
        });
  }
}
