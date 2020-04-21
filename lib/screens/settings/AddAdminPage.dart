import 'package:flutter/material.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({this.toggleView});

  final Function toggleView;

  @override
  _AddAdminPageState createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final UserController userController = UserController();
  final FinanceController financeController = FinanceController();
  Finance finance = new Finance();

  Map<String, dynamic> _userDetails;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<int> userList = new List<int>();
  List<bool> userStatusList = new List<bool>();

  bool searchTriggered = false;
  bool showSearch = false;
  bool userSelected = false;

  var mobileNumber;
  var primaryFinanceName;

  bool mobileNumberValid = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Admin'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height * 0.80,
          color: CustomColors.mfinLightGrey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Card(
                child: new Container(
                  color: CustomColors.mfinBlue,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("\n Important!",
                          style: TextStyle(
                              color: CustomColors.mfinAlertRed, fontSize: 13)),
                      new Text(
                        "\n\nThis user will get ADMIN access over your selected \n . And the user can add/edit other user to this.\n\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: CustomColors.mfinAlertRed, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    mobileNumber = value;
                  },
                  decoration: InputDecoration(
                      fillColor: CustomColors.mfinGrey,
                      filled: true,
                      hintText: "Search user by mobile number",
                      errorText: !mobileNumberValid
                          ? 'Enter the valid 10 digit MobileNumber'
                          : null,
                      suffixIcon: customIconButton(
                          Icons.search, 30.0, CustomColors.mfinBlue, () async {
                        if (mobileNumber.length == 10) {
                          Map<String, dynamic> apiResponse =
                              await userController
                                  .getByMobileNumber(int.parse(mobileNumber));
                          if (apiResponse['is_success']) {
                            setState(() {
                              _userDetails = apiResponse['message'];
                              mobileNumberValid = true;
                            });
                            print(_userDetails.toString());
                            searchTriggered = true;
                          } else {
                            setState(() {
                              mobileNumberValid = true;
                              searchTriggered = false;
                              getListViewItems();
                            });
                          }
                        } else {
                          setState(() {
                            mobileNumberValid = false;
                            searchTriggered = false;
                          });
                        }
                      }),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              new Card(
                child: searchTriggered
                    ? new Container(
                        color: CustomColors.mfinBlue,
                        child: new ListTile(
                          leading: Icon(
                            Icons.person,
                            color: CustomColors.mfinButtonGreen,
                            size: 50,
                          ),
                          title: new Text(
                            _userDetails['user_name'],
                            style: TextStyle(
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                          subtitle: new Text(
                            _userDetails['mobile_number'].toString(),
                            style: TextStyle(
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                          trailing: Checkbox(
                            value: userSelected,
                            onChanged: (bool value) {
                              setState(() {
                                userSelected = value;
                                if (value == true && !userList.contains(mobileNumber)) {
                                  userList.add(_userDetails['mobile_number']);
                                  primaryFinanceName =
                                      _userDetails['primary_company'];
                                }
                              });
                            },
                          ),
                        ),
                      )
                    : new Container(),
              ),
              // new Expanded(
              //   child: searchTriggered
              //       ? new ListView.builder(
              //           itemCount: userList.length,
              //           itemBuilder: (context, index) {
              //             return new Container(
              //               color: CustomColors.mfinBlue,
              //               child: new ListTile(
              //                   leading: Icon(
              //               Icons.person,
              //               color: CustomColors.mfinButtonGreen,
              //               size: 50,
              //             ),
              //             title: new Text(
              //               _userDetails['user_name'],
              //               style: TextStyle(
              //                 color: CustomColors.mfinLightGrey,
              //               ),
              //             ),
              //             subtitle: new Text(
              //               _userDetails['mobile_number'].toString(),
              //               style: TextStyle(
              //                 color: CustomColors.mfinLightGrey,
              //               ),
              //             ),
              //                   trailing: IconButton(
              //                     icon: Icon(
              //                       Icons.remove_circle,
              //                       color: CustomColors.mfinAlertRed,
              //                     ),
              //                     onPressed: () {
              //                       setState(() {
              //                         getListViewItems(
              //                             userList.elementAt(index).toString());
              //                       });
              //                     },
              //                   )),
              //             );
              //           },
              //         )
              //       : new Container(),
              // ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(left: 15.0, right: 25.0, top: 25.0),
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
                  textColor: CustomColors.mfinButtonGreen,
                  color: CustomColors.mfinBlue,
                  onPressed: () {
                    setState(() {
                      financeController.updateFinanceAdmins(
                          userSelected, userList, primaryFinanceName);
                    });
                  },
                )),
              ),
              flex: 2,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Container(
                    child: new RaisedButton(
                  child: new Text("Close"),
                  textColor: CustomColors.mfinAlertRed,
                  color: CustomColors.mfinBlue,
                  onPressed: () {
                    setState(() {});
                  },
                )),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  getListViewItems() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("No results Found",           style: TextStyle(
                              color: CustomColors.mfinBlue,fontSize: 16.0
                            ),),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
                 FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  removeUser(String userID) {
    setState(() => userList.removeWhere((data) => data == userID));
  }
}
