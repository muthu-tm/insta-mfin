import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/widgets/JournalAppBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class JournalEntryHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: journalAppBar(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text(
          'Add',
          style: TextStyle(
            color: CustomColors.mfinWhite,
            fontSize: 16,
          ),
        ),
        icon: Icon(
          Icons.add,
          size: 40,
          color: CustomColors.mfinFadedButtonGreen,
        ),
        // backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Text(
          "Journal Entry Home",
          style: TextStyle(
            color: CustomColors.mfinBlue,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
