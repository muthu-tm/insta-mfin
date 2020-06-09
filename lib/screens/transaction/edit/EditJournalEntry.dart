import 'package:flutter/material.dart';
import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/transaction/widgets/InOutCustomRadioButtons.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomRadioModel.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class EditJournalEntry extends StatefulWidget {
  EditJournalEntry(this.journal);

  final Journal journal;

  @override
  _EditJournalEntryState createState() => _EditJournalEntryState();
}

class _EditJournalEntryState extends State<EditJournalEntry> {
  final User _user = UserController().getCurrentUser();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedCategory = "0";
  Map<String, String> _categoriesMap = {"0": "Choose Category"};
  List<CustomRadioModel> inOutList = new List<CustomRadioModel>();
  List<JournalCategory> categoryList;

  Map<String, dynamic> updatedJournal = new Map();
  DateTime selectedDate = DateTime.now();

  bool isExpense;

  @override
  void initState() {
    super.initState();
    this.getCategoryData();
    isExpense = widget.journal.isExpense;
    inOutList
        .add(new CustomRadioModel(!widget.journal.isExpense, 'Income', ''));
    inOutList
        .add(new CustomRadioModel(widget.journal.isExpense, 'Expense', ''));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Journal - ${widget.journal.journalName}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            color: CustomColors.mfinWhite,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  leading: InkWell(
                    onTap: () {
                      setState(
                        () {
                          inOutList[0].isSelected = true;
                          inOutList[1].isSelected = false;
                        },
                      );
                      isExpense = false;
                    },
                    child: new InOutRadioItem(
                        inOutList[0], CustomColors.mfinLightBlue),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      setState(
                        () {
                          inOutList[0].isSelected = false;
                          inOutList[1].isSelected = true;
                        },
                      );
                      isExpense = true;
                    },
                    child: new InOutRadioItem(
                        inOutList[1], CustomColors.mfinAlertRed),
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 80,
                    child: Text(
                      "NAME:",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    ),
                  ),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.journal.journalName,
                    decoration: InputDecoration(
                      hintText: "Journal Entry Name",
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinLightGrey,
                      filled: true,
                    ),
                    validator: (name) {
                      if (name.trim().isEmpty) {
                        return "Name should not be empty";
                      } else if (name.trim() != widget.journal.journalName) {
                        updatedJournal['journal_name'] = name.trim();
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 80,
                    child: Text(
                      "AMOUNT:",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    ),
                  ),
                  title: new TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.journal.amount.toString(),
                    decoration: InputDecoration(
                      hintText: "Journal Amount",
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinLightGrey,
                      filled: true,
                    ),
                    validator: (amount) {
                      if (amount.trim().isEmpty) {
                        return "Amount should not be empty!";
                      } else if (amount.trim() !=
                          widget.journal.amount.toString()) {
                        updatedJournal['amount'] = int.parse(amount.trim());
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 80,
                    child: Text(
                      "DATE:",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _date,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: 'Adjustment on',
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          fillColor: CustomColors.mfinLightGrey,
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
                    width: 80,
                    child: Text(
                      "CATEGORY:",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    ),
                  ),
                  title: DropdownButton<String>(
                    dropdownColor: CustomColors.mfinLightGrey,
                    isExpanded: true,
                    items: _categoriesMap.entries.map(
                      (f) {
                        return DropdownMenuItem<String>(
                          value: f.key,
                          child: Text(f.value),
                        );
                      },
                    ).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _selectedCategory = newVal;
                      });
                    },
                    value: _selectedCategory,
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                    width: 80,
                    child: Text(
                      "NOTES:",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    ),
                  ),
                  title: new TextFormField(
                    initialValue: widget.journal.notes,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Reference notes about this adjustment",
                      labelStyle: TextStyle(
                        color: CustomColors.mfinBlue,
                      ),
                      fillColor: CustomColors.mfinLightGrey,
                      filled: true,
                    ),
                    validator: (notes) {
                      if (notes.trim() != widget.journal.notes) {
                        updatedJournal['notes'] = notes.trim();
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getCategoryData() async {
    try {
      CategoryController _cc = CategoryController();
      List<JournalCategory> categories = await _cc.getAllJournalCategory(
          _user.primaryFinance, _user.primaryBranch, _user.primarySubBranch);
      for (int index = 0; index < categories.length; index++) {
        _categoriesMap[(index + 1).toString()] = categories[index].categoryName;
        if (widget.journal.category != null &&
            categories[index].createdAt == widget.journal.category.createdAt) {
          _selectedCategory = (index + 1).toString();
        }
      }
      setState(() {
        categoryList = categories;
      });
    } catch (err) {
      print("Unable to load Journal categories for EDIT!");
    }
  }

  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(widget.journal.journalDate),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.fromMillisecondsSinceEpoch(widget.journal.journalDate))
      setState(
        () {
          updatedJournal['journal_date'] = DateUtils.getUTCDateEpoch(picked);
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (categoryList != null && _selectedCategory != "0") {
        JournalCategory _cat = categoryList[int.parse(_selectedCategory) - 1];
        if (widget.journal.category == null ||
            _cat.createdAt != widget.journal.category.createdAt) {
          updatedJournal['category'] = _cat.toJson();
        }
      }

      if (isExpense != widget.journal.isExpense) {
        updatedJournal['is_expense'] = isExpense;
      }

      if (updatedJournal.length == 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No changes detected, Skipping update!", 1));
        print("No changes detected, Skipping update!");
        Navigator.pop(context);
      } else {
        CustomDialogs.actionWaiting(context, "Updating Journal!");
        JournalController _jc = JournalController();

        var result =
            await _jc.updateJournal(widget.journal, updatedJournal);
        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
          print("Unable to Update Journal Entry: " + result['message']);
        } else {
          print(
              "Journal Entry ${widget.journal.journalName} updated successfully");
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
