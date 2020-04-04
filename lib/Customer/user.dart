import 'package:flutter/material.dart';
import 'package:instamfin/AppMain/appBar.dart';
import 'package:instamfin/AppMain/bottomBar.dart';
import 'package:instamfin/Common/CustomTextField.dart';


class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: topAppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              title: customTextField('Add Customer', Colors.grey[350],
                  Icons.send,Icons.person_add, Colors.black)
            ),
            new ListTile(
              title: customTextField('View All Customers', Colors.grey[350],
                  Icons.send, Icons.people,Colors.black),
            ),
            new ListTile(
              title: customTextField('View Active Customers', Colors.grey[350],
                  Icons.send, Icons.people,Colors.green),
            ),
            new ListTile(
              title: customTextField('NIP/Pending Customer List', Colors.grey[350],
                  Icons.send,Icons.people,Colors.red),
            ),
          ],
        ),
      ),
    bottomSheet: bottomBar(context),
    );
  }
}
