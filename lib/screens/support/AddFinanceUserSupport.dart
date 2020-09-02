import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class AddFinanceUserSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
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
                      "Add User - Finance level:",
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
                            text: "To add an ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "User/Agent",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " at ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Finance",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                " (has access over that finance, all branch, and all sub-branch), go to ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Settings -> Finance",
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
                            text: "Click ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Add Icon",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ", next to the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "User Details",
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
                            text: "Enter the User's ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Mobile Number",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " and click ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Search",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " button",
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
                            text: " button to add the user",
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
                      "Add User - Branch level:",
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
                            text: "User/Agent",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " at ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Branch",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                " (has access over that branch, and all sub-branch), go to ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Settings -> Finance",
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
                            text: "Under ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Branch Details",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ", click on the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Branch Name",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " in which you want to add the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "User",
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
                            text: "Add Icon",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ", next to the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "User Details",
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
                        text: "D: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "Enter the User's ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Mobile Number",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " and click ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Search",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " button",
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
                            text: " button to add the user",
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
                      "3. ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlack,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Add User - Sub-Branch level:",
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
                            text: "User/Agent",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " at ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Sub-Branch",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " (has access over that sub-branch), go to ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Settings -> Finance",
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
                            text: "Select the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Branch",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " , click on the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Sub-Branch Name",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " to which you want to add the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "User/Agent",
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
                            text: "Add Icon",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ", next to the ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "User Details",
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
                        text: "D: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "Enter the User's ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Mobile Number",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " and click ",
                            style: TextStyle(
                              color: CustomColors.mfinBlack,
                              fontSize: 13.0,
                            ),
                          ),
                          TextSpan(
                            text: "Search",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: CustomColors.mfinBlue,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " button",
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
                            text: " button to add the user",
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
