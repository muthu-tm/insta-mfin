import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/chit/chit_template_controller.dart';
import 'package:instamfin/app_localizations.dart';

class EditChitTemplate extends StatefulWidget {
  EditChitTemplate(this.temp);

  final ChitTemplate temp;
  @override
  _EditChitTemplateState createState() => _EditChitTemplateState();
}

class _EditChitTemplateState extends State<EditChitTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController commController = TextEditingController();
  TextEditingController chitAmountController = TextEditingController();

  Map<String, dynamic> updatedTempJSON = {};

  String chitType = 'Custom';
  List<String> chitTypes = ['Custom', 'Fixed'];
  int tenure;

  List<TextEditingController> dateController = <TextEditingController>[];
  List<TextEditingController> collAmountController = <TextEditingController>[];
  List<TextEditingController> totalAmountController = <TextEditingController>[];
  List<TextEditingController> allocAmountController = <TextEditingController>[];
  List<TextEditingController> profitAmountController =
      <TextEditingController>[];

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

  List<int> cAmount = [];
  List<int> tAmount = [];
  List<int> aAmount = [];
  List<int> pAmount = [];

  @override
  void initState() {
    super.initState();

    this.chitType = widget.temp.type;
    chitAmountController.text = widget.temp.chitAmount.toString();
    commController.text = widget.temp.interestRate.toString();
    this.tenure = widget.temp.tenure;
    this.collectionDay = widget.temp.collectionDay;
    this.updatedTempJSON = widget.temp.toJson();
    setCollectionValues(widget.temp.fundDetails);
  }

  setCollectionValues(List<ChitFundDetails> fundDetails) {
    for (int i = 0; i < fundDetails.length; i++) {
      ChitFundDetails fd = fundDetails[i];
      TextEditingController _ca = TextEditingController();
      _ca.text = fd.collectionAmount.toString();
      collAmountController.insert(i, _ca);
      TextEditingController _ta = TextEditingController();
      _ta.text = fd.totalAmount.toString();
      totalAmountController.insert(i, _ta);
      TextEditingController _aa = TextEditingController();
      _aa.text = fd.allocationAmount.toString();
      allocAmountController.insert(i, _aa);
      TextEditingController _pa = TextEditingController();
      _pa.text = fd.profit.toString();
      profitAmountController.insert(i, _pa);
    }
  }

  initCollectionValues(int tenure) {
    collAmountController.clear();
    totalAmountController.clear();
    allocAmountController.clear();
    for (int i = 0; i < tenure; i++) {
      TextEditingController _ca = TextEditingController();
      _ca.text = "";
      collAmountController.insert(i, _ca);
      TextEditingController _ta = TextEditingController();
      _ta.text = "";
      totalAmountController.insert(i, _ta);
      TextEditingController _aa = TextEditingController();
      _aa.text = "";
      allocAmountController.insert(i, _aa);
      TextEditingController _pa = TextEditingController();
      _pa.text = "";
      profitAmountController.insert(i, _pa);
    }
  }

  setProfit(int amount) {
    for (var item in profitAmountController) {
      item.text = amount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Chit Template'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
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
                        AppLocalizations.of(context).translate("child_template"),
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: widget.temp.name,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate("template_name"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                                updatedTempJSON['template_name'] = name.trim();
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: chitAmountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Chit amount',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                              onChanged: (String val) {
                                double cRate = 0.00;
                                if (commController.text.isNotEmpty)
                                  cRate = double.parse(commController.text);
                                int cAmount = int.parse(val);
                                int profit = ((cAmount / 100) * cRate).round();
                                setState(() {
                                  setProfit(profit);
                                });
                              },
                              validator: (amount) {
                                if (amount.trim().isNotEmpty) {
                                  updatedTempJSON['chit_amount'] =
                                      int.parse(amount);
                                  return null;
                                } else {
                                  return "Fill the Chit Amount";
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Flexible(
                            child: TextFormField(
                              controller: commController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Commission %',
                                hintText: 'Commission Rate - %',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                              onChanged: (String val) {
                                double cRate = double.parse(val);
                                int cAmount =
                                    int.parse(chitAmountController.text);
                                int profit = ((cAmount / 100) * cRate).round();
                                setState(() {
                                  setProfit(profit);
                                });
                              },
                              validator: (cRate) {
                                if (cRate.trim().isNotEmpty) {
                                  updatedTempJSON['interest_rate'] =
                                      double.parse(cRate);
                                } else {
                                  updatedTempJSON['interest_rate'] = 0.00;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Chit Type',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue: widget.temp.tenure.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Months',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                                int cAmount =
                                    int.parse(chitAmountController.text);
                                double cRate =
                                    double.parse(commController.text);
                                int profit = ((cAmount / 100) * cRate).round();

                                this.tenure = int.parse(val);
                                initCollectionValues(int.parse(val));

                                setState(() {
                                  setProfit(profit);
                                });
                              },
                              validator: (tenure) {
                                if (tenure.trim().isNotEmpty &&
                                    tenure.trim() != '0') {
                                  this.tenure = int.parse(tenure);
                                  updatedTempJSON['tenure'] = this.tenure;
                                  return null;
                                } else {
                                  return 'Enter the Total Months of the Chit';
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Flexible(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Collection Day',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              initialValue: widget.temp.notes,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Notes',
                                labelText: 'Notes',
                                labelStyle: TextStyle(
                                  fontSize: 10,
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
                                  updatedTempJSON['notes'] = "";
                                } else {
                                  updatedTempJSON['notes'] = notes.trim();
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
                                      Text(
                                        "Chit Number ${index + 1}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Georgia",
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.mfinBlue,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                controller:
                                                    collAmountController[index],
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText:
                                                    AppLocalizations.of(context).translate("collection_amount"),
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    fontSize: 10,
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
                                                onChanged: (String val) {
                                                  int cAmount = int.parse(val);
                                                  int tAmount =
                                                      cAmount * tenure;
                                                  int profit = int.parse(
                                                      profitAmountController[
                                                              index]
                                                          .text);
                                                  setState(() {
                                                    totalAmountController[index]
                                                            .text =
                                                        tAmount.toString();
                                                    allocAmountController[index]
                                                            .text =
                                                        (tAmount - profit)
                                                            .toString();
                                                  });
                                                },
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
                                                controller:
                                                    totalAmountController[
                                                        index],
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText: 'Total Amount',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    fontSize: 10,
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
                                                onChanged: (String val) {
                                                  int tAmount = int.parse(val);
                                                  int profit = int.parse(
                                                      profitAmountController[
                                                              index]
                                                          .text);
                                                  setState(() {
                                                    allocAmountController[index]
                                                            .text =
                                                        (tAmount - profit)
                                                            .toString();
                                                  });
                                                },
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
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                controller:
                                                    allocAmountController[
                                                        index],
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      AppLocalizations.of(context).translate("allocation_amount"),
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    fontSize: 10,
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
                                                onChanged: (String val) {
                                                  int aAmount = int.parse(val);
                                                  int tAmount = int.parse(
                                                      totalAmountController[
                                                              index]
                                                          .text);
                                                  setState(() {
                                                    profitAmountController[
                                                                index]
                                                            .text =
                                                        (tAmount - aAmount)
                                                            .toString();
                                                  });
                                                },
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
                                                controller:
                                                    profitAmountController[
                                                        index],
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  labelText: AppLocalizations.of(context).translate("profit_amount"),
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelStyle: TextStyle(
                                                    fontSize: 10,
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
                                                onChanged: (String val) {
                                                  int tAmount = int.parse(
                                                      totalAmountController[
                                                              index]
                                                          .text);
                                                  int profit = int.parse(val);
                                                  setState(() {
                                                    allocAmountController[index]
                                                            .text =
                                                        (tAmount - profit)
                                                            .toString();
                                                  });
                                                },
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
                            },
                          )
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

  void _setSelectedCollectionDay(int newVal) {
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
      CustomDialogs.actionWaiting(context, "Updating Template!");
      ChitTemplateController _chitTemp = ChitTemplateController();
      List<ChitFundDetails> _fundDetails = [];
      for (var i = 0; i < tenure; i++) {
        ChitFundDetails fDetails = ChitFundDetails();
        fDetails.allocationAmount = aAmount[i];
        fDetails.profit = pAmount[i];
        fDetails.totalAmount = tAmount[i];
        fDetails.collectionAmount = cAmount[i];

        fDetails.chitNumber = i + 1;
        _fundDetails.insert(i, fDetails);
      }

      updatedTempJSON['collection_day'] = collectionDay;
      updatedTempJSON['type'] = chitType;
      updatedTempJSON['fund_details'] =
          _fundDetails?.map((e) => e?.toJson())?.toList();
      var result = await _chitTemp.updateTemp(
          widget.temp.getDocumentID(), updatedTempJSON);

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
