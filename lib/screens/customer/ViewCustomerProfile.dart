import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ViewCustomerProfile extends StatelessWidget {
  ViewCustomerProfile(this.customer);

  final Map<String, dynamic> customer;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(customer['customer_name']),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.assignment_ind,
                  size: 35.0,
                  color: CustomColors.mfinFadedButtonGreen,
                ),
                title: new Text(
                  "Customer Profile",
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinButtonGreen,
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "NAME",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['customer_name'],
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "ID",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['customer_id'],
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "CONTACT",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['mobile_number'].toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "PROFESSION",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['customer_profession'],
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "GENDER",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['gender'],
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "AGE",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['age'].toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "GUARANTY",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['guarantied_by'].toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "ADDED BY",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: customer['added_by'].toString(),
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    "ADDRESS",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue:
                      Address.fromJson(customer['address']).toString(),
                  maxLines: 5,
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.mfinGrey,
                      ),
                    ),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
