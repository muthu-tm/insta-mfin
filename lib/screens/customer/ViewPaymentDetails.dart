import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class ViewPaymentDetails extends StatelessWidget {
  ViewPaymentDetails(this.payment);

  final Payment payment;

  final List<String> _tempCollectionMode = ["Daily", "Weekly", "Monthly"];

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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  //initialValue: payment.,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    labelText: 'Customer name',
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue,
                                    ),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                            CustomColors.mfinFadedButtonGreen)),
                                    fillColor: CustomColors.mfinLightGrey,
                                    filled: true,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  initialValue: payment.paymentID,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    hintText: 'Payment ID',
                                    labelText: 'Payment ID',
                                    labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue,
                                    ),
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                            CustomColors.mfinFadedButtonGreen)),
                                  ),),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  initialValue: payment.givenBy,
                                  decoration: InputDecoration(
                                    hintText: 'Amount given by',
                                    labelText: 'Amount given by',
                                    labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue,
                                    ),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors.mfinWhite)),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Flexible(
                                child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Payment template',
                                      labelStyle: TextStyle(
                                        color: CustomColors.mfinBlue,
                                      ),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                      fillColor: CustomColors.mfinWhite,
                                      filled: true,
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 3.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: CustomColors.mfinWhite)),
                                    ),
                                    value: payment.principalAmount,
                              ), )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Collection mode',
                                    labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue,
                                    ),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors.mfinWhite)),
                                  ),
                                  value: selectedCollectionModeID,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  initialValue: payment.notes,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Notes',
                                    labelText: 'Notes',
                                    labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue,
                                    ),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors.mfinWhite)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(child: TextFormField(
                                enabled: false,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                initialValue: payment.principalAmount.toString(),
                                decoration: InputDecoration(
                                  hintText: 'Principal amount',
                                  labelText: 'Principal amount',
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(color: CustomColors.mfinBlue),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: CustomColors.mfinWhite)),
                                ),
                              ),),
                              Padding(padding: EdgeInsets.all(10)),
                              Flexible(child: TextFormField(
                                enabled: false,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                initialValue: payment.interestRate.toString(),
                                decoration: InputDecoration(
                                  hintText: 'Rate in 0.00%',
                                  labelText: 'Rate of interest',
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue
                                  ),
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: CustomColors.mfinWhite)),
                                ),
                              ),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.number,
                                  initialValue: payment.tenure.toString(),
                                  decoration: InputDecoration(
                                    hintText: 'Number of Collections',
                                    labelText: 'No. of collections',
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(
                                        color: CustomColors.mfinBlue
                                    ),
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: CustomColors.mfinWhite)),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.number,
                                  initialValue: payment.collectionAmount.toString(),
                                  decoration: InputDecoration(
                                    hintText: 'Each Collection Amount',
                                    labelText: 'Collection amount',
                                    labelStyle: TextStyle(
                                        color: CustomColors.mfinBlue
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: CustomColors.mfinWhite)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: GestureDetector(
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      enabled: false,
                                      autofocus: false,
                                      initialValue: DateUtils.getFormattedDateFromEpoch(
                                          payment.dateOfPayment),
                                      decoration: InputDecoration(
                                        labelText: 'Start date',
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(
                                          color: CustomColors.mfinBlue,
                                        ),
                                        contentPadding: new EdgeInsets.symmetric(
                                            vertical: 3.0, horizontal: 10.0),
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
                              Padding(padding: EdgeInsets.all(10)),
                              Flexible(
                                child: GestureDetector(
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      enabled: false,
                                      autofocus: false,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        labelText: 'End date',
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(
                                          color: CustomColors.mfinBlue,
                                        ),
                                        contentPadding: new EdgeInsets.symmetric(
                                            vertical: 3.0, horizontal: 10.0),
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  initialValue: payment.docCharge.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Document charge',
                                    labelText: 'Document charge',
                                    labelStyle: TextStyle(color: CustomColors.mfinBlue),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10),
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: CustomColors.mfinWhite)),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Flexible(child: TextFormField(
                                enabled: false,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                initialValue: payment.surcharge.toString(),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Service charge if any',
                                  labelText: 'Service charge',
                                  labelStyle: TextStyle(color: CustomColors.mfinBlue),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: CustomColors.mfinWhite)),
                                ),
                              ),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(child: TextFormField(
                                enabled: false,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                initialValue: "0",
                                decoration: InputDecoration(
                                  hintText: 'Amount received so far',
                                  labelText: 'Amount received',
                                  labelStyle: TextStyle(
                                      color: CustomColors.mfinBlue
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  fillColor: CustomColors.mfinWhite,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: CustomColors.mfinWhite)),
                                ),
                              ),),
                              Padding(padding: EdgeInsets.all(10)),
                              Flexible(
                                child: TextFormField(
                                  enabled: false,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.number,
                                  initialValue: payment.totalAmount.toString(),
                                  decoration: InputDecoration(
                                    hintText: 'Total amount',
                                    labelText: 'Total amount',
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: CustomColors.mfinBlue),
                                    fillColor: CustomColors.mfinWhite,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors.mfinWhite)),
                                  ),
                                ),
                              ),
                            ],
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
