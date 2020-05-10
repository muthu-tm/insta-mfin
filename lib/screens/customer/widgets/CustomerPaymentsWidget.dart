import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class CustomerPaymentsWidget extends StatelessWidget {
  CustomerPaymentsWidget(this.number);
  final User _user = UserController().getCurrentUser();

  final int number;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Payment().streamPayments(_user.primaryFinance,
          _user.primaryBranch, _user.primarySubBranch, number),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Payment payment =
                      Payment.fromJson(snapshot.data.documents[index].data);
                  return Container();
                },
              )
            ];
          } else {
            // No payments available for this customer
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Payments!",
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Spacer(
                      flex: 2,
                    ),
                    Text(
                      "Add this customer's Payments!",
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    new Spacer(),
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: RichText(
                  text: TextSpan(
                    text: "Total: ",
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinGrey,
                      fontSize: 18.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: snapshot.hasData
                              ? snapshot.data.documents.length.toString()
                              : "00",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                            fontSize: 18.0,
                          )),
                    ],
                  ),
                ),
                trailing: RaisedButton.icon(
                  color: CustomColors.mfinLightGrey,
                  highlightColor: CustomColors.mfinLightGrey,
                  onPressed: null,
                  icon: customIconButton(
                    Icons.swap_vert,
                    35.0,
                    CustomColors.mfinBlue,
                    null,
                  ),
                  label: Text(
                    "Sort by",
                    style: TextStyle(
                      fontSize: 18,
                      color: CustomColors.mfinBlue,
                    ),
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
