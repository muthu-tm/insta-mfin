import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/collection/AllTransactions.dart';
import 'package:instamfin/screens/transaction/widgets/TransactionJournalBuilder.dart';
import 'package:instamfin/screens/transaction/widgets/TransactionExpenseBuilder.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class PaymentReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentDate = DateTime.now();
        return SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                  child: InkWell(
                    onTap: () {
                    },
                    child: Row(
                      children: <Widget>[
                        Material(
                          color: CustomColors.mfinBlue,
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.33,
                            height: 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Spacer(),
                                Icon(
                                  Icons.library_books,
                                  size: 50.0,
                                  color: CustomColors.mfinWhite,
                                ),
                                Spacer(),
                                Text(
                                  "Payments",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: CustomColors.mfinWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          color: CustomColors.mfinLightGrey,
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.57,
                            height: 140,
                            child: AllTransactionsBuilder(new DateTime(currentDate.year, currentDate.month,
                        currentDate.day-7), currentDate),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {
                },
                child: Row(
                  children: <Widget>[
                    Material(
                      color: CustomColors.mfinBlue,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Icon(
                              Icons.playlist_add,
                              size: 55.0,
                              color: CustomColors.mfinAlertRed,
                            ),
                            Spacer(),
                            Text(
                              "Collections",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: CustomColors.mfinAlertRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: CustomColors.mfinLightGrey,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.57,
                        height: 120,
                        child: TransactionExpenseBuilder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {
                },
                child: Row(
                  children: <Widget>[
                    Material(
                      color: CustomColors.mfinBlue,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Icon(
                              Icons.swap_horiz,
                              size: 55.0,
                              color: CustomColors.mfinWhite,
                            ),
                            Spacer(),
                            Text(
                              "Journals",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: CustomColors.mfinWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: CustomColors.mfinLightGrey,
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.57,
                        height: 140,
                        child: TransactionJournalBuilder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
