import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/configuration/PaymentTemplateListWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class TransactionConfigHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction configurations'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            color: CustomColors.mfinLightGrey,
            elevation: 5.0,
            margin: EdgeInsets.only(top: 5.0),
            shadowColor: CustomColors.mfinLightBlue,
            child: Column(
              children: <Widget>[
                Center(child: Text("Payment template", style: TextStyle(color: Colors.black),)),
                PaymentTemplateListWidget()
              ],
            ),
          ),
          Card(),
          Card(),
        ],
      ),
    );
  }
}
