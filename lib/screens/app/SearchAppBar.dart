import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/app/SearchOptionsRadio.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListTile.dart';
import 'package:instamfin/screens/customer/widgets/CustomerPaymentWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomRadioModel.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _searchController = TextEditingController();
  int searchMode = 0;
  String searchKey = "";
  Future<List<Map<String, dynamic>>> snapshot;

  List<CustomRadioModel> inOutList = List<CustomRadioModel>();

  @override
  void initState() {
    super.initState();
    inOutList.add(CustomRadioModel(true, 'Number', ''));
    inOutList.add(CustomRadioModel(false, 'Name', ''));
    inOutList.add(CustomRadioModel(false, 'Payment', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: CustomColors.mfinBlue,
        centerTitle: true,
        titleSpacing: 0.0,
        title: TextFormField(
          controller: _searchController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: CustomColors.mfinWhite,
          ),
          decoration: InputDecoration(
            hintText: searchMode == 0
                ? "Type Customer Number here..."
                : searchMode == 1
                    ? "Customer First Name here..."
                    : "Type Payment ID here...",
            hintStyle: TextStyle(color: CustomColors.mfinWhite),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30.0,
              color: CustomColors.mfinWhite,
            ),
            onPressed: () {
              if (_searchController.text.isEmpty ||
                  _searchController.text.trim().length < 2) {
                _scaffoldKey.currentState.showSnackBar(
                    CustomSnackBar.errorSnackBar(
                        'Please enter minimum 2 key to search..', 2));
                return null;
              } else {
                int minNumber = 0;
                int maxNumber = 0;
                String startKey = "";
                String endKey = "";

                if (searchMode == 0) {
                  int number = int.tryParse(_searchController.text.trim());
                  if (number == null) {
                    _scaffoldKey.currentState.showSnackBar(
                        CustomSnackBar.errorSnackBar(
                            "Invalid Mobile number, Please try again!", 2));
                    return null;
                  } else {
                    if (_searchController.text.trim().length < 10) {
                      minNumber = int.parse(
                          _searchController.text.trim().padRight(10, '0'));
                      maxNumber = int.parse(
                          _searchController.text.trim().padRight(10, '9'));
                    } else if (_searchController.text.trim().length == 10) {
                      minNumber = int.parse(_searchController.text.trim());
                      maxNumber = int.parse(_searchController.text.trim());
                    }
                  }
                } else if (searchMode == 1) {
                  searchKey = _searchController.text.trim();
                  if (_searchController.text.trim().length < 10) {
                    startKey = _searchController.text.trim();
                    endKey = _searchController.text.trim().padRight(10, 'z');
                  } else {
                    startKey = _searchController.text.trim();
                    endKey = _searchController.text.trim();
                  }
                } else {
                  searchKey = _searchController.text.trim();
                }

                setState(
                  () {
                    searchMode == 0
                        ? snapshot = Customer().getByRange(minNumber, maxNumber)
                        : searchMode == 1
                            ? snapshot = Customer()
                                .getByNameRange(searchKey, startKey, endKey)
                            : snapshot =
                                Payment().getByPaymentIDRange(searchKey);
                  },
                );

                return null;
              }
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinAlertRed.withOpacity(0.7),
        tooltip: "Clear Results",
        onPressed: () {
          setState(() {
            searchKey = "";
            _searchController.text = "";
          });
        },
        elevation: 5.0,
        icon: Icon(
          Icons.remove_circle,
          size: 40,
          color: CustomColors.mfinWhite,
        ),
        label: Text("Clear"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              leading: InkWell(
                onTap: () {
                  searchMode = 0;
                  _searchController.text = '';

                  setState(
                    () {
                      inOutList[0].isSelected = true;
                      inOutList[1].isSelected = false;
                      inOutList[2].isSelected = false;
                    },
                  );
                },
                child: SearchOptionsRadio(
                    inOutList[0], CustomColors.mfinLightBlue),
              ),
              title: InkWell(
                onTap: () {
                  searchMode = 1;
                  _searchController.text = '';

                  setState(
                    () {
                      inOutList[0].isSelected = false;
                      inOutList[1].isSelected = true;
                      inOutList[2].isSelected = false;
                    },
                  );
                },
                child: SearchOptionsRadio(inOutList[1], CustomColors.mfinBlue),
              ),
              trailing: InkWell(
                onTap: () {
                  searchMode = 2;
                  _searchController.text = '';

                  setState(
                    () {
                      inOutList[0].isSelected = false;
                      inOutList[1].isSelected = false;
                      inOutList[2].isSelected = true;
                    },
                  );
                },
                child:
                    SearchOptionsRadio(inOutList[2], CustomColors.mfinAlertRed),
              ),
            ),
            Divider(),
            FutureBuilder(
              future: snapshot,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    _searchController.text != '') {
                  if (snapshot.data.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (inOutList[2].isSelected == true) {
                          return customerPaymentWidget(context, _scaffoldKey,
                              index, Payment.fromJson(snapshot.data[index]));
                        } else {
                          return customerListTile(context, index,
                              Customer.fromJson(snapshot.data[index]));
                        }
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          inOutList[2].isSelected == true
                              ? "No Payment found!"
                              : "No Cusomters Found!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.mfinAlertRed,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        Text(
                          "Please try with different Search Key!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.mfinBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: AsyncWidgets.asyncError(),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: AsyncWidgets.asyncWaiting(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
