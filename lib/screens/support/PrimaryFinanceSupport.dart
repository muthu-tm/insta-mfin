import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class PrimaryFinanceSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Primary Finance"),
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
                      "Change Primary Finance From Dashboard:",
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
                                "To change your Primary Finance, select Home from the left menu",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
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
                            text:
                                "Click on the edit icon in the top right corner",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "C: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Select the Finance, Branch and Sub-branch from the dropdown",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "D: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "Press save button to apply the changes",
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
                      "Change Primary Finance from Settings:",
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
                                "To change your Primary Finance, go to Settings",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
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
                            text: "Click on the Profile menu",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "C: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Click on the edit icon, next to the Finance Details",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "D: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "Select the Finance, Branch and Sub-branch from the dropdown",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "E: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "Press save button to apply the changes",
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
