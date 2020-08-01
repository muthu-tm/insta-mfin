import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/books/ChitBookHome.dart';
import 'package:instamfin/screens/transaction/books/CollectionBookHome.dart';
import 'package:instamfin/screens/transaction/books/AllTransactionsBook.dart';
import 'package:instamfin/screens/transaction/books/CustomersBook.dart';
import 'package:instamfin/screens/transaction/books/PaymentsBook.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class BooksHome extends StatelessWidget {
  BooksHome(this.chitEnabled);

  final bool chitEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoteBooks"),
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
                                CustomColors.mfinBlue,
                                CustomColors.mfinButtonGreen,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.import_contacts,
                              size: 50.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Collections Book",
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
                                CustomColors.mfinBlue,
                                CustomColors.mfinAlertRed,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.import_contacts,
                              size: 50.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Loan Book",
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
          chitEnabled
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChitBookHome(),
                          settings:
                              RouteSettings(name: '/transactions/books/chits'),
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
                                      CustomColors.mfinBlack,
                                      CustomColors.mfinButtonGreen,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.local_florist,
                                    size: 50.0,
                                    color: CustomColors.mfinLightGrey,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Chit Book",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Georgia",
                                color: CustomColors.mfinButtonGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
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
                              Icons.import_contacts,
                              size: 50.0,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Transactions Book",
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
                        "Customers Book",
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
