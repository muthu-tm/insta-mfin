import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_customers.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/chit/chit_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

class AddChitCustomers extends StatefulWidget {
  AddChitCustomers(this.chit);

  final ChitFund chit;

  @override
  _AddChitCustomersState createState() => _AddChitCustomersState();
}

class _AddChitCustomersState extends State<AddChitCustomers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User user = UserController().getCurrentUser();

  List<Customer> _custList = [];
  List<ChitCustomers> customers = [];

  String mobileNumber = "";
  bool mobileNumberValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('add_customers'),
        ),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () {
          _submit();
        },
        label: Text(
          AppLocalizations.of(context).translate('publish_chit'),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5.0,
              color: CustomColors.mfinLightGrey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => mobileNumber = value,
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        hintText: AppLocalizations.of(context)
                            .translate("hint_customer_mobile"),
                        errorText: !mobileNumberValid
                            ? AppLocalizations.of(context)
                                .translate('valid_mobile_message')
                            : null,
                        suffixIcon: Icon(
                          Icons.search,
                          size: 35.0,
                          color: CustomColors.mfinBlue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FlatButton.icon(
                      color: CustomColors.mfinBlue,
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.search,
                          size: 30.0,
                          color: CustomColors.mfinButtonGreen,
                        ),
                      ),
                      label: Text(
                        AppLocalizations.of(context).translate('search'),
                        style: TextStyle(
                          color: CustomColors.mfinLightGrey,
                          fontSize: 16.0,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      onPressed: () => _onSearch()),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: <Widget>[
                    _custList.length > 0
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _custList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Customer _cust = _custList[index];

                              return Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: CustomColors.mfinBlue,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${_cust.firstName} ${_cust.lastName}',
                                      style: TextStyle(
                                        color: CustomColors.mfinLightGrey,
                                      ),
                                    ),
                                    subtitle: Text(
                                      _cust.mobileNumber.toString(),
                                      style: TextStyle(
                                        color: CustomColors.mfinLightGrey,
                                      ),
                                    ),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: ListTile(
                                        leading: IconButton(
                                          icon: Icon(Icons.remove_circle,
                                              color: CustomColors.mfinAlertRed),
                                          onPressed: () {
                                            if (customers[index].chits - 1 <
                                                0) {
                                              _scaffoldKey.currentState
                                                  .showSnackBar(CustomSnackBar
                                                      .errorSnackBar(
                                                          "Already customer ${customers[index].number} have 0 chits!",
                                                          2));
                                            } else {
                                              setState(() {
                                                customers[index].chits =
                                                    customers[index].chits - 1;
                                              });
                                            }
                                          },
                                        ),
                                        title: Text(
                                          ' ${customers[index].chits} ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: CustomColors.mfinWhite,
                                            fontSize: 16.0,
                                            fontFamily: 'Georgia',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.add_circle,
                                              color:
                                                  CustomColors.mfinButtonGreen),
                                          onPressed: () {
                                            if (isFilled()) {
                                              _scaffoldKey.currentState
                                                  .showSnackBar(CustomSnackBar
                                                      .errorSnackBar(
                                                          "Allocated all the ${widget.chit.tenure} chits already!",
                                                          2));
                                            } else {
                                              setState(() {
                                                customers[index].chits =
                                                    customers[index].chits + 1;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('no_users_selected'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CustomColors.mfinAlertRed,
                                fontSize: 16.0,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isFilled() {
    int total = 0;
    customers.forEach((cust) {
      total += cust.chits;
    });

    if (widget.chit.tenure == total) return true;

    return false;
  }

  _onSearch() async {
    bool isExist = false;
    customers.forEach((c) {
      if (c.number == int.parse(mobileNumber)) {
        isExist = true;
      }
    });

    if (isExist) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          "The customer $mobileNumber already in the list!", 2));
      return;
    }
    if (mobileNumber != null && mobileNumber.length == 10) {
      Customer _cust =
          await Customer().getByMobileNumber(int.parse(mobileNumber));
      if (_cust != null) {
        ChitCustomers _c = ChitCustomers();
        _c.chits = 1;
        _c.number = _cust.mobileNumber;
        setState(() {
          _custList.add(_cust);
          customers.add(_c);
          mobileNumberValid = true;
        });
      } else {
        setState(() {
          mobileNumberValid = true;
        });
        _scaffoldKey.currentState.showSnackBar(
            CustomSnackBar.errorSnackBar("Error, No Customers Found!", 2));
      }
    } else {
      setState(() {
        mobileNumberValid = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_custList.length == 0) {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("No Customers Selected!", 2));
    } else if (!isFilled()) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          "Not all chits allocated to customers!", 2));
    } else {
      CustomDialogs.actionWaiting(context, "Publishing Chit!");
      List<ChitCustomers> _chitCustList = [];
      List<int> customerNumbers = [];
      customers.forEach((c) {
        if (c.chits > 0) {
          _chitCustList.add(c);
          customerNumbers.add(c.number);
        }
      });

      widget.chit.customerDetails = _chitCustList;
      widget.chit.customers = customerNumbers;

      var result = await ChitController().create(widget.chit);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }
}
