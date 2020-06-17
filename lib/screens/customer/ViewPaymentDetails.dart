import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class ViewPaymentDetails extends StatelessWidget {
  ViewPaymentDetails(this.payment);

  final Payment payment;

  Map<String, String> tempCollectionDays = {
    "0": "Sun",
    "1": "Mon",
    "2": "Tue",
    "3": "Wed",
    "4": "Thu",
    "5": "Fri",
    "6": "Sat",
  };
  final List<String> _tempCollectionMode = ["Daily", "Weekly", "Monthly"];
  final List<String> _transferMode = ["Cash", "NetBanking", "GPay"];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (0.75),
      child: SingleChildScrollView(
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
                            readOnly: true,
                            initialValue: payment.custName,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                initialValue: DateUtils.formatDate(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        payment.dateOfPayment)),
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  labelText: 'Date of Pay',
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
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.paymentID,
                            decoration: InputDecoration(
                              labelText: 'Payment ID',
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
                            readOnly: true,
                            textAlign: TextAlign.start,
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
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                _transferMode[payment.transferredMode],
                            decoration: InputDecoration(
                              labelText: 'Transferred Mode',
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
                            readOnly: true,
                            initialValue:
                                _tempCollectionMode[payment.collectionMode],
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
                  payment.collectionMode.toString() == '0'
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.grey[350], width: 1.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Scheduled collection days',
                                style: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: selectedDays.toList(),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: DateUtils.formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    payment.collectionStartsFrom)),
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
                            readOnly: true,
                            initialValue: DateUtils.formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    payment.collectionStartsFrom)),
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
                            readOnly: true,
                            textAlign: TextAlign.start,
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
                            readOnly: true,
                            textAlign: TextAlign.start,
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
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
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
                            readOnly: true,
                            textAlign: TextAlign.start,
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
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
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
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue:
                                payment.alreadyCollectedAmount.toString(),
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.docCharge.toString(),
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
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.surcharge.toString(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> get selectedDays sync* {
    for (MapEntry days in tempCollectionDays.entries) {
      yield Transform(
        transform: Matrix4.identity()..scale(0.8),
        child: ChoiceChip(
          label: Text(days.value),
          selected: payment.collectionDays.contains(int.parse(days.key)),
          elevation: 5.0,
          selectedColor: CustomColors.mfinBlue,
          backgroundColor: CustomColors.mfinWhite,
          labelStyle: TextStyle(color: CustomColors.mfinButtonGreen),
        ),
      );
    }
  }
}
