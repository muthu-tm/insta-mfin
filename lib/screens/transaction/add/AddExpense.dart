import 'package:flutter/material.dart';
import 'package:instamfin/db/models/expense_category.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/expense_controller.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  String _selectedCategory = "0";
  Map<String, String> _categoriesMap = {"0": "Choose Category"};
  List<ExpenseCategory> categoryList;

  DateTime selectedDate = DateTime.now();
  String name = "";
  String notes = "";
  int amount = 0;

  TextEditingController _date = new TextEditingController();

  @override
  void initState() {
    super.initState();
    this.getCategoryData();

    _date.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('new_expense')),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () async {
          _submit();
        },
        label: Text(
          AppLocalizations.of(context).translate('save'),
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
            color: CustomColors.mfinWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: SizedBox(
                    width: 80,
                    child: Text(
                      AppLocalizations.of(context).translate('name'),
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
                      hintText: AppLocalizations.of(context)
                          .translate('expense_name'),
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
                      AppLocalizations.of(context).translate('amount'),
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    ),
                  ),
                  title: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('expense_amount'),
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
                      "Date",
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
                          hintText: AppLocalizations.of(context)
                              .translate('spent_on'),
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
                      AppLocalizations.of(context).translate('category'),
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
                      AppLocalizations.of(context).translate('notes'),
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
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate("short_notes_about_expense"),
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
      List<ExpenseCategory> categories = await _cc.getAllExpenseCategory(
          _user.primary.financeID,
          _user.primary.branchName,
          _user.primary.subBranchName);
      for (int index = 0; index < categories.length; index++) {
        _categoriesMap[(index + 1).toString()] = categories[index].categoryName;
      }
      setState(() {
        categoryList = categories;
      });
    } catch (err) {
      print("Unable to load Expense categories for ADD!");
    }
  }

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
          _date.text = DateUtils.formatDate(picked);
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Adding Expense!");
      ExpenseController _ec = ExpenseController();
      ExpenseCategory _category;
      if (categoryList != null && _selectedCategory != "0") {
        _category = categoryList[int.parse(_selectedCategory) - 1];
      }
      var result = await _ec.createNewExpense(name, amount, _category,
          DateUtils.getUTCDateEpoch(selectedDate), notes);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          AppLocalizations.of(context).translate("required_fields"), 2));
    }
  }
}
