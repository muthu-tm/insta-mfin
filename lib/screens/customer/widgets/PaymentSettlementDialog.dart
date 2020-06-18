import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';

class PaymentSettlementDialog extends StatefulWidget {
  PaymentSettlementDialog(
      this._scaffoldKey, this._p, this.pDetails);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Payment _p;
  final List<int> pDetails;

  @override
  _PaymentSettlementDialogState createState() =>
      _PaymentSettlementDialogState();
}

class _PaymentSettlementDialogState extends State<PaymentSettlementDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _date = new TextEditingController();

  int sAmount = 0;
  int settledDate = DateUtils.getUTCDateEpoch(DateTime.now());
  String notes = "";
  String rFrom = "";

  @override
  void initState() {
    super.initState();
    this.rFrom = widget._p.custName;
    _date.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Text(
                  "SETTLEMENT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CustomColors.mfinPositiveGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: CustomColors.mfinButtonGreen,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: widget._p.totalAmount.toString(),
                        decoration: InputDecoration(
                          labelText: 'Total Amount',
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinBlue),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: widget._p.principalAmount.toString(),
                        decoration: InputDecoration(
                          labelText: 'Amount Given',
                          labelStyle: TextStyle(
                            color: CustomColors.mfinBlue,
                          ),
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinBlue),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: widget.pDetails[0].toString(),
                        decoration: InputDecoration(
                          labelText: 'Total Received',
                          labelStyle: TextStyle(
                            color: CustomColors.mfinPositiveGreen,
                          ),
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinBlue),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: widget.pDetails[1].toString(),
                        decoration: InputDecoration(
                          labelText: 'Pending Amount',
                          labelStyle: TextStyle(
                            color: CustomColors.mfinAlertRed,
                          ),
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinBlue),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        "Total Remaining",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue:
                            (widget._p.totalAmount - widget.pDetails[0])
                                .toString(),
                        decoration: InputDecoration(
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinBlue),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: CustomColors.mfinButtonGreen,
              ),
              Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Settlement Amount",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Georgia",
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              initialValue:
                                  (widget._p.totalAmount - widget.pDetails[0])
                                      .toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: CustomColors.mfinBlue),
                                ),
                              ),
                              autofocus: false,
                              validator: (amount) {
                                if (int.tryParse(amount.trim()) == null) {
                                  return "Please enter valid settlement amount";
                                } else if (amount.trim() == "") {
                                  sAmount = 0;
                                } else {
                                  sAmount = int.parse(amount.trim());
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              initialValue: widget._p.custName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Received From",
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: CustomColors.mfinBlue),
                                ),
                              ),
                              autofocus: false,
                              validator: (rFrom) {
                                if (rFrom.trim() == "") {
                                  return "Received from should not be empty!";
                                }
                                rFrom = rFrom.trim();
                                return null;
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () => _selectDate(),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _date,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: 'Settlement On',
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
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            "Notes:",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinBlue,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              initialValue: "",
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 3.0),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: CustomColors.mfinBlue),
                                ),
                              ),
                              autofocus: false,
                              validator: (notes) {
                                if (notes.trim() == "") {
                                  notes = "";
                                } else {
                                  notes = notes.trim();
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 10.0,
                      shadowColor: CustomColors.mfinBlue,
                      color: CustomColors.mfinAlertRed,
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        splashColor: CustomColors.mfinWhite,
                        child: Container(
                          height: 40,
                          width: 150,
                          alignment: Alignment.center,
                          child: Text(
                            "CLOSE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinWhite,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 10.0,
                      shadowColor: CustomColors.mfinBlue,
                      color: CustomColors.mfinPositiveGreen,
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        splashColor: CustomColors.mfinWhite,
                        child: Container(
                          height: 40,
                          width: 150,
                          alignment: Alignment.center,
                          child: Text(
                            "SETTLEMENT",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinWhite,
                            ),
                          ),
                        ),
                        onTap: () async {
                          final FormState form = _formKey.currentState;

                          if (form.validate()) {
                            _submit();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() async {
    bool isLoss = false;
    int lossAmount = 0;
    int profitAmount = 0;
    if ((sAmount + widget.pDetails[0]) < widget._p.principalAmount) {
      isLoss = true;
      lossAmount = widget._p.principalAmount - (sAmount + widget.pDetails[0]);
      // _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
      //     "Total Received amount lesser than Principal Amount; Considering the pending amount $lossAmount as loss",
      //     2));
    } else {
      profitAmount = (sAmount + widget.pDetails[0]) - widget._p.principalAmount;
    }

    int shortageAmount = widget._p.totalAmount - (sAmount + widget.pDetails[0]);

    CustomDialogs.actionWaiting(context, "Updating Payment");
    PaymentController _pc = PaymentController();
    var result = await _pc.settlement(widget._p, {
      'settled_date': settledDate,
      'settlement_amount': sAmount,
      'received_from': rFrom,
      'notes': notes,
      'loss': isLoss,
      'loss_amount': lossAmount,
      'profit_amount': profitAmount,
      'shortage_amount': shortageAmount,
    });

    if (!result['is_success']) {
      Navigator.pop(context);
      Navigator.pop(context);
      widget._scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 3));
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(
        () {
          settledDate = DateUtils.getUTCDateEpoch(picked);
          _date.value = TextEditingValue(
            text: DateUtils.formatDate(picked),
          );
        },
      );
    }
  }
}
