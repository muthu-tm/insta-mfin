import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/screens/transaction/edit/EditPaymentTemplate.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';

class PaymentTemplateListWidget extends StatelessWidget {
  List _collectionMode = ["Daily", "Weekly", "Monthly"];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PaymentTemplateController().streamAllPaymentTemplates(),
      builder: (BuildContext context,
          AsyncSnapshot<List<PaymentTemplate>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      closeOnScroll: true,
                      direction: Axis.horizontal,
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Remove',
                          color: CustomColors.mfinAlertRed,
                          icon: Icons.edit,
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
                                      'Are you sure to remove ${snapshot.data[index].name} template?'),
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
                                        _scaffoldKey.currentState.showSnackBar(
                                            CustomSnackBar.errorSnackBar(
                                                "Removing a template", 2));
                                        PaymentTemplateController _ctc =
                                            PaymentTemplateController();
                                        var result = await _ctc
                                            .removeTemp(snapshot.data[index].getDocumentID());
                                        if (!result['is_success']) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                                  CustomSnackBar.errorSnackBar(
                                                      result['message'], 5));
                                          print("Unable to remove Template: " +
                                              result['message']);
                                        } else {
                                          print(
                                              "Template removed successfully");
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
                              builder: (context) =>
                                  EditPaymentTemplate(snapshot.data[index]),
                              settings: RouteSettings(
                                  name:
                                      '/transactions/collectionbook/template/edit'),
                            ),
                          ),
                        ),
                      ],
                      child: _paymentList(context, index, snapshot.data[index]),
                    );
                  })
            ];
          }
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
    );
  }
}
