import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/miscellaneous/MiscellaneousCategoryScreen.dart';
import 'package:instamfin/screens/transaction/widgets/MiscellaneousAppBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class MiscellaneousExpenseHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: miscellaneousAppBar(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiscellaneousCategoryScreen(),
            ),
          );
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
          "Miscellaneous Expense Home",
          style: TextStyle(
            color: CustomColors.mfinBlue,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
