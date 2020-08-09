import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/settings/BranchSetting.dart';
import 'package:instamfin/screens/settings/add/AddNewBranch.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/app_localizations.dart';

class FinanceBranchWidget extends StatelessWidget {
  FinanceBranchWidget(this.financeID);

  final String financeID;

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> nameController = <TextEditingController>[];

    return StreamBuilder<QuerySnapshot>(
      stream: Branch().streamAllBranches(financeID),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            nameController.clear();
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              TextEditingController _controller = TextEditingController();
              _controller.text = snapshot.data.documents[i].data['branch_name'];
              nameController.insert(i, _controller);
            }

            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  print(snapshot.data.documents[index].data['branch_name']);
                  return ListTile(
                    title: TextFormField(
                      controller: nameController[index],
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 5.0,
                        ),
                        suffixIcon: Icon(
                          Icons.navigate_next,
                          size: 35.0,
                          color: CustomColors.mfinBlue,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey),
                        ),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BranchSetting(
                            financeID,
                            snapshot.data.documents[index].data['branch_name'],
                          ),
                          settings:
                              RouteSettings(name: '/settings/finance/branch'),
                        ),
                      );
                    },
                  );
                },
              ),
            ];
          } else {
            // No branches available
            children = [
              Container(
                height: 120,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      AppLocalizations.of(context).translate('no_branches_yet'),
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('by_creating_new_branch'),
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
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
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.view_stream,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                title: Text(
                  AppLocalizations.of(context).translate('branch_details'),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBranch(financeID),
                        settings:
                            RouteSettings(name: '/settings/finance/branch/add'),
                      ),
                    );
                  },
                ),
              ),
              Divider(
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
