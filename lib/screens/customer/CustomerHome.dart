import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/customer/AddCustomer.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topAppBar(context),
      drawer: openDrawer(context),
      body: new Container(
        height: MediaQuery.of(context).size.height * 0.80,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCustomer()),
                    );
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.person_add, 50.0, CustomColors.mfinBlue, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCustomer()),
                        );
                      }),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Add Customer",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.group, 50.0, CustomColors.mfinBlue, () {print("Pressed All Customers");}),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "All Customers",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.group, 50.0, CustomColors.mfinPositiveGreen, () {print("Pressed All Customers");}),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Active Customers",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinPositiveGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.group, 50.0, CustomColors.mfinAlertRed, () {print("Pressed All Customers");}),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Pending Customers",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinAlertRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                InkWell(
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      customIconButton(
                          Icons.group, 50.0, CustomColors.mfinGrey, () {print("Pressed All Customers");}),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Closed Customers",
                        style: TextStyle(
                          fontSize: 17,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
