import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class BranchSetting extends StatefulWidget {
  const BranchSetting({this.toggleView});

  final Function toggleView;

  @override
  _BranchSettingState createState() => _BranchSettingState();
}

class _BranchSettingState extends State<BranchSetting> {
  bool branchStatus = false;
  final FocusNode myFocusNode = FocusNode();

  bool subBranchStatus = false;

  @override
  void initState() {
    super.initState();
  }

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
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Card(
                child: new Container(
                  color: CustomColors.mfinGrey,
                  child: new Card(
                    color: CustomColors.mfinLightGrey,
                    child: new Column(
                      children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.view_list, size: 30),
                            title: new Text(
                              "Branch Details",
                              style: TextStyle(color: CustomColors.mfinBlue),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: CustomColors.mfinBlue,
                              ),
                              onPressed: () {
                                setState(() {
                                  branchStatus = true;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              },
                            )),
                        ListTile(
                          title: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Branch_Name01',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: CustomColors.mfinGrey)),
                            ),
                            enabled: branchStatus,
                            autofocus: branchStatus,
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Registered Date',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: CustomColors.mfinGrey)),
                            ),
                            enabled: branchStatus,
                            autofocus: branchStatus,
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Address',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: CustomColors.mfinGrey)),
                            ),
                            enabled: branchStatus,
                            autofocus: branchStatus,
                          ),
                        ),
                        new Text(""),
                      ],
                    ),
                  ),
                ),
              ),
              new Spacer(),
              new Card(
                child: new Container(
                  color: CustomColors.mfinGrey,
                  child: new Card(
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
                                setState(() {
                                  branchStatus = true;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              },
                            )),
                        ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Sub_Branch_Name01',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                suffixIcon: customIconButton(
                                    Icons.navigate_next,
                                    35.0,
                                    CustomColors.mfinBlue,
                                    null),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinGrey)),
                              ),
                              enabled: subBranchStatus,
                              autofocus: subBranchStatus,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: CustomColors.mfinAlertRed,
                              ),
                              onPressed: () {
                                setState(() {
                                  branchStatus = true;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              },
                            )),
                                                    ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Sub_Branch_Name02',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                suffixIcon: customIconButton(
                                    Icons.navigate_next,
                                    35.0,
                                    CustomColors.mfinBlue,
                                    null),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinGrey)),
                              ),
                              enabled: subBranchStatus,
                              autofocus: subBranchStatus,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: CustomColors.mfinAlertRed,
                              ),
                              onPressed: () {
                                setState(() {
                                  branchStatus = true;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              },
                            )),
                                                    ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Sub_Branch_Name03',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                suffixIcon: customIconButton(
                                    Icons.navigate_next,
                                    35.0,
                                    CustomColors.mfinBlue,
                                    null),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinGrey)),
                              ),
                              enabled: subBranchStatus,
                              autofocus: subBranchStatus,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: CustomColors.mfinAlertRed,
                              ),
                              onPressed: () {
                                setState(() {
                                  subBranchStatus = true;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                });
                              },
                            )),
                        new Text(""),
                      ],
                    ),
                  ),
                ),
              ),
              new Spacer(),
            ]),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
