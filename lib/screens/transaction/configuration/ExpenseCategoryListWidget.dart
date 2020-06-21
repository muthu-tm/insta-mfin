import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/expense_category.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/transaction/edit/EditExpenseCategory.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class ExpenseCategoryListWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final User _u = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ExpenseCategory().streamCategories(
            _u.primaryFinance, _u.primaryBranch, _u.primarySubBranch),
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
                      ExpenseCategory category = ExpenseCategory.fromJson(
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
                                        'Are you sure to remove ${category.categoryName} Category?'),
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
                                          CategoryController _cc =
                                              CategoryController();
                                          var result =
                                              await _cc.removeExpenseCategory(
                                                  category.financeID,
                                                  category.branchName,
                                                  category.subBranchName,
                                                  category.createdAt);
                                          if (!result['is_success']) {
                                            Navigator.pop(context);
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                "Unable to remove the category!",
                                                3,
                                              ),
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                  "Category removed successfully",
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
                            color: CustomColors.mfinBlue,
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditExpenseCategory(category),
                                  settings: RouteSettings(
                                      name:
                                          '/transactions/expenses/categories/edit'),
                                ),
                              );
                            },
                          ),
                        ],
                        child: _expenseList(context, index, category),
                      );
                    })
              ];
            } else {
              // No Categories added yet
              return Container(
                alignment: Alignment.center,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Categories!",
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
                      "Add your Categories!",
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
        });
  }

  _expenseList(BuildContext context, int index, ExpenseCategory data) {
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
              width: MediaQuery.of(context).size.width * 0.90,
              height: 80,
              child: ListTile(
                title: Text(
                  data.categoryName,
                  style: TextStyle(
                      color: CustomColors.mfinWhite,
                      fontFamily: 'Georgia',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  data.notes,
                  style: TextStyle(
                    color: CustomColors.mfinWhite,
                    fontFamily: 'Georgia',
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
