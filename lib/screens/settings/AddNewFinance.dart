import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';

class AddFinancePage extends StatefulWidget {
  
  @override
  _AddFinancePageState createState() => _AddFinancePageState();
}

class _AddFinancePageState extends State<AddFinancePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNode = FocusNode();

  DateTime selectedDate = DateTime.now();
  var dateFormatter = DateUtils.dateFormatter;
  String emailID;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Finance'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.16,
            color: CustomColors.mfinLightGrey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "Finance Name",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Branch Name',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter the Branch Name';
                      }
                    },
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "RegisterID",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Register ID',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter the Register ID';
                      }
                    },
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "Registered Date",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: new TextFormField(
                    controller: _date,
                    decoration: InputDecoration(
                      hintText: DateUtils.getCurrentFormattedDate(),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "Email",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter your EmailID',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: CustomColors.mfinWhite)),
                    ),
                    validator: (passkey) =>
                        FieldValidator.emailValidator(passkey, setEmailID),
                  ),
                ),
                AddressWidget("Office Address", new Address(), new Address()),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(() {}, () {}),
      bottomNavigationBar: bottomBar(context),
    );
  }

  setEmailID(String emailID) {
    setState(() {
      this.emailID = emailID;
    });
  }

  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(text: DateUtils.formatDate(picked));
      });
  }
}
