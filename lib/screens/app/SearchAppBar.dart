import 'package:flutter/material.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListTile.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
}

CustController _custController = CustController();
int custNumber = 0;
var custList;

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: CustomColors.mfinBlue,
          centerTitle: true,
          title: new TextFormField(
            style: new TextStyle(
              color: CustomColors.mfinWhite,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the customer number';
              } else {
                setState(() {
                  custNumber = value.trim() as int;
                });
              }
            },
            decoration: new InputDecoration(
                prefixIcon: customIconButton(
                    Icons.search, 35.0, CustomColors.mfinWhite, () {
                  setState(() {
                    custList = _custController.searchCustomer(750275);
                  });
                }),
                hintText: "Customer Search...",
                hintStyle: new TextStyle(color: CustomColors.mfinWhite)),
          ),
          actions: <Widget>[
            customIconButton(Icons.close, 35.0, CustomColors.mfinWhite, () {}),
          ]),
      body: customerListTile(context, custNumber, custList),
    );
  }
}
