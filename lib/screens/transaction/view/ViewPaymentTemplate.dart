import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ViewPaymentTemplate extends StatelessWidget {
  final List _tempCollectionMode = ["Daily", "Weekly", "Monthly"];
  final Map<String, String> tempCollectionDays = {
    "0": "Sun",
    "1": "Mon",
    "2": "Tue",
    "3": "Wed",
    "4": "Thu",
    "5": "Fri",
    "6": "Sat",
  };
  final PaymentTemplate template;

  ViewPaymentTemplate(this.template);

  @override
  Widget build(BuildContext context) {
    print(_tempCollectionMode[template.collectionMode]);
    return Container(
      height: MediaQuery.of(context).size.height * (0.6),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              margin: EdgeInsets.only(top: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      "Payment Template",
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
                            initialValue: template.name,
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Template name',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
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
                            initialValue: template.totalAmount.toString(),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Total amount',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            initialValue: template.interestAmount.toString(),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Interest Amount',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
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
                            initialValue: template.principalAmount.toString(),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Principal Amount',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
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
                            initialValue: template.tenure.toString(),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'No. of Collections',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            initialValue: template.collectionAmount.toString(),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Collection amount',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
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
                            initialValue: template.docCharge.toString(),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Document charge',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            initialValue: template.surcharge.toString(),
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'SurCharge',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
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
                            initialValue:
                                _tempCollectionMode[template.collectionMode],
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Collection mode',
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
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  template.collectionMode.toString() == '0'
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: CustomColors.mfinGrey, width: 1.0),
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
                  Padding(padding: EdgeInsets.all(10))
                ],
              ),
            )
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
          selected: template.collectionDays.contains(int.parse(days.key)),
          elevation: 5.0,
          selectedColor: CustomColors.mfinBlue,
          backgroundColor: CustomColors.mfinWhite,
          labelStyle: TextStyle(color: CustomColors.mfinButtonGreen),
        ),
      );
    }
  }
}
