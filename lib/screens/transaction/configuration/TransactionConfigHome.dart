import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/transaction/add/AddChitTemplate.dart';
import 'package:instamfin/screens/transaction/add/AddExpenseCategory.dart';
import 'package:instamfin/screens/transaction/add/AddJournalCategory.dart';
import 'package:instamfin/screens/transaction/add/AddPaymentTemplate.dart';
import 'package:instamfin/screens/transaction/configuration/ChitTemplateListWidget.dart';
import 'package:instamfin/screens/transaction/configuration/ExpenseCategoryListWidget.dart';
import 'package:instamfin/screens/transaction/configuration/JournalCategoryListWidget.dart';
import 'package:instamfin/screens/transaction/configuration/PaymentTemplateListWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instamfin/app_localizations.dart';

class TransactionConfigHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("transaction_configuration")),
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
                      title: Text(AppLocalizations.of(context).translate("add_payment_template")),
                      leading: Icon(
                        Icons.monetization_on,
                        color: CustomColors.mfinBlue,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPaymentTemplate(),
                            settings: RouteSettings(
                                name:
                                    '/transactions/config/payment/template/add'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                        title: Text(AppLocalizations.of(context).translate("add_chit_template")),
                        leading: Icon(
                          Icons.transfer_within_a_station,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddChitTemplate(),
                              settings: RouteSettings(
                                  name:
                                      '/transactions/config/chit/template/add'),
                            ),
                          );
                        }),
                    ListTile(
                      title: Text(AppLocalizations.of(context).translate("add_expense_categories")),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: CustomColors.mfinBlue,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddExpenseCategory(),
                            settings: RouteSettings(
                                name:
                                    '/transactions/config/expenses/categories/add'),
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddJournalCategory(),
                              settings: RouteSettings(
                                  name:
                                      '/transactions/config/journal/categories/add'),
                            ),
                          );
                        }),
                    ListTile(
                      title: Text('Home'),
                      leading: Icon(
                        Icons.home,
                        color: CustomColors.mfinBlue,
                      ),
                      onTap: () async {
                        await UserController().refreshUser(false);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserFinanceSetup(),
                            settings: RouteSettings(name: '/home'),
                          ),
                        );
                      },
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate("payments_template"),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate("chit_fund_template"),
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
                  ChitTemplateListWidget(_scaffoldKey)
                ],
              ),
            ),
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              margin: EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate("expense_categories"),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate("journal_categories"),
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
