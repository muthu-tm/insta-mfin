import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/transaction/add/AddJournal.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class JournalEntryHome extends StatefulWidget {
  @override
  _JournalEntryHomeState createState() => _JournalEntryHomeState();
}

class _JournalEntryHomeState extends State<JournalEntryHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final User _user = UserController().getCurrentUser();

  DateTime _selectedFrom = DateTime.now();
  TextEditingController _fromDate = new TextEditingController();
  DateTime _selectedTo = DateTime.now();
  TextEditingController _toDate = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _user.preferences.transactionGroupBy == 0
        ? _selectedFrom = DateTime.now()
        : _user.preferences.transactionGroupBy == 1
            ? _selectedFrom =
                DateTime.now().subtract(Duration(days: DateTime.now().weekday))
            : _selectedFrom = DateTime(
                DateTime.now().year, DateTime.now().month, 1, 0, 0, 0, 0, 0);

    _fromDate.text = DateUtils.formatDate(_selectedFrom);
    _toDate.text = DateUtils.formatDate(_selectedTo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Journal Entries"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.mfinBlue,
        splashColor: CustomColors.mfinWhite,
        child: Icon(
          Icons.navigation,
          size: 30,
          color: CustomColors.mfinButtonGreen,
        ),
        onPressed: () {
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context, scrollController) {
              return Material(
                child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Add Journal'),
                          leading: Icon(
                            Icons.monetization_on,
                            color: CustomColors.mfinBlue,
                          ),
                          onTap: () {
                            if (_user.financeSubscription <
                                    DateUtils.getUTCDateEpoch(DateTime.now()) &&
                                _user.chitSubscription <
                                    DateUtils.getUTCDateEpoch(DateTime.now())) {
                              _scaffoldKey.currentState.showSnackBar(
                                  CustomSnackBar.errorSnackBar(
                                      "Your subscription has expired. Please Recharge to continue!",
                                      3));
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddJournal(),
                                settings: RouteSettings(
                                    name: '/transactions/journal/add'),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Home'),
                          leading: Icon(
                            Icons.home,
                            color: CustomColors.mfinBlue,
                          ),
                          onTap: () async {
                            await UserController().refreshUser(false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserFinanceSetup(),
                                settings: RouteSettings(name: '/home'),
                              ),
                            );
                          },
                        )
                      ],
                    )),
              );
            },
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: "FROM",
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () => _selectFromDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _fromDate,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 3.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomColors.mfinWhite)),
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                            suffixIcon: Icon(
                              Icons.date_range,
                              size: 35,
                              color: CustomColors.mfinBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: "TO",
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () => _selectToDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _toDate,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 3.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomColors.mfinWhite)),
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                            suffixIcon: Icon(
                              Icons.date_range,
                              size: 35,
                              color: CustomColors.mfinBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: StreamBuilder<QuerySnapshot>(
                stream: Journal().streamJournalsByDateRange(
                    DateUtils.getUTCDateEpoch(_selectedFrom),
                    DateUtils.getUTCDateEpoch(_selectedTo)),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  Widget widget;

                  if (snapshot.hasData) {
                    if (snapshot.data.documents.isNotEmpty) {
                      widget = ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          String categoryName = "";
                          String journalText = "INCOME";

                          if (snapshot.data.documents[index].data['category'] !=
                              null) {
                            categoryName = snapshot.data.documents[index]
                                .data['category']['category_name'];
                          }

                          if (snapshot
                              .data.documents[index].data['is_expense']) {
                            journalText = "EXPENSE";
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
                                  journalText,
                                  cardColor,
                                  textColor),
                              innerTopWidget: _buildInnerTopWidget(
                                  snapshot.data.documents[index]
                                      .data['journal_name'],
                                  snapshot.data.documents[index].data['amount'],
                                  journalText),
                              innerBottomWidget: _buildInnerBottomWidget(
                                  context,
                                  snapshot.data.documents[index].data['notes'],
                                  DateTime.fromMillisecondsSinceEpoch(snapshot
                                      .data
                                      .documents[index]
                                      .data['journal_date']),
                                  categoryName),
                              cellSize:
                                  Size(MediaQuery.of(context).size.width, 170),
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  top: 5.0,
                                  right: 15.0,
                                  bottom: 5.0),
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
                              "No Adjustments Entries so far!",
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
                              "Add and Manage your Adjustments here!",
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontWidget(BuildContext context, Map<String, dynamic> data,
      String journalText, Color cardColor, Color textColor) {
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
                      'Are you sure to remove ${data['journal_name']} Journal?'),
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
                        JournalController _mc = JournalController();
                        var result = await _mc.removeJournal(
                            data['finance_id'],
                            data['branch_name'],
                            data['sub_branch_name'],
                            data['created_at'].toDate());
                        if (!result['is_success']) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                            CustomSnackBar.errorSnackBar(
                              "Unable to remove the Journal ${data['expense_name']}!",
                              3,
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          print(
                              "Journal Entry ${data['journal_name']} removed successfully");
                          _scaffoldKey.currentState.showSnackBar(
                            CustomSnackBar.errorSnackBar(
                                "Journal Entry ${data['journal_name']} removed successfully",
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
      // secondaryActions: <Widget>[
      //   IconSlideAction(
      //     caption: 'Edit',
      //     color: textColor,
      //     icon: Icons.edit,
      //     onTap: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) =>
      //               EditJournalEntry(Journal.fromJson(data)),
      //           settings: RouteSettings(name: '/transactions/journal/edit'),
      //         ),
      //       );
      //     },
      //   ),
      // ],
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
                    data['journal_name'],
                    style: TextStyle(
                        color: CustomColors.mfinWhite,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Text(
                    journalText,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    data['amount'].toString(),
                    style: TextStyle(
                        color: (journalText == "INCOME")
                            ? CustomColors.mfinFadedButtonGreen
                            : CustomColors.mfinAlertRed,
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

  Widget _buildInnerBottomWidget(BuildContext context, String notes,
      DateTime expenseDate, String category) {
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
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  notes,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: CustomColors.mfinWhite,
                      fontFamily: 'Georgia',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInnerTopWidget(String name, int amount, String journalText) {
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
                  journalText,
                  style: TextStyle(
                      color: CustomColors.mfinBlue,
                      fontFamily: 'Georgia',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  amount.toString(),
                  style: TextStyle(
                      color: (journalText == "INCOME")
                          ? CustomColors.mfinFadedButtonGreen
                          : CustomColors.mfinAlertRed,
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

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedFrom,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedFrom)
      setState(
        () {
          _selectedFrom = picked;
          _fromDate.text = DateUtils.formatDate(picked);
        },
      );
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedTo,
      firstDate: _selectedFrom,
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedTo)
      setState(
        () {
          _selectedTo = picked;
          _toDate.text = DateUtils.formatDate(picked);
        },
      );
  }
}
