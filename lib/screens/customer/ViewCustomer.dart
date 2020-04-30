import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/customer/CustomerListWidget.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ViewCustomer extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _ViewCustomerState createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  int status = 0;
  String title = "New Customers";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: widget._scaffoldKey,
      appBar: topAppBar(context),
      drawer: openDrawer(context),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: status,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) =>
                                setSelectedRadio(val, "New Customer"),
                          ),
                          Text(
                            "New Customer",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: status,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) =>
                                setSelectedRadio(val, "Active Customer"),
                          ),
                          Text(
                            "Active Customer",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Radio(
                            value: 2,
                            groupValue: status,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) =>
                                setSelectedRadio(val, "Pending Customer"),
                          ),
                          Text(
                            "Pending Customer",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                          Radio(
                            value: 3,
                            groupValue: status,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) =>
                                setSelectedRadio(val, "Closed Customer"),
                          ),
                          Text(
                            "Closed Customer",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Radio(
                            value: 4,
                            groupValue: status,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) =>
                                setSelectedRadio(val, "Blocked Customer"),
                          ),
                          Text(
                            "Blocked Customer",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomerListWidget(widget._scaffoldKey, title, status),
          ],
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }

  setSelectedRadio(int val, String title) {
    setState(() {
      this.status = val;
      this.title = title;
    });
  }
}
