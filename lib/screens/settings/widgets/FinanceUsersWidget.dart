import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/FinanceViewUser.dart';
import 'package:instamfin/screens/settings/add/AddAdminPage.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';

class FinanceUsersWidget extends StatelessWidget {
  final FinanceController _financeController = FinanceController();

  FinanceUsersWidget(this.financeID);

  final String financeID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
        future: _financeController.getAllAdmins(financeID),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              children = <Widget>[
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: TextFormField(
                            keyboardType: TextInputType.text,
                            initialValue: snapshot.data[index].toString(),
                            decoration: InputDecoration(
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              suffixIcon: customIconButton(Icons.navigate_next,
                                  35.0, CustomColors.mfinBlue, null),
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
                                    snapshot.data[index].toString()),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              size: 35.0,
                              color: CustomColors.mfinAlertRed,
                            ),
                            onPressed: () {},
                          ));
                    }),
              ];
            } else {
              children = <Widget>[
                Text("No User"),
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
                        String financeName =
                            await _financeController.getFinanceName(financeID);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAdminPage(
                                'Add Admin - $financeName',
                                financeName,
                                financeID),
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
          );
        });
  }
}
