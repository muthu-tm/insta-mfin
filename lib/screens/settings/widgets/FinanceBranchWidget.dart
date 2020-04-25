import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';

class FinanceBranchWidget extends StatelessWidget {
  final FinanceController _financeController = FinanceController();

  FinanceBranchWidget(this.financeID);

  final String financeID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Branch>>(
        future: _financeController.getAllBranches(financeID),
        builder: (BuildContext context, AsyncSnapshot<List<Branch>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              children = <Widget>[
                ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: TextFormField(
                            keyboardType: TextInputType.text,
                            initialValue: snapshot.data[index].branchName,
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
                          trailing: IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: CustomColors.mfinAlertRed,
                            ),
                            onPressed: () {},
                          ));
                    }),
              ];
            } else {
              // No branches for the finance
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
                      Icons.view_stream,
                      size: 30,
                      color: CustomColors.mfinButtonGreen,
                    ),
                    title: new Text(
                      "Branch Details",
                      style: TextStyle(color: CustomColors.mfinBlue),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_box,
                        color: CustomColors.mfinBlue,
                      ),
                      onPressed: () {},
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
