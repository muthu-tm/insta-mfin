import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/collection_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AddCollectionDetails extends StatefulWidget {
  AddCollectionDetails(this.collection, this.payCreatedAt);

  final Collection collection;
  final DateTime payCreatedAt;

  @override
  _AddCollectionDetailsState createState() => _AddCollectionDetailsState();
}

class _AddCollectionDetailsState extends State<AddCollectionDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = UserController().getCurrentUser();

  Map<String, dynamic> collDetails = new Map();

  DateTime selectedDate = DateTime.now();
  int totalAmount = 0;
  int status = 0;
  String collectedBy = '';
  String receivedFrom = '';
  String notes = '';
  String custName = '';

  @override
  void initState() {
    super.initState();
    this.getCustomrName(widget.collection.customerNumber);
    collectedBy = _user.name;
    totalAmount =
        widget.collection.collectionAmount - widget.collection.totalPaid;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Collection Details'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
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
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Card(
                color: CustomColors.mfinLightGrey,
                elevation: 5.0,
                margin: EdgeInsets.only(top: 5.0),
                shadowColor: CustomColors.mfinLightBlue,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Text(
                          widget.collection.collectionNumber.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                        title: Text(
                          DateUtils.formatDate(
                              widget.collection.collectionDate),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                        trailing: Text(
                          widget.collection.totalPaid.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinBlue,
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "CUSTOMER:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        enabled: false,
                        autofocus: false,
                        initialValue: custName,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          fillColor: CustomColors.mfinLightGrey,
                          filled: true,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
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
                              hintText: 'Collected On',
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 3.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
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
                        width: 100,
                        child: Text(
                          "RECEIVED FROM:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        initialValue: receivedFrom,
                        decoration: InputDecoration(
                          hintText: 'Amount Given To',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (receivedFrom) {
                          if (receivedFrom.trim().isEmpty) {
                            return "Fill the person name who Paid the amount";
                          }

                          collDetails['collected_from'] = receivedFrom.trim();
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "COLLECTED BY:",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        initialValue: collectedBy,
                        decoration: InputDecoration(
                          hintText: 'Amount Collected by',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (collectedBy) {
                          if (collectedBy.trim().isEmpty) {
                            return "Please fill the person name who collected the amount";
                          }

                          collDetails['collected_by'] = collectedBy.trim();
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
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
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        initialValue: notes,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Notes',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (notes) {
                          if (notes.trim().isEmpty) {
                            collDetails['notes'] = "";
                          } else {
                            collDetails['notes'] = notes.trim();
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getCustomrName(int number) async {
    try {
      Customer cust = await Customer().getByMobileNumber(number);
      setState(() {
        receivedFrom = cust.name;
      });
      custName = cust.name;
    } catch (err) {}
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
      CustomDialogs.actionWaiting(context, "Updating Collection");
      CollectionController _pc = CollectionController();
      var result = await _pc.updateCollectionDetails(
          widget.collection.financeID,
          widget.collection.branchName,
          widget.collection.subBranchName,
          widget.collection.customerNumber,
          widget.payCreatedAt,
          widget.collection.collectionDate,
          true,
          CollectionDetails.fromJson(collDetails));

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to Add Collection details: " + result['message']);
      } else {
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
