import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class ViewPaymentDetails extends StatelessWidget {
  ViewPaymentDetails(this.payment);

  final Payment payment;

  final List<String> _tempCollectionMode = [
    "Daily",
    "Weekly",
    "Monthly"
  ];

  final List<String> _tempCollectionDays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  @override
  Widget build(BuildContext context) {
    int selectedCollectionModeID = payment.collectionMode;
    int selectedCollectionDayID = payment.collectionDay;

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
                  Icons.payment,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                title: Text(
                  "Payment Details",
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
                  new Card(
                    color: CustomColors.mfinLightGrey,
                    elevation: 5.0,
                    margin: EdgeInsets.only(top: 5.0),
                    shadowColor: CustomColors.mfinLightBlue,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "General Info",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinBlue,
                            ),
                          ),
                        ),
                        Divider(
                          color: CustomColors.mfinBlue,
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 70,
                            child: Text(
                              "PAYMENT ID:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.paymentID,
                            decoration: InputDecoration(
                              hintText: 'Payment ID',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 70,
                            child: Text(
                              "DATE:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: GestureDetector(
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              initialValue:
                                  DateUtils.formatDate(payment.dateOfPayment),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              enabled: false,
                              autofocus: false,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 70,
                            child: Text(
                              "GIVEN TO:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.givenTo,
                            decoration: InputDecoration(
                              hintText: 'Amount Given To',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 70,
                            child: Text(
                              "GIVEN BY:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.givenBy,
                            decoration: InputDecoration(
                              hintText: 'Amount Given by',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 70,
                            child: Text(
                              "NOTES:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.notes,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Notes',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 100,
                            child: Text(
                              "MODE:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: _tempCollectionMode[selectedCollectionModeID],
                            decoration: InputDecoration(
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        selectedCollectionModeID == 0
                            ? ListTile(
                          leading: SizedBox(
                            width: 100,
                            child: Text(
                              "COLLECTION DATE:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                initialValue: DateUtils.formatDate(payment.collectionStartsFrom),
                                decoration: InputDecoration(
                                  hintText: 'Date of Collection',
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 3.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinWhite)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  suffixIcon: Icon(
                                    Icons.date_range,
                                    size: 35,
                                    color: CustomColors.mfinBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            : Container(),
                        selectedCollectionModeID == 1
                            ? Column(
                          children: <Widget>[
                            ListTile(
                              leading: SizedBox(
                                width: 100,
                                child: Text(
                                  "COLLECTION DATE:",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Georgia",
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.mfinBlue,
                                  ),
                                ),
                              ),
                              title: GestureDetector(
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    initialValue: DateUtils.formatDate(payment.collectionStartsFrom),
                                    decoration: InputDecoration(
                                      hintText: 'Date of Collection',
                                      labelStyle: TextStyle(
                                        color: CustomColors.mfinBlue,
                                      ),
                                      contentPadding:
                                      new EdgeInsets.symmetric(
                                          vertical: 3.0, horizontal: 3.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: CustomColors.mfinWhite)),
                                      fillColor: CustomColors.mfinWhite,
                                      filled: true,
                                      suffixIcon: Icon(
                                        Icons.date_range,
                                        size: 35,
                                        color: CustomColors.mfinBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: SizedBox(
                                width: 100,
                                child: Text(
                                  "DAY:",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Georgia",
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.mfinBlue,
                                  ),
                                ),
                              ),
                              title: TextFormField(
                                textAlign: TextAlign.end,
                                initialValue: _tempCollectionDays[selectedCollectionDayID],
                                decoration: InputDecoration(
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 3.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinWhite)),
                                ),
                                enabled: false,
                                autofocus: false,
                              ),
                            ),
                          ],
                        )
                            : Container(),
                        selectedCollectionModeID == 2
                            ? ListTile(
                          leading: SizedBox(
                            width: 100,
                            child: Text(
                              "COLLECTION DATE:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                initialValue: DateUtils.formatDate(payment.collectionStartsFrom),
                                decoration: InputDecoration(
                                  hintText: 'Date of Collection',
                                  labelStyle: TextStyle(
                                    color: CustomColors.mfinBlue,
                                  ),
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 3.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomColors.mfinWhite)),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  suffixIcon: Icon(
                                    Icons.date_range,
                                    size: 35,
                                    color: CustomColors.mfinBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                  new Card(
                    shadowColor: CustomColors.mfinAlertRed,
                    color: CustomColors.mfinLightGrey,
                    elevation: 15.0,
                    margin: EdgeInsets.only(top: 5.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "Payment Info",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinBlue,
                            ),
                          ),
                        ),
                        Divider(
                          color: CustomColors.mfinBlue,
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 90,
                            child: Text(
                              "TOTAL AMOUNT:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: new TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.totalAmount.toString(),
                            decoration: InputDecoration(
                              hintText: 'Total Amount',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 90,
                            child: Text(
                              "PRINCIPAL:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: new TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.principalAmount.toString(),
                            decoration: InputDecoration(
                              hintText: 'Principal amount given',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 90,
                            child: Text(
                              "DOC CHARGE:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.docCharge.toString(),
                            decoration: InputDecoration(
                              hintText: 'Document Charge',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 90,
                            child: Text(
                              "SUR CHARGE:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.surcharge.toString(),
                            decoration: InputDecoration(
                              hintText: 'Service charge if any',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 90,
                            child: Text(
                              "TENURE:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.tenure.toString(),
                            decoration: InputDecoration(
                              hintText: 'Number of Collections',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 90,
                            child: Text(
                              "INTEREST:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.interestRate.toString(),
                            decoration: InputDecoration(
                              hintText: 'Rate in 0.00%',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                        ListTile(
                          leading: SizedBox(
                            width: 90,
                            child: Text(
                              "COLLECTION AMOUNT:",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                          title: TextFormField(
                            textAlign: TextAlign.end,
                            initialValue: payment.collectionAmount.toString(),
                            decoration: InputDecoration(
                              hintText: 'Each Collection Amount',
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            enabled: false,
                            autofocus: false,
                          ),
                        ),
                      ],
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
