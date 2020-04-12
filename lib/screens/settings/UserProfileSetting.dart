import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/field_validator.dart';

class Branch {
  const Branch(this.name, this.branchId);

  final String name;
  final String branchId;
}

class UserProfileSetting extends StatefulWidget {
  const UserProfileSetting({this.toggleView});

  final Function toggleView;

  @override
  _UserProfileSettingState createState() => _UserProfileSettingState();
}

class _UserProfileSettingState extends State<UserProfileSetting> {
  bool _status = true;
  String mobileNumber = "9578632283";

  final FocusNode myFocusNode = FocusNode();
  final User user = User("mobileNumber");

  Branch selectedBranch;
  List<Branch> branches = <Branch>[
    const Branch('Dindigul Main', "1"),
    const Branch('Kannivadi Main', "2")
  ];
  Map<String, String> userProfileSettingsMap = {
    'mobile_number': "+91 9578632283",
    'name': 'Vale Muthu',
    'password': 'Vale@2018',
    'gender': 'Male',
    'display_profile_path': '2',
    'date_of_birth': '21/21/21',
    'primary_sub_branch': 'Dindigul Main',
    'primary_branch': 'Chennai',
    'primary_company': 'Tamilnadu',
  };

  var _groupValue;

  var _myActivity;

  var _controller;

  var groupValue = -1;

  String name;
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
      body: new Container(
        color: CustomColors.mfinGrey,
        child: new ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                                initialValue:
                                    userProfileSettingsMap['mobile_number'],
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: "Mobile Number",
                                  hintText: "Enter Your Mobile number",
                                  filled: true,
                                  fillColor: CustomColors.mfinGrey,
                                ),
                                enabled: !_status,
                                autofocus: !_status,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your Mobile Number';
                                  }

                                  setState(() => mobileNumber = value.trim());
                                  return null;
                                }),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                                keyboardType: TextInputType.text,
                                initialValue: userProfileSettingsMap['name'],
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                  hintText: "Enter the User Name",
                                  filled: true,
                                  fillColor: CustomColors.mfinGrey,
                                ),
                                enabled: !_status,
                                autofocus: !_status,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your Name';
                                  }

                                  setState(() => user.setName(value.trim()));
                                  return null;
                                }),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: userProfileSettingsMap['password'],
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                hintText: "Enter the Password",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              validator: (passkey) =>
                                  FieldValidator.passwordValidator(
                                      passkey, user.setPassword(passkey)),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                                keyboardType: TextInputType.datetime,
                                initialValue:
                                    userProfileSettingsMap['date_of_birth'],
                                decoration: const InputDecoration(
                                  labelText: "Date of Birth",
                                  hintText: "Enter Your Date of Birth",
                                  filled: true,
                                  fillColor: CustomColors.mfinGrey,
                                ),
                                enabled: !_status,
                                autofocus: !_status,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your Date of Birth';
                                  }

                                  setState(() => user.setDOB(value));
                                  return null;
                                }),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(" Gender",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black38,
                                  )),
                              Radio(
                                value: "Male",
                                groupValue: groupValue,
                                activeColor: CustomColors.mfinBlue,
                                onChanged: !_status
                                    ? (val) {
                                        setSelectedRadio(val);
                                      }
                                    : null,
                              ),
                              Text(
                                "Male",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black38,
                                ),
                              ),
                              Radio(
                                value: "Female",
                                groupValue: groupValue,
                                activeColor: CustomColors.mfinBlue,
                                onChanged: !_status
                                    ? (val) {
                                        setSelectedRadio(val);
                                      }
                                    : null,
                              ),
                              Text(
                                "FeMale",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              initialValue:
                                  userProfileSettingsMap['primary_company'],
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: "Primary Company",
                                hintText: "Choose your primary company",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    _controller.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return branches.map<PopupMenuItem<String>>(
                                        (Branch branch) {
                                      return new PopupMenuItem(
                                          child: new Text(branch.name),
                                          value: branch.name);
                                    }).toList();
                                  },
                                ),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              initialValue:
                                  userProfileSettingsMap['primary_branch'],
                              decoration: InputDecoration(
                                labelText: "Primary Branch",
                                hintText: "Choose your primary branch",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String branchID) {
                                    user.setPrimaryBranch(branchID);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return branches.map<PopupMenuItem<String>>(
                                        (Branch branch) {
                                      return new PopupMenuItem(
                                          child: new Text(branch.name),
                                          value: branch.branchId);
                                    }).toList();
                                  },
                                ),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              initialValue:
                                  userProfileSettingsMap['primary_sub_branch'],
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: "Primary Sub Branch",
                                hintText: "Choose your primary  sub branch",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String subBranchID) {
                                    user.setPrimarySubBranchID(subBranchID);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return branches.map<PopupMenuItem<String>>(
                                        (Branch branch) {
                                      return new PopupMenuItem(
                                          child: new Text(branch.name),
                                          value: branch.branchId);
                                    }).toList();
                                  },
                                ),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                            ),
                          ),
                        ],
                      ),
                      !_status ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: new Container(
          color: CustomColors.mfinGrey,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _status ? _getEditIcon() : new Row(),
                ],
              )
            ],
          )),
      bottomNavigationBar: bottomBar(context),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: CustomColors.mfinWhite,
                color: CustomColors.mfinButtonGreen,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: CustomColors.mfinWhite,
                color: CustomColors.mfinAlertRed,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _saveUser();
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: CustomColors.mfinBlue,
        radius: 30.0,
        child: new Icon(
          Icons.edit,
          color: CustomColors.mfinWhite,
          size: 35.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  setSelectedRadio(int val) {
    setState(() {
      groupValue = val;
    });
  }

  void _saveUser() async {
    var result = await user.create();
  }
}
