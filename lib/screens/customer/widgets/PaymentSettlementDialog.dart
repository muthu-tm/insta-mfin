import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget paymentSettlementDialog(Payment _p, List<int> pDetails) {
  return Builder(
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: Text(
                "SETTLEMENT",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColors.mfinPositiveGreen,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: CustomColors.mfinButtonGreen,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      initialValue: _p.totalAmount.toString(),
                      decoration: InputDecoration(
                        labelText: 'Total Amount',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinBlue),
                        ),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      initialValue: _p.principalAmount.toString(),
                      decoration: InputDecoration(
                        labelText: 'Amount Given',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinBlue),
                        ),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      initialValue: pDetails[0].toString(),
                      decoration: InputDecoration(
                        labelText: 'Total Received',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinPositiveGreen,
                        ),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinBlue),
                        ),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      initialValue: pDetails[1].toString(),
                      decoration: InputDecoration(
                        labelText: 'Pending Amount',
                        labelStyle: TextStyle(
                          color: CustomColors.mfinAlertRed,
                        ),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinBlue),
                        ),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Total Remaining:",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      initialValue: (_p.totalAmount - pDetails[0]).toString(),
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinBlue),
                        ),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Settlement Amount:",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      initialValue: (_p.totalAmount - pDetails[0]).toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinBlue),
                        ),
                      ),
                      autofocus: false,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: CustomColors.mfinBlue,
                    color: CustomColors.mfinAlertRed,
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      splashColor: CustomColors.mfinWhite,
                      child: Container(
                        height: 40,
                        width: 150,
                        alignment: Alignment.center,
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinWhite,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: CustomColors.mfinBlue,
                    color: CustomColors.mfinPositiveGreen,
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      splashColor: CustomColors.mfinWhite,
                      child: Container(
                        height: 40,
                        width: 150,
                        alignment: Alignment.center,
                        child: Text(
                          "SETTLEMENT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinWhite,
                          ),
                        ),
                      ),
                      onTap: () async {
                        print("Settlement Clicked");
                      },
                    ),
                  ),
                ),
              ],
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    ),
  );
}
