import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/screens/transaction/add/AddPaymentTemplate.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';

class PaymentTemplateScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Payment Templates"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPaymentTemplate(),
              settings: RouteSettings(
                  name: '/transactions/collectionbook/template/add'),
            ),
          );
        },
        label: Text(
          'Add',
          style: TextStyle(
            color: CustomColors.mfinWhite,
            fontSize: 16,
          ),
        ),
        icon: Icon(
          Icons.add,
          size: 40,
          color: CustomColors.mfinFadedButtonGreen,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: PaymentTemplate().streamTemplates(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Widget widget;

          if (snapshot.hasData) {
            if (snapshot.data.documents.isNotEmpty) {
              widget = ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  PaymentTemplate temp = PaymentTemplate.fromJson(
                      snapshot.data.documents[index].data);

                  Color cardColor = CustomColors.mfinGrey;
                  Color textColor = CustomColors.mfinBlue;
                  if (index % 2 == 0) {
                    cardColor = CustomColors.mfinBlue;
                    textColor = CustomColors.mfinGrey;
                  }

                  return SimpleFoldingCell(
                      frontWidget: _buildFrontWidget(
                          context, temp, cardColor, textColor),
                      innerTopWidget: _buildInnerTopWidget(temp),
                      innerBottomWidget: _buildInnerBottomWidget(context, temp),
                      cellSize: Size(MediaQuery.of(context).size.width, 170),
                      padding: EdgeInsets.only(
                          left: 15.0, top: 5.0, right: 15.0, bottom: 5.0),
                      animationDuration: Duration(milliseconds: 300),
                      borderRadius: 10,
                      onOpen: () => print('$index cell opened'),
                      onClose: () => print('$index cell closed'));
                },
              );
            } else {
              // No Journal Entry added yet
              widget = Container(
                alignment: Alignment.center,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Payment Templates so far!",
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
                      "Add and Manage your Payments here!",
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
            widget = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncError(),
              ),
            );
          } else {
            widget = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncWaiting(),
              ),
            );
          }

          return widget;
        },
      ),
    );
  }

  Widget _buildFrontWidget(BuildContext context, PaymentTemplate temp,
      Color cardColor, Color textColor) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.30,
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
                  content:
                      Text('Are you sure to remove ${temp.name} template?'),
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
                        var result =
                            await _ctc.removeTemp(temp.getDocumentID());
                        if (!result['is_success']) {
                          _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(
                                  result['message'], 5));
                          print("Unable to remove Template: " +
                              result['message']);
                        } else {
                          print("Template removed successfully");
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
          color: textColor,
          icon: Icons.edit,
          onTap: () {},
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return InkWell(
            onTap: () {
              SimpleFoldingCellState foldingCellState =
                  context.findAncestorStateOfType();
              foldingCellState?.toggleFold();
            },
            child: Container(
              color: cardColor,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(
                      'NAME',
                      style: TextStyle(
                          color: textColor,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      temp.name,
                      style: TextStyle(
                          color: CustomColors.mfinWhite,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      "AMOUNT",
                      style: TextStyle(
                          color: textColor,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      temp.totalAmount.toString(),
                      style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      'COLLECTION',
                      style: TextStyle(
                          color: textColor,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: RichText(
                      text: TextSpan(
                        text: '${temp.tenure}',
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' x ',
                            style: TextStyle(
                              color: CustomColors.mfinWhite,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '${temp.collectionAmount}',
                            style: TextStyle(
                              color: CustomColors.mfinButtonGreen,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInnerBottomWidget(BuildContext context, PaymentTemplate temp) {
    return Container(
      color: CustomColors.mfinBlue,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              'PRINCIPAL',
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              temp.principalAmount.toString(),
              style: TextStyle(
                  color: CustomColors.mfinWhite,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text(
              'Notes',
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                temp.tenureType.toString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: CustomColors.mfinWhite,
                    fontFamily: 'Georgia',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerTopWidget(PaymentTemplate temp) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            SimpleFoldingCellState foldingCellState =
                context.findAncestorStateOfType();
            foldingCellState?.toggleFold();
          },
          child: Container(
            color: CustomColors.mfinGrey,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    'NAME',
                    style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    temp.name,
                    style: TextStyle(
                        color: CustomColors.mfinWhite,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "AMOUNT",
                    style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    temp.totalAmount.toString(),
                    style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'COLLECTION',
                    style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: RichText(
                    text: TextSpan(
                      text: '${temp.tenure}',
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' x ',
                          style: TextStyle(
                            color: CustomColors.mfinWhite,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${temp.collectionAmount}',
                          style: TextStyle(
                            color: CustomColors.mfinButtonGreen,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
