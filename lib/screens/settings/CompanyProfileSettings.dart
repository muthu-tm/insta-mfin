import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CompanyProfileSetting extends StatefulWidget {

  @override
  _CompanyProfileSettingState createState() => _CompanyProfileSettingState();
}

class _CompanyProfileSettingState extends State<CompanyProfileSetting> {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  Map<String, String> companySettingsMap = {
    'registration_id': "SSTIN",
    'allocated_branch_count': '2',
    'available_branch_count': '2',
    'allocated_users_count': '2',
    'available_users_count': '2',
    'finance_name': 'A&E Specialties',
    'street': '1/157 East Street',
    'city': 'Dindigul',
    'state': 'Tamilnadu',
    'pin_code': '624705',
    'country': 'India',
    'date_of_registration': '21/21/21'
  };

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
        title: Text('Company Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Container(
        color: CustomColors.mfinGrey,
        child: new ListView(
          children: <Widget>[
            Column(
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
                                  companySettingsMap['registration_id'],
                              decoration: const InputDecoration(
                                labelText: "Register ID",
                                hintText: "Enter Your company RegisterID",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue: companySettingsMap['finance_name'],
                              decoration: const InputDecoration(
                                labelText: "Finance Name",
                                hintText: "Enter Your Finance Name",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue:
                                  companySettingsMap['date_of_registration'],
                              decoration: const InputDecoration(
                                labelText: "Date of Registration",
                                hintText: "Enter Your date of registration",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue: companySettingsMap['street'],
                              decoration: const InputDecoration(
                                labelText: "Street/Area",
                                hintText: "Enter Your Street Name",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue: companySettingsMap['city'],
                              decoration: const InputDecoration(
                                labelText: "City",
                                hintText: "Enter Your City Name",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue: companySettingsMap['state'],
                              decoration: const InputDecoration(
                                labelText: "State",
                                hintText: "Enter Your State Name",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue: companySettingsMap['pin_code'],
                              decoration: const InputDecoration(
                                labelText: "Pin Code",
                                hintText: "Enter Your Area Pincode",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue: companySettingsMap['country'],
                              decoration: const InputDecoration(
                                labelText: "Country",
                                hintText: "INDIA",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
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
                            child: new TextFormField(
                              initialValue:
                                  companySettingsMap['allocated_branch_count'],
                              decoration: const InputDecoration(
                                labelText: "Allocated Branch Count",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                              ),
                              enabled: false,
                              autofocus: !_status,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              initialValue:
                                  companySettingsMap['available_branch_count'],
                              decoration: const InputDecoration(
                                labelText: "Available Branch Count",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                              ),
                              enabled: false,
                              autofocus: !_status,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              initialValue:
                                  companySettingsMap['allocated_users_count'],
                              decoration: const InputDecoration(
                                labelText: "Allocated Users Count",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                              ),
                              enabled: false,
                              autofocus: !_status,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              initialValue:
                                  companySettingsMap['available_users_count'],
                              decoration: const InputDecoration(
                                labelText: "Available Users Count",
                                filled: true,
                                fillColor: CustomColors.mfinGrey,
                              ),
                              enabled: false,
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
}
