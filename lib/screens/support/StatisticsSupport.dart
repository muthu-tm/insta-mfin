import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class StatisticsSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text(
                      "1. ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlack,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "View Statistics:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 25, top: 10, right: 15, bottom: 10),
                color: CustomColors.mfinLightGrey,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "A: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "To view graphical representation of your Finance transactions, go to ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Statistics",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "B: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "Select any tab to view the charts",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text(
                      "2. ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlack,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Choose Different Charts and Graphs:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 25, top: 10, right: 15, bottom: 10),
                color: CustomColors.mfinLightGrey,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "A: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "To view statistics in different graphical representation (line graph or Bar chart), go to ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Statistics",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "B: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Select the chart/graph option from the dropdown",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
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
    );
  }
}
