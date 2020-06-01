import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/ViewCustomer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget customerListTile(
    BuildContext context, int index, Customer customer) {
  Color tileColor = CustomColors.mfinBlue;
  Color textColor = CustomColors.mfinWhite;
  IconData custIcon = Icons.person_outline;

  if ((index % 2) == 0) {
    tileColor = CustomColors.mfinWhite;
    textColor = CustomColors.mfinBlue;
    custIcon = Icons.person;
  }
  return Padding(
    padding: EdgeInsets.only(left: 12.0, top: 5.0, right: 12.0, bottom: 5.0),
    child: Material(
      color: tileColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewCustomer(customer),
              settings: RouteSettings(name: '/customers/view'),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.width / 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: tileColor,
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.width / 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  border: Border.all(
                      color: textColor, style: BorderStyle.solid, width: 2.0),
                ),
                child: Icon(
                  custIcon,
                  size: MediaQuery.of(context).size.width / 10,
                  color: textColor,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, top: 5.0),
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      customer.name,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18.0,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      customer.mobileNumber.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14.0,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
