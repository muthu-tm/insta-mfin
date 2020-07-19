import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:instamfin/screens/chit/ChitAddCustomers.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class PublishChitFund extends StatefulWidget {
  PublishChitFund(this.temp);

  final ChitTemplate temp;
  @override
  _PublishChitFundState createState() => _PublishChitFundState();
}

class _PublishChitFundState extends State<PublishChitFund> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = '';
  String chitID = '';
  double commission = 0.00;
  int amount = 0;
  int tenure = 10;
  String notes = "";
  String chitType = 'Custom';
  List<String> chitTypes = ['Custom', 'Fixed'];
  List<int> cAmount = [];
  List<int> tAmount = [];
  List<int> aAmount = [];
  List<int> pAmount = [];
  List<DateTime> chitDates = [];
  List<TextEditingController> dateController = <TextEditingController>[];

  List<ChitFundDetails> fundDetails = [];

  int collectionDay = 1;
  List<int> collectionDays = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28
  ];

  @override
  void initState() {
    super.initState();
    if (widget.temp != null) {
      amount = widget.temp.chitAmount;
      tenure = widget.temp.tenure;
      chitType = widget.temp.type;
      fundDetails = widget.temp.fundDetails;
      collectionDay = widget.temp.collectionDay;
    }

    setChitDates(collectionDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Publish Chit'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () {
          _submit();
        },
        label: Text(
          "Next",
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.keyboard_arrow_right,
          size: 35,
          color: CustomColors.mfinFadedButtonGreen,
        ),
        isExtended: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                color: CustomColors.mfinLightGrey,
                elevation: 5.0,
                margin: EdgeInsets.only(top: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        "Chit Template",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinBlue,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Chit name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (name) {
                                if (name.trim().isEmpty) {
                                  return 'Enter the Template Name';
                                }
                                this.name = name.trim();
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: amount.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Chit amount',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (amount) {
                                if (amount.trim().isNotEmpty) {
                                  this.amount = int.parse(amount);
                                  return null;
                                } else {
                                  return "Fill the Chit Amount";
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Chit Type',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              isExpanded: true,
                              items: chitTypes.map(
                                (f) {
                                  return DropdownMenuItem<String>(
                                    value: f,
                                    child: Text(f),
                                  );
                                },
                              ).toList(),
                              onChanged: (newVal) {
                                _setSelectedChitType(newVal);
                              },
                              value: chitType,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: chitID,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Chit ID',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (chitID) {
                                if (chitID.trim().isNotEmpty) {
                                  this.chitID = chitID;
                                  return null;
                                } else {
                                  return "Fill the Chit ID";
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: TextFormField(
                              initialValue: commission.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Commission Rate',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              validator: (cRate) {
                                if (cRate.trim().isNotEmpty) {
                                  this.commission = double.parse(cRate);
                                } else {
                                  this.commission = 0.00;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: tenure.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Months',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColors.mfinFadedButtonGreen,
                                  ),
                                ),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              onChanged: (String val) {
                                setState(() {
                                  this.tenure = int.parse(val);
                                });
                              },
                              validator: (tenure) {
                                if (tenure.trim().isNotEmpty &&
                                    tenure.trim() != '0') {
                                  this.tenure = int.parse(tenure);
                                  return null;
                                } else {
                                  return 'Enter the Total Months of the Chit';
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Flexible(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Collection Day',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            CustomColors.mfinFadedButtonGreen)),
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                              ),
                              isExpanded: true,
                              items: collectionDays.map(
                                (f) {
                                  return DropdownMenuItem<int>(
                                    value: f,
                                    child: Text(f.toString()),
                                  );
                                },
                              ).toList(),
                              onChanged: (newVal) {
                                _setSelectedCollectionDay(newVal);
                              },
                              value: collectionDay,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: notes,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Notes',
                                labelText: 'Notes',
                                labelStyle: TextStyle(
                                  color: CustomColors.mfinBlue,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.mfinWhite)),
                              ),
                              validator: (notes) {
                                if (notes.trim().isEmpty) {
                                  this.notes = "";
                                } else {
                                  this.notes = notes.trim();
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
              Card(
                child: Column(
                  children: <Widget>[
                    tenure > 0
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: tenure,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  color: CustomColors.mfinLightGrey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                initialValue: '${index + 1}',
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText: 'Chit Number',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColors.mfinBlue,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 3.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CustomColors
                                                          .mfinFadedButtonGreen,
                                                    ),
                                                  ),
                                                  fillColor:
                                                      CustomColors.mfinWhite,
                                                  filled: true,
                                                ),
                                                readOnly: true,
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(5)),
                                            Flexible(
                                              child: TextFormField(
                                                controller:
                                                    dateController[index],
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText: 'Chit Date',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColors.mfinBlue,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 3.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CustomColors
                                                          .mfinFadedButtonGreen,
                                                    ),
                                                  ),
                                                  fillColor:
                                                      CustomColors.mfinWhite,
                                                  filled: true,
                                                ),
                                                readOnly: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                initialValue:
                                                    (index < fundDetails.length)
                                                        ? fundDetails[index]
                                                            .collectionAmount
                                                            .toString()
                                                        : '',
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Collection Amount',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColors.mfinBlue,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 3.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CustomColors
                                                          .mfinFadedButtonGreen,
                                                    ),
                                                  ),
                                                  fillColor:
                                                      CustomColors.mfinWhite,
                                                  filled: true,
                                                ),
                                                validator: (amount) {
                                                  if (amount
                                                          .trim()
                                                          .isNotEmpty &&
                                                      amount.trim() != '0') {
                                                    cAmount.insert(
                                                        index,
                                                        int.parse(
                                                            amount.trim()));
                                                    return null;
                                                  } else {
                                                    return 'Enter the Collection Amount of the Chit';
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(5)),
                                            Flexible(
                                              child: TextFormField(
                                                initialValue:
                                                    (index < fundDetails.length)
                                                        ? fundDetails[index]
                                                            .totalAmount
                                                            .toString()
                                                        : '',
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText: 'Total Amount',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColors.mfinBlue,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 3.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CustomColors
                                                          .mfinFadedButtonGreen,
                                                    ),
                                                  ),
                                                  fillColor:
                                                      CustomColors.mfinWhite,
                                                  filled: true,
                                                ),
                                                validator: (amount) {
                                                  if (amount
                                                          .trim()
                                                          .isNotEmpty &&
                                                      amount.trim() != '0') {
                                                    tAmount.insert(
                                                        index,
                                                        int.parse(
                                                            amount.trim()));
                                                    return null;
                                                  } else {
                                                    return 'Enter the Total Amount of the Chit';
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                initialValue:
                                                    (index < fundDetails.length)
                                                        ? fundDetails[index]
                                                            .allocationAmount
                                                            .toString()
                                                        : '',
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Allocation Amount',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColors.mfinBlue,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 3.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CustomColors
                                                          .mfinFadedButtonGreen,
                                                    ),
                                                  ),
                                                  fillColor:
                                                      CustomColors.mfinWhite,
                                                  filled: true,
                                                ),
                                                validator: (amount) {
                                                  if (amount
                                                          .trim()
                                                          .isNotEmpty &&
                                                      amount.trim() != '0') {
                                                    aAmount.insert(
                                                        index,
                                                        int.parse(
                                                            amount.trim()));
                                                    return null;
                                                  } else {
                                                    return 'Enter the Allocation Amount of the Chit';
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(5)),
                                            Flexible(
                                              child: TextFormField(
                                                initialValue:
                                                    (index < fundDetails.length)
                                                        ? fundDetails[index]
                                                            .profit
                                                            .toString()
                                                        : '',
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText: 'Profit Amount',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColors.mfinBlue,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 3.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CustomColors
                                                          .mfinFadedButtonGreen,
                                                    ),
                                                  ),
                                                  fillColor:
                                                      CustomColors.mfinWhite,
                                                  filled: true,
                                                ),
                                                validator: (amount) {
                                                  if (amount
                                                      .trim()
                                                      .isNotEmpty) {
                                                    pAmount.insert(
                                                        index,
                                                        int.parse(
                                                            amount.trim()));
                                                    return null;
                                                  } else {
                                                    return 'Enter the Profit Amount of the Chit';
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Text("")
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(35))
            ],
          ),
        ),
      ),
    );
  }

  void setChitDates(int day) {
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(today.year, today.month, day);
    if (DateUtils.getUTCDateEpoch(startDate) <
        DateUtils.getUTCDateEpoch(today)) {
      startDate = DateTime(today.year, today.month + 1, day);
    }

    for (int i = 0; i < tenure; i++) {
      TextEditingController controller = TextEditingController();
      controller.text = DateUtils.formatDate(startDate);
      chitDates.insert(i, startDate);
      dateController.insert(i, controller);
      startDate = DateTime(startDate.year, startDate.month + 1, day);
    }
  }

  void _setSelectedCollectionDay(int newVal) {
    setChitDates(newVal);
    setState(() {
      collectionDay = newVal;
    });
  }

  void _setSelectedChitType(String newVal) {
    setState(() {
      chitType = newVal;
    });
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      ChitFund _chitFund = ChitFund();
      List<ChitFundDetails> _fundDetails = [];
      for (var i = 0; i < tenure; i++) {
        ChitFundDetails fDetails = ChitFundDetails();
        fDetails.totalAmount = tAmount[i];
        fDetails.allocationAmount = aAmount[i];
        fDetails.profit = pAmount[i];
        fDetails.collectionAmount = cAmount[i];
        fDetails.chitNumber = i + 1;
        fDetails.chitDate = DateUtils.getUTCDateEpoch(chitDates[i]);
        _fundDetails.insert(i, fDetails);
      }

      _chitFund.setChitName(name);
      _chitFund.setCollectionDate(collectionDay);
      _chitFund.setchitAmount(amount);
      _chitFund.setDatePublished(DateUtils.getUTCDateEpoch(DateTime.now()));
      _chitFund.setIsClosed(false);
      _chitFund.setNotes(notes);
      _chitFund.setTenure(tenure);
      _chitFund.setFundDetails(_fundDetails);
      _chitFund.setChitID(chitID);
      _chitFund.setInterestRate(commission);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddChitCustomers(_chitFund),
          settings: RouteSettings(name: '/chit/publish/customer'),
        ),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
