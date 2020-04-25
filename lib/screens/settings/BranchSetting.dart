import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/add/AddAdminPage.dart';
import 'package:instamfin/screens/settings/editors/EditSubBranchProfile.dart';
import 'package:instamfin/screens/settings/widgets/BranchProfileWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class BranchSetting extends StatelessWidget {
  BranchSetting(this.branch);

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Branch Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.30,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  
                  BranchProfileWidget(branch),

                  new Card(
                    color: CustomColors.mfinLightGrey,
                    child: new Column(
                      children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.menu, size: 30),
                            title: new Text(
                              "Sub Branch Details",
                              style: TextStyle(color: CustomColors.mfinBlue),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.add_box,
                                color: CustomColors.mfinBlue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditSubBranchProfile()),
                                );
                              },
                            )),
                        ListTile(
                            title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Sub_Branch_Name01',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  suffixIcon: customIconButton(
                                      Icons.navigate_next,
                                      35.0,
                                      CustomColors.mfinBlue,
                                      null),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: false,
                                autofocus: false),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: CustomColors.mfinAlertRed,
                              ),
                              onPressed: () {},
                            )),
                        ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Sub_Branch_Name02',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                                suffixIcon: customIconButton(
                                    Icons.navigate_next,
                                    35.0,
                                    CustomColors.mfinBlue,
                                    null),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinGrey)),
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
                            )),
                        ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Sub_Branch_Name03',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                                suffixIcon: customIconButton(
                                    Icons.navigate_next,
                                    35.0,
                                    CustomColors.mfinBlue,
                                    null),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinGrey)),
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
                            )),
                      ],
                    ),
                  ),
                  new Card(
                    color: CustomColors.mfinLightGrey,
                    child: new Column(
                      children: <Widget>[
                        ListTile(
                            leading: Icon(
                              Icons.person_add,
                              size: 30,
                              color: CustomColors.mfinButtonGreen,
                            ),
                            title: new Text(
                              "Users",
                              style: TextStyle(color: CustomColors.mfinBlue),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.add_box,
                                color: CustomColors.mfinBlue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAdminPage()),
                                );
                              },
                            )),
                        ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'UserName1',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinGrey)),
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
                            )),
                        ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'UserName2',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinGrey)),
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
                            )),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
