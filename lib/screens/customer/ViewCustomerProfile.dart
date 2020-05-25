import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ViewCustomerProfile extends StatelessWidget {
  ViewCustomerProfile(this.customer);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          Container(
            height: 100.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: CustomColors.mfinBlue,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.assignment_ind,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                title: Text(
                  "Customer Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinFadedButtonGreen,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Card(
              color: CustomColors.mfinLightGrey,
              child: new Column(
                children: <Widget>[
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
                      initialValue: customer.name,
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
                      initialValue: customer.customerID,
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
                      initialValue: customer.mobileNumber.toString(),
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
                      initialValue: customer.profession,
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
                      initialValue: customer.gender,
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
                      initialValue: customer.age.toString(),
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
                      initialValue: customer.guarantiedBy.toString(),
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
                      initialValue: customer.addedBy.toString(),
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
                      initialValue: customer.address.toString(),
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
        ],
      ),
    );
  }
}
