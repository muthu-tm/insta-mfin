import 'package:flutter/material.dart';
import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AddJournalEntry extends StatefulWidget {
  @override
  _AddJournalEntryState createState() => _AddJournalEntryState();
}

class _AddJournalEntryState extends State<AddJournalEntry> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  String _selectedCategory = "0";
  Map<String, String> _categoriesMap = {"0": "Choose Category"};
  List<JournalCategory> categoryList;

  DateTime selectedDate = DateTime.now();
  String name = "";
  String notes = "";
  int amount = 0;

  @override
  void initState() {
    super.initState();
    this.getCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('New Journal Entry'),
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
        child: Container(
          color: CustomColors.mfinWhite,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                    } else {
                      this.name = name.trim();
                      return null;
                    }
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
                    } else {
                      this.amount = int.parse(amount.trim());
                      return null;
                    }
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
                  validator: (note) {
                    if (note.trim().isEmpty) {
                      this.notes = "";
                    } else {
                      this.notes = note.trim();
                    }

                    return null;
                  },
                ),
              ),
            ],
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
      }
      categoryList = categories;
    } catch (err) {
      print("Unable to load miscellaneous categories!");
    }
  }

  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(
        () {
          selectedDate = picked;
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Adding Journal!");
      JournalController _jc = JournalController();
      var result = await _jc.createNewJournal(
          name,
          amount,
          categoryList[int.parse(_selectedCategory) - 1],
          false,
          selectedDate,
          notes);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Create Journal Entry: " + result['message']);
      } else {
        print("New Journal Entry $name added successfully");
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      print("Invalid form submitted");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
