import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:instamfin/db/models/miscellaneous_expense.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/transaction/add/AddMiscellaneousExpense.dart';
import 'package:instamfin/screens/transaction/widgets/MiscellaneousAppBar.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/Miscellaneous_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class MiscellaneousExpenseHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: miscellaneousAppBar(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMiscellaneousExpense(),
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
        // backgroundColor: CustomColors.mfinBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: MiscellaneousExpense().streamExpenses(_user.primaryFinance,
              _user.primaryBranch, _user.primarySubBranch),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Widget widget;

            if (snapshot.hasData) {
              if (snapshot.data.documents.isNotEmpty) {
                widget = ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    String categoryName = "";

                    if (snapshot.data.documents[index].data['category'] !=
                        null) {
                      categoryName = snapshot.data.documents[index]
                          .data['category']['category_name'];
                    }

                    Color cardColor = CustomColors.mfinGrey;
                    Color textColor = CustomColors.mfinBlue;
                    if (index % 2 == 0) {
                      cardColor = CustomColors.mfinBlue;
                      textColor = CustomColors.mfinGrey;
                    }
                    return SimpleFoldingCell(
                        frontWidget: _buildFrontWidget(
                            context,
                            snapshot.data.documents[index].data,
                            cardColor,
                            textColor),
                        innerTopWidget: _buildInnerTopWidget(
                            snapshot.data.documents[index].data['expense_name'],
                            snapshot.data.documents[index].data['amount']),
                        innerBottomWidget: _buildInnerBottomWidget(
                            snapshot.data.documents[index].data['notes'],
                            snapshot.data.documents[index].data['expense_date']
                                .toDate(),
                            categoryName),
                        cellSize: Size(MediaQuery.of(context).size.width, 170),
                        padding:
                            EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0, bottom: 5.0),
                        animationDuration: Duration(milliseconds: 300),
                        borderRadius: 10,
                        onOpen: () => print('$index cell opened'),
                        onClose: () => print('$index cell closed'));
                  },
                );
              } else {
                // No Expenses added yet
                widget = Container(
                  alignment: Alignment.center,
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Spacer(),
                      Text(
                        "No Expenses so far!",
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
                        "Add and Manage your expenses here!",
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

  Widget _buildFrontWidget(BuildContext context, Map<String, dynamic> data,
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
                  content: Text(
                      'Are you sure to remove ${data['expense_name']} Expense?'),
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
                        MiscellaneousController _mc = MiscellaneousController();
                        var result = await _mc.removeMiscellaneousExpense(
                            data['finance_id'],
                            data['branch_name'],
                            data['sub_branch_name'],
                            data['created_at'].toDate());
                        if (!result['is_success']) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                            CustomSnackBar.errorSnackBar(
                              "Unable to remove the Expense ${data['expense_name']}!",
                              3,
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          print(
                              "Miscellaneous Expense ${data['expense_name']} removed successfully");
                          _scaffoldKey.currentState.showSnackBar(
                            CustomSnackBar.errorSnackBar(
                                "Expense ${data['expense_name']} removed successfully",
                                2),
                          );
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
          return Container(
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
                    data['expense_name'],
                    style: TextStyle(
                        color: CustomColors.mfinWhite,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'AMOUNT',
                    style: TextStyle(
                        color: textColor,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    data['amount'].toString(),
                    style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    SimpleFoldingCellState foldingCellState =
                        context.findAncestorStateOfType();
                    foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "View",
                  ),
                  textColor: CustomColors.mfinWhite,
                  color: CustomColors.mfinButtonGreen,
                  splashColor: Colors.white.withOpacity(0.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInnerBottomWidget(
      String notes, DateTime expenseDate, String category) {
    return Container(
      color: CustomColors.mfinBlue,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              'Date',
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              DateUtils.formatDate(expenseDate),
              style: TextStyle(
                  color: CustomColors.mfinWhite,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text(
              'Category',
              style: TextStyle(
                  color: CustomColors.mfinGrey,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              category,
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
            trailing: Text(
              notes,
              style: TextStyle(
                  color: CustomColors.mfinWhite,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerTopWidget(String name, int amount) {
    return Builder(
      builder: (context) {
        return Container(
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
                  name,
                  style: TextStyle(
                      color: CustomColors.mfinWhite,
                      fontFamily: 'Georgia',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Text(
                  'AMOUNT',
                  style: TextStyle(
                      color: CustomColors.mfinBlue,
                      fontFamily: 'Georgia',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  amount.toString(),
                  style: TextStyle(
                      color: CustomColors.mfinAlertRed,
                      fontFamily: 'Georgia',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () {
                  SimpleFoldingCellState foldingCellState =
                      context.findAncestorStateOfType();
                  foldingCellState?.toggleFold();
                },
                child: Text(
                  "Close",
                ),
                textColor: CustomColors.mfinWhite,
                color: CustomColors.mfinButtonGreen,
                splashColor: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}
