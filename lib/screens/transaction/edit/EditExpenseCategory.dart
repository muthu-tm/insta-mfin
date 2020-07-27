import 'package:flutter/material.dart';
import 'package:instamfin/db/models/expense_category.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';
import 'package:instamfin/app_localizations.dart';

class EditExpenseCategory extends StatefulWidget {
  EditExpenseCategory(this.mCategory);

  final ExpenseCategory mCategory;
  @override
  _EditExpenseCategoryState createState() =>
      _EditExpenseCategoryState();
}

class _EditExpenseCategoryState extends State<EditExpenseCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> updatedMC = new Map();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        title: Text('Edit Expense Category'),
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
                  width: 65,
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
                  initialValue: widget.mCategory.categoryName,
                  decoration: InputDecoration(
                    hintText: "Category Name",
                    labelStyle: TextStyle(
                      color: CustomColors.mfinBlue,
                    ),
                    fillColor: CustomColors.mfinLightGrey,
                    filled: true,
                  ),
                  validator: (name) {
                    if (name.trim().isEmpty) {
                      return "Name should not be empty";
                    } else if (name.trim() != widget.mCategory.categoryName) {
                      updatedMC['category_name'] = name.trim();
                    }
                    return null;
                  },
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 65,
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
                  initialValue: widget.mCategory.notes,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate("short_note_about_category"),
                    labelStyle: TextStyle(
                      color: CustomColors.mfinBlue,
                    ),
                    fillColor: CustomColors.mfinLightGrey,
                    filled: true,
                  ),
                  validator: (notes) {
                    if (notes.trim() != widget.mCategory.notes) {
                      updatedMC['notes'] = notes.trim();
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

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (updatedMC.length == 0) {
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "No changes detected, Skipping update!", 1));
        print("No changes detected, Skipping update!");
        Navigator.pop(context);
      } else {
        CustomDialogs.actionWaiting(context, "Updating Category!");
        CategoryController _cc = CategoryController();
        var result = await _cc.updateExpenseCategory(
            widget.mCategory.financeID,
            widget.mCategory.branchName,
            widget.mCategory.subBranchName,
            widget.mCategory.createdAt,
            updatedMC);
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
