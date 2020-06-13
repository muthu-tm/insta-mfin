import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

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

    return new Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              margin: EdgeInsets.only(top: 5.0),
              shadowColor: CustomColors.mfinLightBlue,
              child: Column(
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
                            // ! initialValue: widget.customer.name, need value for customer name
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Customer name',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              contentPadding: EdgeInsets.symmetric(
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
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          CustomColors.mfinFadedButtonGreen)),
                            ),
                          ),
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
                              labelText: 'Amount given by',
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            autofocus: false,
                            // ! initialValue: , need value for payment template
                            decoration: InputDecoration(
                              labelText: 'Payment template',
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
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
                            initialValue: _tempCollectionMode[payment.collectionMode],
                            decoration: InputDecoration(
                              labelText: 'Collection mode',
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
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
                              labelText: 'Notes',
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
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
            Card(
              shadowColor: CustomColors.mfinAlertRed,
              color: CustomColors.mfinLightGrey,
              elevation: 15.0,
              margin: EdgeInsets.only(top: 5.0),
              child: Column(
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
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            autofocus: false,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            initialValue: payment.principalAmount.toString(),
                            decoration: InputDecoration(
                              labelText: 'Principal amount',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
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
                            initialValue: payment.interestRate.toString(),
                            decoration: InputDecoration(
                              labelText: 'Rate of interest',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
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
                              labelText: 'No. of collections',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
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
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            autofocus: false,
                            keyboardType: TextInputType.datetime,
                            initialValue: payment.dateOfPayment.toString(),
                            decoration: InputDecoration(
                              labelText: 'Start date',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              contentPadding: EdgeInsets.symmetric(
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
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            autofocus: false,
                            initialValue: payment.dateOfPayment.toString(),
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: 'End date',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              contentPadding: EdgeInsets.symmetric(
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
                              labelText: 'Document charge',
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            initialValue: payment.surcharge.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Service charge',
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
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
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            //! need to fix in schema initialValue: payment.alreadyReceivedAmount.toString(),
                            decoration: InputDecoration(
                              hintText: 'Amount received so far',
                              labelText: 'Amount received',
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            initialValue: payment.totalAmount.toString(),
                            decoration: InputDecoration(
                              labelText: 'Total amount',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle:
                                  TextStyle(color: CustomColors.mfinBlue),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
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
                  Padding(padding: EdgeInsets.all(40))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}