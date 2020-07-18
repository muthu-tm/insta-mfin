import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class SettingsPreferences extends StatefulWidget {
  @override
  _SettingsPreferencesState createState() => _SettingsPreferencesState();
}

class _SettingsPreferencesState extends State<SettingsPreferences> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  var transctionGroupValue = 0;
  List<bool> isSelectedView = [false, true];
  bool isTableView = false;

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController intrestRateController = TextEditingController();

  Map<String, dynamic> userPreferencesJSON = new Map();
  Map<String, dynamic> accountPreferencesJSON = new Map();

  String _selectedLang = 'English';
  List<String> _prefSupportLangList = ["English", "Tamil", "Hindi", "Kannada"];
  String selectedCollectionModeID = "0";
  bool chitEnabled = false;
  List<String> chits = ['YES', 'NO'];

  Map<String, String> _tempCollectionMode = {
    "0": "Daily",
    "1": "Weekly",
    "2": "Monthly"
  };

  List<int> collectionDays;
  Map<String, String> tempCollectionDays = {
    "0": "Sun",
    "1": "Mon",
    "2": "Tue",
    "3": "Wed",
    "4": "Thu",
    "5": "Fri",
    "6": "Sat",
  };

  @override
  void initState() {
    super.initState();
    this.setAccountDetails();
    this.transctionGroupValue = _user.preferences.transactionGroupBy;
    this._selectedLang = _user.preferences.prefLanguage;
    if (_user.preferences.tableView) {
      isSelectedView = [true, false];
      isTableView = true;
    }
    this.chitEnabled = _user.accPreferences.chitEnabled;
    this.userPreferencesJSON = _user.preferences.toJson();
    this.intrestRateController.text =
        _user.accPreferences.interestRate.toString() ?? '0.00';
    this.selectedCollectionModeID =
        _user.accPreferences.collectionMode.toString() ?? '0';
    this.collectionDays =
        _user.accPreferences.collectionDays ?? [1, 2, 3, 4, 5];
  }

  Future setAccountDetails() async {
    try {
      Map<String, dynamic> data =
          (await _user.getFinanceDocReference().get()).data;

      this.accountPreferencesJSON = data['preferences'];
      if (_user.accPreferences.reportSignature != null &&
          _user.accPreferences.reportSignature != "")
        _textEditingController.text = _user.accPreferences.reportSignature;
      else {
        Address add = Address.fromJson(data['address']);
        _textEditingController.text = add.toString();
      }
    } catch (err) {
      print("Unable to load Account Preferences!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Preferences"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () async {
          _submit();
        },
        label: Text(
          "Save",
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.check,
          size: 35,
          color: CustomColors.mfinFadedButtonGreen,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Finance Preferences",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Georgia",
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    color: CustomColors.mfinButtonGreen,
                  ),
                  RowHeaderText(textName: "REPORT's SIGNATURE"),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.multiline,
                      controller: _textEditingController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      autofocus: false,
                    ),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0, top: 10),
                        child: Text(
                          "Chit Fund",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: CustomColors.mfinWhite)),
                          ),
                          items: chits.map(
                            (f) {
                              return DropdownMenuItem<String>(
                                value: f,
                                child: Text(f),
                              );
                            },
                          ).toList(),
                          onChanged: (newVal) {
                            _setChitOption(newVal);
                          },
                          value: chitEnabled ? "YES" : "NO",
                        ),
                      ),
                    ),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 10),
                            child: Text(
                              "Interest Rate",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinGrey,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: TextFormField(
                              controller: intrestRateController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Rate in 0.00',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 10),
                            child: Text(
                              "Collection Mode",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinGrey,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              items: _tempCollectionMode.entries.map(
                                (f) {
                                  return DropdownMenuItem<String>(
                                    value: f.key,
                                    child: Text(f.value),
                                  );
                                },
                              ).toList(),
                              onChanged: (newVal) {
                                _setSelectedCollectionMode(newVal);
                              },
                              value: selectedCollectionModeID,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RowHeaderText(textName: "Collection Days"),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: CustomColors.mfinGrey, width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: selectedDays.toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              color: CustomColors.mfinLightGrey,
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "User Preferences",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Georgia",
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0, top: 10),
                        child: Text(
                          "SUPPORT Language",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                            ),
                            items: _prefSupportLangList.map(
                              (f) {
                                return DropdownMenuItem<String>(
                                  value: f,
                                  child: Text(f),
                                );
                              },
                            ).toList(),
                            value: _selectedLang,
                            onChanged: (newVal) {
                              _setSelectedLang(newVal);
                            }),
                      ),
                    ),
                  ]),
                  RowHeaderText(textName: "TRANSACTIONS GROUP BY"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: transctionGroupValue,
                        activeColor: CustomColors.mfinBlue,
                        onChanged: (val) {
                          setTransaction(val);
                        },
                      ),
                      Text(
                        "Daily",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Georgia",
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 1,
                        groupValue: transctionGroupValue,
                        activeColor: CustomColors.mfinBlue,
                        onChanged: (val) {
                          setTransaction(val);
                        },
                      ),
                      Text(
                        "Weekly",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Georgia",
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 2,
                        groupValue: transctionGroupValue,
                        activeColor: CustomColors.mfinBlue,
                        onChanged: (val) {
                          setTransaction(val);
                        },
                      ),
                      Text(
                        "Monthly",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Georgia",
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  RowHeaderText(textName: "COLLECTION VIEW"),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ToggleButtons(
                      borderColor: CustomColors.mfinButtonGreen,
                      selectedBorderColor: CustomColors.mfinBlue,
                      fillColor: CustomColors.mfinButtonGreen,
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "Georgia",
                        color: CustomColors.mfinButtonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      borderWidth: 2,
                      selectedColor: CustomColors.mfinBlue,
                      borderRadius: BorderRadius.circular(5),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: 15, left: 15, bottom: 5, top: 5),
                          child: Text(
                            'Table View',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 15, left: 15, bottom: 5, top: 5),
                          child: Text(
                            'List View',
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSelectedView.length; i++) {
                            isSelectedView[i] = i == index;
                          }
                        });
                      },
                      isSelected: isSelectedView,
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(35)),
          ],
        ),
      ),
    );
  }

  _setChitOption(String newVal) {
    setState(() {
      if (newVal == "YES")
        chitEnabled = true;
      else
        chitEnabled = false;
    });
  }

  _setSelectedCollectionMode(String newVal) {
    setState(() {
      selectedCollectionModeID = newVal;
    });
  }

  _setSelectedLang(String newVal) {
    setState(() {
      _selectedLang = newVal;
    });
  }

  setTransaction(int val) {
    setState(() {
      this.transctionGroupValue = val;
    });

    userPreferencesJSON['transaction_group_by'] = val;
  }

  Iterable<Widget> get selectedDays sync* {
    for (MapEntry days in tempCollectionDays.entries) {
      yield Transform(
        transform: Matrix4.identity()..scale(0.9),
        child: ChoiceChip(
            label: Text(days.value),
            selected: collectionDays.contains(int.parse(days.key)),
            elevation: 5.0,
            selectedColor: CustomColors.mfinBlue,
            backgroundColor: CustomColors.mfinWhite,
            labelStyle: TextStyle(color: CustomColors.mfinButtonGreen),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  collectionDays.add(int.parse(days.key));
                } else {
                  collectionDays.remove(int.parse(days.key));
                }
              });
            }),
      );
    }
  }

  _submit() async {
    if (_textEditingController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          "Report's signature should not be empty!", 2));
      return;
    } else {
      accountPreferencesJSON['report_signature'] = _textEditingController.text;
    }

    if (intrestRateController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please Enter Interest Rate!", 2));
      return;
    } else {
      accountPreferencesJSON['interest_rate'] =
          double.parse(intrestRateController.text);
    }

    accountPreferencesJSON['collection_mode'] =
        int.parse(selectedCollectionModeID);
    accountPreferencesJSON['collection_days'] = collectionDays;
    accountPreferencesJSON['chit_enabled'] = chitEnabled;

    CustomDialogs.actionWaiting(context, "Updating Preferences!");
    if (isSelectedView[0]) {
      userPreferencesJSON['enable_table_view'] = true;
    } else {
      userPreferencesJSON['enable_table_view'] = false;
    }

    userPreferencesJSON['support_language'] = _selectedLang;

    UserController _uc = UserController();
    var result = await _uc.updateTransactionSettings(
        userPreferencesJSON, accountPreferencesJSON);
    if (!result['is_success']) {
      Navigator.pop(context);
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
          "Preferences updated successfully", 2));
      Navigator.pop(context);
    }
  }
}
