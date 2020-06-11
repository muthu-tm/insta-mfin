import 'package:flutter/material.dart';
import 'package:instamfin/db/models/journal_category.dart';
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

class AddJournal extends StatefulWidget {
  @override
  _AddJournalState createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  String _selectedCategory = "0";
  Map<String, String> _categoriesMap = {"0": "Choose Category"};
  List<CustomRadioModel> inOutList = new List<CustomRadioModel>();
  List<JournalCategory> categoryList;

  DateTime selectedDate = DateTime.now();
  String name = "";
  String notes = "";
  int amount = 0;
  bool isExpense = false;

  @override
  void initState() {
    super.initState();
    this.getCategoryData();
    inOutList.add(new CustomRadioModel(true, 'Income', ''));
    inOutList.add(new CustomRadioModel(false, 'Expense', ''));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
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
      setState(() {
        categoryList = categories;
      });
    } catch (err) {
      print("Unable to load Journal categories for ADD!");
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
      JournalCategory _category;
      if (categoryList != null && _selectedCategory != "0") {
        _category = categoryList[int.parse(_selectedCategory) - 1];
      }

      var result = await _jc.createNewJournal(name, amount, _category,
          isExpense, DateUtils.getUTCDateEpoch(selectedDate), notes);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
