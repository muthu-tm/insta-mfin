import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/screens/transaction/edit/EditJournalCategory.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';

class JournalCategoryListWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: JournalCategory().streamAllCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<JournalCategory>> snapshot) {
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
                                        'Are you sure to remove ${snapshot.data[index].categoryName} Category?'),
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
                                              await _cc.removeJournalCategory(
                                                  snapshot
                                                      .data[index].financeID,
                                                  snapshot
                                                      .data[index].branchName,
                                                  snapshot.data[index]
                                                      .subBranchName,
                                                  snapshot
                                                      .data[index].createdAt);
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
                                            print(
                                                "Category removed successfully");
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
                                  builder: (context) => EditJournalCategory(
                                      JournalCategory.fromJson(snapshot.data[index].toJson())),
                                  settings: RouteSettings(
                                      name:
                                          '/transactions/journal/categories/edit'),
                                ),
                              );
                            },
                          ),
                        ],
                        child:
                            _expenseList(context, index, snapshot.data[index]),
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
        });
  }

  _expenseList(BuildContext context, int index, JournalCategory data) {
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
