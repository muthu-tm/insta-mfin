import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/expense.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/transaction/expense_controller.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AllTransactionsBuilder extends StatelessWidget {
  AllTransactionsBuilder(this.byRange, this.startDate, this.endDate);

  final User _user = UserController().getCurrentUser();

  final bool byRange;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.featured_play_list,
            size: 35.0,
            color: CustomColors.mfinAlertRed,
          ),
          title: Text(
            "Payments",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Georgia",
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        getPayments(),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.collections_bookmark,
            size: 35.0,
            color: CustomColors.mfinPositiveGreen,
          ),
          title: Text(
            "Collections",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Georgia",
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        getCollections(),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.swap_horiz,
            size: 35.0,
            color: CustomColors.mfinGrey,
          ),
          title: Text(
            "Journals",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Georgia",
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        getJournals(),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.featured_play_list,
            size: 35.0,
            color: CustomColors.mfinAlertRed,
          ),
          title: Text(
            "Expenses",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Georgia",
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        getExpenses()
      ],
    );
  }

  Widget getPayments() {
    PaymentController _pc = PaymentController();

    return FutureBuilder<List<Payment>>(
      future: byRange
          ? _pc.getAllPaymentsByDateRange(_user.primaryFinance,
              _user.primaryBranch, _user.primarySubBranch, startDate, endDate)
          : _pc.getPaymentsByDate(_user.primaryFinance, _user.primaryBranch,
              _user.primarySubBranch, DateUtils.getUTCDateEpoch(startDate)),
      builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            widget = ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, int index) {
                  Payment payment = snapshot.data[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        child: ListTile(
                          leading: Text(
                            "Total Amount: ",
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            payment.paymentID,
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "No Payments on this Date!",
                style: TextStyle(
                  color: CustomColors.mfinAlertRed,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError(),
          );
        } else {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting(),
          );
        }

        return widget;
      },
    );
  }

  Widget getCollections() {
    Collection _c = Collection();

    return FutureBuilder<List<Collection>>(
      future: byRange
          ? _c.getAllCollectionsByDateRange(
              _user.primaryFinance,
              _user.primaryBranch,
              _user.primarySubBranch,
              [0, 1, 2, 3, 4],
              DateUtils.getUTCDateEpoch(startDate),
              DateUtils.getUTCDateEpoch(endDate))
          : _c.getAllCollectionByDate(
              _user.primaryFinance,
              _user.primaryBranch,
              _user.primarySubBranch,
              [0, 1, 2, 3, 4],
              DateUtils.getUTCDateEpoch(startDate)),
      builder:
          (BuildContext context, AsyncSnapshot<List<Collection>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            widget = ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, int index) {
                  Collection coll = snapshot.data[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        child: ListTile(
                          leading: Text(
                            "Total Amount: ",
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            coll.collectionAmount.toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "No Collections on this Date!",
                style: TextStyle(
                  color: CustomColors.mfinAlertRed,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError(),
          );
        } else {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting(),
          );
        }

        return widget;
      },
    );
  }

  Widget getJournals() {
    JournalController _jc = JournalController();

    return FutureBuilder<List<Journal>>(
      future: byRange
          ? _jc.getAllJournalByDateRange(_user.primaryFinance,
              _user.primaryBranch, _user.primarySubBranch, startDate, endDate)
          : _jc.getJournalByDate(_user.primaryFinance, _user.primaryBranch,
              _user.primarySubBranch, startDate),
      builder: (BuildContext context, AsyncSnapshot<List<Journal>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            widget = ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, int index) {
                  Journal journal = snapshot.data[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        child: ListTile(
                          leading: Text(
                            "Total Amount: ",
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            journal.amount.toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "No Journals on this Date!",
                style: TextStyle(
                  color: CustomColors.mfinAlertRed,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError(),
          );
        } else {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting(),
          );
        }

        return widget;
      },
    );
  }

  Widget getExpenses() {
    ExpenseController _ec = ExpenseController();

    return FutureBuilder<List<Expense>>(
      future: byRange
          ? _ec.getAllExpenseByDateRange(_user.primaryFinance,
              _user.primaryBranch, _user.primarySubBranch, startDate, endDate)
          : _ec.getExpenseByDate(_user.primaryFinance, _user.primaryBranch,
              _user.primarySubBranch, startDate),
      builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            widget = ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, int index) {
                  Expense expense = snapshot.data[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        child: ListTile(
                          leading: Text(
                            "Total Amount: ",
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            expense.amount.toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "No Expenses on this Date!",
                style: TextStyle(
                  color: CustomColors.mfinAlertRed,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError(),
          );
        } else {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting(),
          );
        }

        return widget;
      },
    );
  }
}
