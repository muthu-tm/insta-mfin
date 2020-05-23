import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/collection/PaymentTemplatesScreen.dart';
import 'package:instamfin/screens/transaction/widgets/TransactionsAppBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CollectionBookHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: transactionsAppBar(
            context,
            "Collection Book",
            '/transactions/collectionbook/template',
            PaymentTemplateScreen()),
        body: Center(
            child: Text(
          "TODO",
          style: TextStyle(
            color: CustomColors.mfinAlertRed,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        )));
  }
}
