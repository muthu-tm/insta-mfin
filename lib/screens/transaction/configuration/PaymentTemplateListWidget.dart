import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/screens/transaction/edit/EditPaymentTemplate.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';

class PaymentTemplateListWidget extends StatelessWidget {
  final List _collectionMode = ["Daily", "Weekly", "Monthly"];
  final GlobalKey<ScaffoldState> _scaffoldKey;

  PaymentTemplateListWidget(this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PaymentTemplate().streamTemplates(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            children = <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    PaymentTemplate temp = PaymentTemplate.fromJson(
                        snapshot.data.documents[index].data);
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      closeOnScroll: true,
                      direction: Axis.horizontal,
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Remove',
                          color: CustomColors.mfinAlertRed,
                          icon: Icons.delete_forever,
                          onTap: () async {
                            var state = Slidable.of(context);
                            var dismiss = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: new Text(
                                    "Confirm!",
                                    style: TextStyle(
                                        color: CustomColors.mfinAlertRed,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  content: Text(
                                      'Are you sure to remove ${temp.name} template?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: CustomColors.mfinButtonGreen,
                                      child: Text(
                                        "NO",
                                        style: TextStyle(
                                            color: CustomColors.mfinBlue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      color: CustomColors.mfinAlertRed,
                                      child: Text(
                                        "YES",
                                        style: TextStyle(
                                            color: CustomColors.mfinLightGrey,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        PaymentTemplateController _ctc =
                                            PaymentTemplateController();
                                        var result = await _ctc
                                            .removeTemp(temp.getDocumentID());
                                        if (!result['is_success']) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                                  CustomSnackBar.errorSnackBar(
                                                      result['message'], 5));
                                          print("Unable to remove Template: " +
                                              result['message']);
                                          _scaffoldKey.currentState.showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                  "Unable to remove Template",
                                                  2));
                                        } else {
                                          _scaffoldKey.currentState.showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                  "Template removed successfully",
                                                  2));
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (dismiss != null && dismiss && state != null) {
                              state.dismiss();
                            }
                          },
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: CustomColors.mfinBlue,
                          icon: Icons.edit,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPaymentTemplate(temp),
                              settings: RouteSettings(
                                  name:
                                      '/transactions/collectionbook/template/edit'),
                            ),
                          ),
                        ),
                      ],
                      child: _paymentList(context, index, temp),
                    );
                  })
            ];
          } else {
            // No Template added yet
            return Container(
              alignment: Alignment.center,
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Spacer(),
                  Text(
                    "No Payment Templates!",
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
                    "Add your Templates and make your Payment faster!",
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
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError(),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting(),
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  _paymentList(BuildContext context, int index, PaymentTemplate template) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              color: CustomColors.mfinBlue,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.36,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        template.totalAmount.toString(),
                        style: TextStyle(
                            color: CustomColors.mfinAlertRed,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      height: 30,
                      child: RichText(
                        text: TextSpan(
                          text: '${template.tenure}',
                          style: TextStyle(
                            color: CustomColors.mfinWhite,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' x ',
                              style: TextStyle(
                                color: CustomColors.mfinBlack,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${template.collectionAmount}',
                              style: TextStyle(
                                color: CustomColors.mfinFadedButtonGreen,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: CustomColors.mfinWhite,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.56,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: ListTile(
                        title: Text(
                          template.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _collectionMode[template.collectionMode],
                          style: TextStyle(
                            fontSize: 18,
                            color: CustomColors.mfinBlue,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
