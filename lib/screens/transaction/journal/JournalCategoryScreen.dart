import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/transaction/add/AddJournalCategory.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class JournalCategoryScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Journal Categories"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddJournalCategory(),
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
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: JournalCategory().streamCategories(_user.primaryFinance,
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
                        innerTopWidget: _buildInnerTopWidget(snapshot
                            .data.documents[index].data['category_name']),
                        innerBottomWidget: _buildInnerBottomWidget(
                            snapshot.data.documents[index].data['notes']),
                        cellSize: Size(MediaQuery.of(context).size.width, 80),
                        padding:
                            EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
                        animationDuration: Duration(milliseconds: 300),
                        borderRadius: 10,
                        onOpen: () => print('$index cell opened'),
                        onClose: () => print('$index cell closed'));
                  },
                );
              } else {
                // No Category available
                widget = Center(
                  child: Container(
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
      ),
    );
  }

  Widget _buildFrontWidget(BuildContext context, Map<String, dynamic> data,
      Color cardColor, Color textColor) {
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
                      'Are you sure to remove ${data['category_name']} Category?'),
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
                        CategoryController _cc = CategoryController();
                        var result = await _cc.removeJournalCategory(
                            data['finance_id'],
                            data['branch_name'],
                            data['sub_branch_name'],
                            data['created_at'].toDate());
                        if (!result['is_success']) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                            CustomSnackBar.errorSnackBar(
                              "Unable to remove the category!",
                              3,
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          print("Category removed successfully");
                          _scaffoldKey.currentState.showSnackBar(
                            CustomSnackBar.errorSnackBar(
                                "Category removed successfully", 2),
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
            child: ListTile(
              leading: Text(
                data['category_name'],
                style: TextStyle(
                    color: textColor,
                    fontFamily: 'Georgia',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              trailing: FlatButton(
                onPressed: () {
                  SimpleFoldingCellState foldingCellState =
                      context.findAncestorStateOfType();
                  foldingCellState?.toggleFold();
                },
                child: Text(
                  "View",
                ),
                textColor: CustomColors.mfinBlack,
                color: CustomColors.mfinFadedButtonGreen,
                splashColor: Colors.white.withOpacity(0.5),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInnerBottomWidget(String notes) {
    return Container(
      color: CustomColors.mfinBlue,
      alignment: Alignment.center,
      child: Text(
        notes,
        style: TextStyle(
            color: CustomColors.mfinWhite,
            fontFamily: 'Georgia',
            fontSize: 18.0,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _buildInnerTopWidget(String name) {
    return Builder(
      builder: (context) {
        return Container(
          color: CustomColors.mfinGrey,
          alignment: Alignment.center,
          child: ListTile(
            leading: Text(
              name,
              style: TextStyle(
                  color: CustomColors.mfinWhite,
                  fontFamily: 'Georgia',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: FlatButton(
              onPressed: () {
                SimpleFoldingCellState foldingCellState =
                    context.findAncestorStateOfType();
                foldingCellState?.toggleFold();
              },
              child: Text(
                "Close",
              ),
              textColor: Colors.white,
              color: CustomColors.mfinBlue,
              splashColor: Colors.white.withOpacity(0.5),
            ),
          ),
        );
      },
    );
  }
}
