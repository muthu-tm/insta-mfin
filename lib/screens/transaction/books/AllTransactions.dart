import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_collection.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/expense.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/chit/ViewChitCollectionDetails.dart';
import 'package:instamfin/screens/customer/ViewCollection.dart';
import 'package:instamfin/screens/customer/ViewPayment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/chit/chit_controller.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/transaction/expense_controller.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';

class AllTransactionsBuilder extends StatelessWidget {
  AllTransactionsBuilder(this.byRange, this.startDate, this.endDate);

  final User _user = UserController().getCurrentUser();

  final bool byRange;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.featured_play_list,
            size: 35.0,
            color: CustomColors.mfinAlertRed,
          ),
          title: Text(
            AppLocalizations.of(context).translate('loans'),
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
            AppLocalizations.of(context).translate("collections"),
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
            Icons.local_florist,
            size: 35.0,
            color: CustomColors.mfinPositiveGreen,
          ),
          title: Text(
            "Chits",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Georgia",
              color: CustomColors.mfinBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _user.accPreferences.chitEnabled ? getChits() : Container(),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.swap_horiz,
            size: 35.0,
            color: CustomColors.mfinGrey,
          ),
          title: Text(
            AppLocalizations.of(context).translate("journals"),
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
            AppLocalizations.of(context).translate("expenses"),
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
          ? _pc.getAllPaymentsByDateRange(startDate, endDate)
          : _pc.getPaymentsByDate(DateUtils.getUTCDateEpoch(startDate)),
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

                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPayment(payment),
                          settings: RouteSettings(name: '/customers/payments'),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: CustomColors.mfinAlertRed.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                AppLocalizations.of(context).translate("customer"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                payment.custName,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                AppLocalizations.of(context).translate("payment_id"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                payment.paymentID ?? "-",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                AppLocalizations.of(context).translate("collection"),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: RichText(
                                text: TextSpan(
                                  text: '${payment.tenure}',
                                  style: TextStyle(
                                    color: CustomColors.mfinWhite,
                                    fontFamily: 'Georgia',
                                    fontSize: 18.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' x ',
                                      style: TextStyle(
                                        color: CustomColors.mfinBlack,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${payment.collectionAmount}',
                                      style: TextStyle(
                                        color: CustomColors.mfinPositiveGreen,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "No Loans on this Date!",
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
    return FutureBuilder<List<Collection>>(
      future: byRange
          ? CollectionController().getAllCollectionByDateRange(
              _user.primary.financeID,
              _user.primary.branchName,
              _user.primary.subBranchName,
              [0, 1, 2, 3, 4, 5],
              startDate,
              endDate)
          : Collection().getAllCollectionDetailsByDateRange(
              _user.primary.financeID,
              _user.primary.branchName,
              _user.primary.subBranchName,
              [DateUtils.getUTCDateEpoch(startDate)],
              [0, 1, 2, 3, 4, 5]),
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

                int received = 0;

                if (coll.collections.length > 1) {
                  coll.collections.forEach((cDetails) {
                    if (cDetails.collectedOn >=
                            DateUtils.getUTCDateEpoch(startDate) &&
                        cDetails.collectedOn <=
                            DateUtils.getUTCDateEpoch(endDate))
                      received += cDetails.amount;
                  });
                } else {
                  received = coll.getReceived();
                }

                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () async {
                      List<Map<String, dynamic>> payList = await Payment()
                          .getByPaymentID(coll.financeID, coll.branchName,
                              coll.subBranchName, coll.paymentID);
                      Payment pay = Payment.fromJson(payList[0]);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewCollection(
                              pay, coll, CustomColors.mfinPositiveGreen),
                          settings: RouteSettings(
                              name: '/customers/payments/collection'),
                        ),
                      );
                    },
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: CustomColors.mfinPositiveGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Loan ID:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                coll.payID ?? "",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Type:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                coll.getType(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Amount:",
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
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Received:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                received.toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
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

  Widget getChits() {
    return FutureBuilder<List<ChitCollection>>(
      future: byRange
          ? ChitController().getAllChitsByDateRange(
              _user.primary.financeID,
              _user.primary.branchName,
              _user.primary.subBranchName,
              startDate,
              endDate)
          : ChitCollection().getAllCollectionDetailsByDateRange(
              _user.primary.financeID,
              _user.primary.branchName,
              _user.primary.subBranchName,
              [DateUtils.getUTCDateEpoch(startDate)]),
      builder:
          (BuildContext context, AsyncSnapshot<List<ChitCollection>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            widget = ListView.builder(
              itemCount: snapshot.data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, int index) {
                ChitCollection coll = snapshot.data[index];

                int received = 0;

                if (coll.collections.length > 1) {
                  coll.collections.forEach((cDetails) {
                    if (cDetails.collectedOn >=
                            DateUtils.getUTCDateEpoch(startDate) &&
                        cDetails.collectedOn <=
                            DateUtils.getUTCDateEpoch(endDate))
                      received += cDetails.amount;
                  });
                } else {
                  received = coll.getReceived();
                }

                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewChitCollectionDetails(coll),
                          settings: RouteSettings(
                              name: '/chit/collections/collectionDetails'),
                        ),
                      );
                    },
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: CustomColors.mfinGrey.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Chit ID:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                coll.chitOriginalID ?? "",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Customer:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                coll.customerNumber.toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Amount:",
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
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ListTile(
                              leading: Text(
                                "Received:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                received.toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinLightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "No Chits on this Date!",
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
          ? _jc.getAllJournalByDateRange(
              _user.primary.financeID,
              _user.primary.branchName,
              _user.primary.subBranchName,
              startDate,
              endDate)
          : _jc.getJournalByDate(_user.primary.financeID,
              _user.primary.branchName, _user.primary.subBranchName, startDate),
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

                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: CustomColors.mfinLightBlue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                            child: ListTile(
                              leading: Text(
                                "Name:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                journal.journalName,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: ListTile(
                              leading: Text(
                                journal.isExpense ? AppLocalizations.of(context).translate("expense") : AppLocalizations.of(context).translate("income"),
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
                      ),
                    ),
                  );
                });
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context).translate("no_journal_on_this_date"),
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
          ? _ec.getAllExpenseByDateRange(
              _user.primary.financeID,
              _user.primary.branchName,
              _user.primary.subBranchName,
              startDate,
              endDate)
          : _ec.getExpenseByDate(_user.primary.financeID,
              _user.primary.branchName, _user.primary.subBranchName, startDate),
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

                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: CustomColors.mfinAlertRed.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                            child: ListTile(
                              leading: Text(
                                "Name:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                expense.expenseName,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: ListTile(
                              leading: Text(
                                "Amount:",
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
                      ),
                    ),
                  );
                });
          } else {
            widget = Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context).translate("no_expense_on_this_date"),
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
