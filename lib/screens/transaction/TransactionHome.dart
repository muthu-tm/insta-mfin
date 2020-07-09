import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/transaction/books/BooksHome.dart';
import 'package:instamfin/screens/transaction/configuration/TransactionConfigHome.dart';
import 'package:instamfin/screens/transaction/JournalEntryHome.dart';
import 'package:instamfin/screens/transaction/ExpenseHome.dart';
import 'package:instamfin/screens/transaction/widgets/TransactionCollectionBuilder.dart';
import 'package:instamfin/screens/transaction/widgets/TransactionJournalBuilder.dart';
import 'package:instamfin/screens/transaction/widgets/TransactionExpenseBuilder.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionScreen extends StatelessWidget {
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await UserController().refreshUser();
        return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => UserFinanceSetup(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        appBar: topAppBar(context),
        drawer: openDrawer(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BooksHome(),
                        settings: RouteSettings(name: "/transactions/books"),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: CustomColors.mfinBlue,
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Spacer(),
                              Icon(
                                Icons.library_books,
                                size: 50.0,
                                color: CustomColors.mfinButtonGreen,
                              ),
                              Spacer(),
                              Text(
                                "NoteBooks",
                                style: TextStyle(
                                  fontSize: 14,
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
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: 110,
                          child: TransactionCollectionBuilder(),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseHome(),
                        settings: RouteSettings(name: '/transactions/expenses'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: CustomColors.mfinBlue,
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Spacer(),
                              Text(
                                _user.preferences.transactionGroupBy == 0
                                    ? "Today's"
                                    : _user.preferences.transactionGroupBy == 1
                                        ? "This Week"
                                        : "This Month",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.mfinWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.shopping_basket,
                                size: 40.0,
                                color: CustomColors.mfinButtonGreen,
                              ),
                              Spacer(),
                              Text(
                                "Expenses",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
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
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: 120,
                          child: TransactionExpenseBuilder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalEntryHome(),
                        settings: RouteSettings(name: '/transactions/journals'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: CustomColors.mfinBlue,
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Spacer(),
                              Text(
                                _user.preferences.transactionGroupBy == 0
                                    ? "Today's"
                                    : _user.preferences.transactionGroupBy == 1
                                        ? "This Week"
                                        : "This Month",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.mfinWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.swap_horiz,
                                size: 45.0,
                                color: CustomColors.mfinButtonGreen,
                              ),
                              Spacer(),
                              Text(
                                "Journals",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
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
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: 140,
                          child: TransactionJournalBuilder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Material(
                  color: CustomColors.mfinLightGrey,
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionConfigHome(),
                          settings: RouteSettings(name: '/transactions/config'),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          Icon(
                            Icons.settings,
                            size: 55.0,
                            color: CustomColors.mfinBlue,
                          ),
                          Spacer(),
                          Text(
                            "Transaction Configuration",
                            style: TextStyle(
                              fontSize: 18,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomBar(context),
      ),
    );
  }
}
