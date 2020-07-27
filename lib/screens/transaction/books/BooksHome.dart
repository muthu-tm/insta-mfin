import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/transaction/books/CollectionBookHome.dart';
import 'package:instamfin/screens/transaction/books/AllTransactionsBook.dart';
import 'package:instamfin/screens/transaction/books/CustomersBook.dart';
import 'package:instamfin/screens/transaction/books/PaymentsBook.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';

class BooksHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    bool hasValidSubscription = true;
    if (_user.financeSubscription < DateUtils.getUTCDateEpoch(DateTime.now()) &&
        _user.chitSubscription < DateUtils.getUTCDateEpoch(DateTime.now())) {
      hasValidSubscription = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("note_books")),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                if (!hasValidSubscription) {
                  _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                          AppLocalizations.of(context).translate("subscription_expired"),
                          3));
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CollectionBookHome(),
                    settings:
                        RouteSettings(name: "/transactions/books/collections"),
                  ),
                );
              },
              child: Material(
                color: CustomColors.mfinLightGrey,
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: CustomColors.mfinButtonGreen
                                      .withOpacity(0.5),
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 5.0),
                            ],
                            color: CustomColors.mfinBlue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: <Color>[
                                CustomColors.mfinButtonGreen,
                                CustomColors.mfinBlue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.chrome_reader_mode,
                              size: 50.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        AppLocalizations.of(context).translate("collection_book"),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Georgia",
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
          Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentsBook(),
                    settings:
                        RouteSettings(name: '/transactions/books/payments'),
                  ),
                );
              },
              child: Material(
                color: CustomColors.mfinLightGrey,
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: CustomColors.mfinAlertRed
                                      .withOpacity(0.5),
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 5.0),
                            ],
                            color: CustomColors.mfinBlue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: <Color>[
                                CustomColors.mfinAlertRed,
                                CustomColors.mfinBlue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.chrome_reader_mode,
                              size: 50.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        AppLocalizations.of(context).translate("payments_book"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Georgia",
                          color: CustomColors.mfinAlertRed,
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
          Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllTransactionsBook(),
                    settings: RouteSettings(name: '/transactions/books/all'),
                  ),
                );
              },
              child: Material(
                color: CustomColors.mfinLightGrey,
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color:
                                      CustomColors.mfinBlack.withOpacity(0.5),
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 5.0),
                            ],
                            color: CustomColors.mfinBlue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.chrome_reader_mode,
                              size: 50.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        AppLocalizations.of(context).translate("transactions_book"),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Georgia",
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
          Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomersBook(),
                    settings:
                        RouteSettings(name: '/transactions/books/customers'),
                  ),
                );
              },
              child: Material(
                color: CustomColors.mfinLightGrey,
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color:
                                      CustomColors.mfinBlack.withOpacity(0.5),
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 5.0),
                            ],
                            color: CustomColors.mfinBlue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.group,
                              size: 50.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        AppLocalizations.of(context).translate("customers_book"),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Georgia",
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
    );
  }
}
