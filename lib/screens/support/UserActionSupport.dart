import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class UserActionSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Support"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "1. ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinBlack,
                    fontSize: 18.0,
                  ),
                  children: [
                    TextSpan(
                      text: "SIGN UP: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                        fontSize: 15.0,
                      ),
                    ),
                    TextSpan(
                      text: "Open mFIN app and Click",
                      style: TextStyle(
                        color: CustomColors.mfinBlack,
                        fontSize: 13.0,
                      ),
                    ),
                    TextSpan(
                      text: " 'SIGN UP' ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinPositiveGreen,
                        fontSize: 15.0,
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
