import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({this.toggleView});

  final Function toggleView;

  @override
  _AddAdminPageState createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final User user = User(userState.mobileNumber);
  Map<String, dynamic> _userDetails;
  bool searchTriggered = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Admin'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height * 1.16,
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
                        "\n\nThis user will get ADMIN access over your selected \n. And the user can add/edit other user to this.\n\n",
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
                    if (value.length >= 7) {
                      _userDetails = user.getByID();
                      searchTriggered = true;
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: CustomColors.mfinGrey,
                      filled: true,
                      hintText: "Search user by mobile number",
                      prefixIcon:
                          Icon(Icons.search, color: CustomColors.mfinBlue),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              new Expanded(
                child: searchTriggered
                    ? new ListView.builder(
                        itemCount: _userDetails.length,
                        itemBuilder: (context, index) {
                          return new Card(
                            child: new ListTile(
                              leading: Icon(
                                Icons.person,
                                color: CustomColors.mfinButtonGreen,
                                size: 50,
                              ),
                              title: new Text(
                                _userDetails[index].name,
                                style: TextStyle(
                                  color: CustomColors.mfinLightGrey,
                                ),
                              ),
                              subtitle: new Text(
                                _userDetails[index].mobileNumber,
                                style: TextStyle(
                                  color: CustomColors.mfinLightGrey,
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.all(0.0),
                          );
                        },
                      )
                    : null,
              ),
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
                    setState(() {});
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
}
