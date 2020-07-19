import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ViewChitTemplate extends StatelessWidget {
  ViewChitTemplate(this.temp);

  final ChitTemplate temp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Chit Template'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
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
                      "Chit Template",
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
                            initialValue: temp.name,
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
                            readOnly: true,
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
                            initialValue: temp.chitAmount.toString(),
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Chit amount',
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
                            readOnly: true,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            initialValue: temp.getProfitAmount().toString(),
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Profit amount',
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
                            readOnly: true,
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
                            initialValue: temp.tenure.toString(),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Months',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.mfinFadedButtonGreen,
                                ),
                              ),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                            ),
                            readOnly: true,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Flexible(
                          child: TextFormField(
                            initialValue: temp.collectionDay.toString(),
                            decoration: InputDecoration(
                              labelText: 'Collection Day',
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
                            readOnly: true,
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
                            textAlign: TextAlign.start,
                            initialValue: temp.notes,
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  temp.tenure > 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: temp.tenure,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                color: CustomColors.mfinLightGrey,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Chit Number ${index + 1}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Georgia",
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.mfinBlue,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              initialValue: temp
                                                  .fundDetails[index].chitAmount
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              decoration: InputDecoration(
                                                labelText: 'collection Amount',
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                labelStyle: TextStyle(
                                                  color: CustomColors.mfinBlue,
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 3.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: CustomColors
                                                        .mfinFadedButtonGreen,
                                                  ),
                                                ),
                                                fillColor:
                                                    CustomColors.mfinWhite,
                                                filled: true,
                                              ),
                                              readOnly: true,
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.all(5)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              initialValue: temp
                                                  .fundDetails[index]
                                                  .allocationAmount
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              decoration: InputDecoration(
                                                labelText: 'Allocation Amount',
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                labelStyle: TextStyle(
                                                  color: CustomColors.mfinBlue,
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 3.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: CustomColors
                                                        .mfinFadedButtonGreen,
                                                  ),
                                                ),
                                                fillColor:
                                                    CustomColors.mfinWhite,
                                                filled: true,
                                              ),
                                              readOnly: true,
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.all(5)),
                                          Flexible(
                                            child: TextFormField(
                                              initialValue: temp
                                                  .fundDetails[index].profit
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              decoration: InputDecoration(
                                                labelText: 'Profit Amount',
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                labelStyle: TextStyle(
                                                  color: CustomColors.mfinBlue,
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 3.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: CustomColors
                                                        .mfinFadedButtonGreen,
                                                  ),
                                                ),
                                                fillColor:
                                                    CustomColors.mfinWhite,
                                                filled: true,
                                              ),
                                              readOnly: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Text("")
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(35))
          ],
        ),
      ),
    );
  }
}
