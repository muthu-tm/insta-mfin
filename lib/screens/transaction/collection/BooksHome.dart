import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/collection/CollectionBookHome.dart';
import 'package:instamfin/screens/transaction/collection/PaymentsBook.dart';
import 'package:instamfin/screens/transaction/collection/PaymentReports.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class BooksHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
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
                        "Collection Book",
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
                        "Payments Book",
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
                    builder: (context) => PaymentReportScreen(),
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
                                  color: CustomColors.mfinBlue.withOpacity(0.5),
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 5.0),
                            ],
                            color: CustomColors.mfinBlue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: <Color>[
                                CustomColors.mfinAlertRed,
                                CustomColors.mfinButtonGreen,
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
                        "All Transactions",
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
      bottomNavigationBar: bottomBar(context),
    );
  }
}
