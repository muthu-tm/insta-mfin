import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ViewPaymentTemplate extends StatelessWidget {
  ViewPaymentTemplate(this.payTemplate);

  final PaymentTemplate payTemplate;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(payTemplate.name),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.payment,
                  size: 35.0,
                  color: CustomColors.mfinFadedButtonGreen,
                ),
                title: new Text(
                  "Payment Template",
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
                  initialValue: payTemplate.name,
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
                    "TOTAL",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: payTemplate.totalAmount.toString(),
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
                    "PRINCIPAL",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: payTemplate.principalAmount.toString(),
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
                    "DOC CHARGE",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: payTemplate.docCharge.toString(),
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
                    "SUR CHARGE",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: payTemplate.surcharge.toString(),
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
                    "TENURE",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: payTemplate.tenure.toString(),
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
                    "TENURE TYPE",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: getTenureType(payTemplate.tenureType),
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
                    "COLL AMOUNT",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: payTemplate.collectionAmount.toString(),
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
                    "INTEREST",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinGrey),
                  ),
                ),
                title: TextFormField(
                  initialValue: payTemplate.interestRate.toString(),
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

  getTenureType(int type) {
    switch (type) {
      case 0:
        return "Daily";
        break;
      case 1:
        return "Weekly";
        break;
      case 2:
        return "Monthly";
        break;
      default:
        return "Daily";
        break;
    }
  }
}
