import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/transaction/add/AddExpenseCategory.dart';
import 'package:instamfin/screens/transaction/add/AddJournalCategory.dart';
import 'package:instamfin/screens/transaction/add/AddPaymentTemplate.dart';
import 'package:instamfin/screens/transaction/configuration/ExpenseCategoryListWidget.dart';
import 'package:instamfin/screens/transaction/configuration/JournalCategoryListWidget.dart';
import 'package:instamfin/screens/transaction/configuration/PaymentTemplateListWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransactionConfigHome extends StatelessWidget {

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();	

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Transaction Configurations'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context, scrollController) {
              return Material(
                  child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text('Add Payment template'),
                      leading: Icon(
                        Icons.monetization_on,
                        color: CustomColors.mfinBlue,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPaymentTemplate(),
                            settings: RouteSettings(
                                name:
                                    '/transactions/collectionbook/template/add'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Add Expense Categories'),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: CustomColors.mfinBlue,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddExpenseCategory(),
                            settings: RouteSettings(
                                name: '/transactions/expenses/categories/add'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                        title: Text('Add Journal Categories'),
                        leading: Icon(
                          Icons.library_books,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddJournalCategory(),
                              settings: RouteSettings(
                                  name: '/transactions/journal/categories/add'),
                            ),
                          );
                        }),
                    ListTile(
                      title: Text('Home'),
                      leading: Icon(
                        Icons.home,
                        color: CustomColors.mfinBlue,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserHomeScreen(),
                          settings: RouteSettings(name: '/home'),
                        ),
                      ),
                    )
                  ],
                ),
              ));
            },
          );
        },
        backgroundColor: CustomColors.mfinBlue,
        splashColor: CustomColors.mfinWhite,
        child: Icon(
          Icons.navigation,
          size: 30,
          color: CustomColors.mfinButtonGreen,
        ),
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
                  PaymentTemplateListWidget(_scaffoldKey)
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
                  ExpenseCategoryListWidget(_scaffoldKey),
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
                  JournalCategoryListWidget(_scaffoldKey),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(40))
          ],
        ),
      ),
    );
  }
}
