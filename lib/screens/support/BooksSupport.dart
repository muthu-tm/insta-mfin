import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class BooksSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions - Notebooks"),
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
                      "Collections Book: ",
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
                            text: "Today",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinBlue,
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: " - ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinButtonGreen,
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: "Collections need to be collected today",
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
                            text: "Pending",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinBlue,
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: " - ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinButtonGreen,
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                "Collections those are all pending till today",
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
                            text: "Tomorrow",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinBlue,
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: " - ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinButtonGreen,
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: "Collections need to be collected Tomorrow",
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
                      "Loan Book: ",
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
                                "Loans are grouped based on the User Preference",
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
                            text: "To Change the grouping, goto ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                "Settings -> Preferences -> Transactions Group By -> Select Daily/Weekly/Monthly",
                            style: TextStyle(
                              color: CustomColors.mfinBlue,
                              fontSize: 15.0,
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
