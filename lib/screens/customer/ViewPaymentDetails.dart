import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

import '../../app_localizations.dart';

class ViewPaymentDetails extends StatelessWidget {
  ViewPaymentDetails(this.payment);

  final Payment payment;

  final Map<String, String> tempCollectionDays = {
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
                      AppLocalizations.of(context).translate('general_info'),
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: payment.custName,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('customer_name'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                    padding: EdgeInsets.all(5),
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
                                  labelText: AppLocalizations.of(context)
                                      .translate('date_of_pay'),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    fontSize: 10,
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
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.paymentID ?? "",
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('payment_id'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.givenBy,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('amount_given_by'),
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                _transferMode[payment.transferredMode],
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('transferred_mode'),
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                _tempCollectionMode[payment.collectionMode],
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('collection_mode'),
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                            border: Border.all(
                                color: CustomColors.mfinGrey, width: 1.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                    .translate('scheduled_collection_days'),
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: DateUtils.formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    payment.collectionStartsFrom)),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('collection_sdate'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                        Padding(padding: EdgeInsets.all(5)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: DateUtils.formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    payment.collectionStartsFrom)),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('collection_edate'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.notes,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('notes'),
                              labelStyle: TextStyle(
                                fontSize: 10,
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
                      AppLocalizations.of(context).translate('payment_info'),
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.totalAmount.toString(),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('total_amount'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.interestAmount.toString(),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('interest_amount'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.principalAmount.toString(),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('principal_amount'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.tenure.toString(),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('number_of_collections'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.collectionAmount.toString(),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('collection_amount'),
                              labelText: AppLocalizations.of(context)
                                  .translate('collection_amount'),
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue:
                                payment.alreadyCollectedAmount.toString(),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('already_collected'),
                              labelText: AppLocalizations.of(context)
                                  .translate('already_collected'),
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.docCharge.toString(),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('document_charge'),
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
                        Padding(padding: EdgeInsets.all(5)),
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.start,
                            initialValue: payment.surcharge.toString(),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate('service_charge'),
                              labelStyle: TextStyle(
                                  fontSize: 10, color: CustomColors.mfinBlue),
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
        transform: Matrix4.identity()..scale(0.9),
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
