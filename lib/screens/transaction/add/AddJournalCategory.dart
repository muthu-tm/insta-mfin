import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/category_controller.dart';

class AddJournalCategory extends StatefulWidget {
  @override
  _AddJournalCategoryState createState() => _AddJournalCategoryState();
}

class _AddJournalCategoryState extends State<AddJournalCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = "";
  String notes = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        title: Text('New Journal Category'),
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
                    } else {
                      this.name = name.trim();
                      return null;
                    }
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
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Short notes about this category",
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

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Creating Category!");
      CategoryController _cc = CategoryController();
      var result = await _cc.createJournalCategory(name, notes);
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
