import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/configuration/ExpenseCategoryListWidget.dart';
import 'package:instamfin/screens/transaction/configuration/JournalCategoryListWidget.dart';
import 'package:instamfin/screens/transaction/configuration/PaymentTemplateListWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class TransactionConfigHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Configurations'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              margin: EdgeInsets.all(5.0),
              shadowColor: CustomColors.mfinLightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      "Payment Templates",
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
                  PaymentTemplateListWidget()
                ],
              ),
            ),
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              margin: EdgeInsets.all(5.0),
              shadowColor: CustomColors.mfinLightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      "Expense Categories",
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
                  ExpenseCategoryListWidget(),
                ],
              ),
            ),
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              margin: EdgeInsets.all(5.0),
              shadowColor: CustomColors.mfinLightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      "Journal Categories",
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
                  JournalCategoryListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
