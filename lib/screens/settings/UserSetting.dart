import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({this.toggleView});

  final Function toggleView;

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  bool financeStatus = false;
  final FocusNode myFocusNode = FocusNode();

  bool profileStatus = false;

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
        title: Text('User Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.10,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Card(
                    child: new Container(
                      color: CustomColors.mfinGrey,
                      child: new Card(
                        color: CustomColors.mfinLightGrey,
                        child: new Column(
                          children: <Widget>[
                            ListTile(
                                leading: Icon(
                                  Icons.work,
                                  size: 30,
                                  color: CustomColors.mfinFadedButtonGreen,
                                ),
                                title: new Text(
                                  "Finance Details",
                                  style:
                                      TextStyle(color: CustomColors.mfinBlue),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: CustomColors.mfinBlue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      financeStatus = true;
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    });
                                  },
                                )),
                            ListTile(
                              leading: Icon(Icons.account_balance,
                                  color: CustomColors.mfinBlue, size: 30.0),
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Company_Name',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 3.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: financeStatus,
                                autofocus: financeStatus,
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.view_stream,
                                  color: CustomColors.mfinBlue, size: 30.0),
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Branch_Name',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 3.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: financeStatus,
                                autofocus: financeStatus,
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.view_headline,
                                  color: CustomColors.mfinBlue, size: 30.0),
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Sub_Branch',
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 3.0),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: financeStatus,
                                autofocus: financeStatus,
                              ),
                            ),
                            new Text(""),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Card(
                    child: new Container(
                      color: CustomColors.mfinGrey,
                      child: new Card(
                        color: CustomColors.mfinLightGrey,
                        child: new Column(
                          children: <Widget>[
                            ListTile(
                                leading: Icon(
                                  Icons.menu,
                                  size: 30,
                                  color: CustomColors.mfinFadedButtonGreen,
                                ),
                                title: new Text(
                                  "Profile Details",
                                  style:
                                      TextStyle(color: CustomColors.mfinBlue),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: CustomColors.mfinBlue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      profileStatus = true;
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    });
                                  },
                                )),
                            ListTile(
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'User_name',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 3.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: CustomColors.mfinGrey,
                                  )),
                                ),
                                enabled: profileStatus,
                                autofocus: profileStatus,
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Mobile_Number',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 1.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: profileStatus,
                                autofocus: profileStatus,
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 1.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: profileStatus,
                                autofocus: profileStatus,
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Gender',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 1.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: profileStatus,
                                autofocus: profileStatus,
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Date_Of_Birth',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 1.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: profileStatus,
                                autofocus: profileStatus,
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                keyboardType: TextInputType.text,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 1.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinGrey)),
                                ),
                                enabled: profileStatus,
                                autofocus: profileStatus,
                              ),
                            ),
                            new Text(""),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Spacer(),
                ]),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
