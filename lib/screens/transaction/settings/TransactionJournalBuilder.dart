import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionJournalBuilder extends StatelessWidget {
  final JournalController _jc = JournalController();

  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _user.getFinanceDocReference().get().asStream(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
                child: ListTile(
                  leading: Text(
                    "In: ",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    snapshot.data.data['journal_in'].toString(),
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinPositiveGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                child: ListTile(
                  leading: Text(
                    "Out: ",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    snapshot.data.data['journal_out'].toString(),
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinAlertRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
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
