import 'package:flutter/material.dart';
import 'package:instamfin/db/models/expense_category.dart';
import 'package:instamfin/db/models/expense.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/expense_controller.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';
import 'package:instamfin/app_localizations.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class EditExpense extends StatefulWidget {
  EditExpense(this.expense);

  final Expense expense;

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedCategory = "0";
  Map<String, String> _categoriesMap = {"0": "Choose Category"};
  List<ExpenseCategory> categoryList;

  Map<String, dynamic> updatedExpense = new Map();

  @override
  void initState() {
    super.initState();
    this.getCategoryData();

    _date.text = DateUtils.formatDate(
        DateTime.fromMillisecondsSinceEpoch(widget.expense.expenseDate));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        title: Text('Edit - ${widget.expense.expenseName}'),
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
                    AppLocalizations.of(context).translate("name"),
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
                  initialValue: widget.expense.expenseName,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context).translate("expense_name"),
                    labelStyle: TextStyle(
                      color: CustomColors.mfinBlue,
                    ),
                    fillColor: CustomColors.mfinLightGrey,
                    filled: true,
                  ),
                  validator: (name) {
                    if (name.trim().isEmpty) {
                      return "Name should not be empty";
                    } else if (name.trim() != widget.expense.expenseName) {
                      updatedExpense['expense_name'] = name.trim();
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
                  initialValue: widget.expense.amount.toString(),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate("expense_amount"),
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
                        widget.expense.amount.toString()) {
                      updatedExpense['amount'] = int.parse(amount.trim());
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
                        hintText:
                            AppLocalizations.of(context).translate("spend_on"),
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
                    AppLocalizations.of(context).translate("category"),
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
                    AppLocalizations.of(context).translate("notes"),
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
                  initialValue: widget.expense.notes,
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
                  validator: (notes) {
                    if (notes.trim() != widget.expense.notes) {
                      updatedExpense['notes'] = notes.trim();
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
      List<ExpenseCategory> categories = await _cc.getAllExpenseCategory(
          cachedLocalUser.primary.financeID,
          cachedLocalUser.primary.branchName,
          cachedLocalUser.primary.subBranchName);
      for (int index = 0; index < categories.length; index++) {
        _categoriesMap[(index + 1).toString()] = categories[index].categoryName;
        if (widget.expense.category != null &&
            categories[index].createdAt == widget.expense.category.createdAt) {
          _selectedCategory = (index + 1).toString();
        }
      }
      setState(() {
        categoryList = categories;
      });
    } catch (err) {
      print("Unable to load miscellaneous categories for EDIT!");
    }
  }

  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.fromMillisecondsSinceEpoch(widget.expense.expenseDate),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        picked !=
            DateTime.fromMillisecondsSinceEpoch(widget.expense.expenseDate))
      setState(
        () {
          updatedExpense['expense_date'] = DateUtils.getUTCDateEpoch(picked);
          _date.text = DateUtils.formatDate(picked);
        },
      );
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (categoryList != null && _selectedCategory != "0") {
        ExpenseCategory _cat = categoryList[int.parse(_selectedCategory) - 1];
        if (widget.expense.category == null ||
            _cat.createdAt != widget.expense.category.createdAt) {
          updatedExpense['category'] = _cat.toJson();
        }
      }

      if (updatedExpense.length == 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No changes detected, Skipping update!", 1));
        Navigator.pop(context);
      } else {
        CustomDialogs.actionWaiting(context, "Updating Expense!");
        var result = await ExpenseController()
            .updateExpense(widget.expense, updatedExpense);
        if (!result['is_success']) {
          Navigator.pop(context);
          _scaffoldKey.currentState
              .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
