import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CollectionSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collection Management"),
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
                      "Add Collection:",
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
                            text: "To add ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Collection",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ", go to ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Customer",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " and open the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Customer",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " from the list",
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
                            text: "It loads the list of ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Loans",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " of the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Customer",
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
                        text: "C: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "Click ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Add Collection",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " button in the Loan",
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
                            text: "Enter the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Collection",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " details",
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
                            text: "Press ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Save",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " button to apply the changes",
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
