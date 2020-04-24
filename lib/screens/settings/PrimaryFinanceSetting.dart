import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'MFIN1'),
      Company(2, 'MFIN2'),
      Company(3, 'MFIN3'),
      Company(4, 'MFIN4'),
      Company(5, 'MFIN5'),
    ];
  }
}

class PrimaryFinanceSetting extends StatefulWidget {
  
  @override
  _PrimaryFinanceSettingState createState() => _PrimaryFinanceSettingState();
}

class _PrimaryFinanceSettingState extends State<PrimaryFinanceSetting> {
  bool branchStatus = false;
  final FocusNode myFocusNode = FocusNode();
  FinanceController financeController = new FinanceController();
  bool subBranchStatus = false;
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CustomColors.mfinLightGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Primary Finance'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.30,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_balance,
                      color: CustomColors.mfinBlue,
                      size: 35.0,
                    ),
                    title: new Text(
                      "Finance",
                      style: TextStyle(color: CustomColors.mfinGrey),
                    ),
                  ),
                  ListTile(
                      leading: new Text(""),
                      title: DropdownButton(
                        isExpanded: true,
                        value: _selectedCompany,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                      )),
                  ListTile(
                    leading: Icon(
                      Icons.view_stream,
                      color: CustomColors.mfinBlue,
                      size: 35.0,
                    ),
                    title: new Text(
                      "Branch",
                      style: TextStyle(color: CustomColors.mfinGrey),
                    ),
                  ),
                  ListTile(
                      leading: new Text(""),
                      title: DropdownButton(
                        isExpanded: true,
                        value: _selectedCompany,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                      )),
                  ListTile(
                    leading: Icon(
                      Icons.menu,
                      color: CustomColors.mfinBlue,
                      size: 35.0,
                    ),
                    title: new Text(
                      "Sub Branch",
                      style: TextStyle(color: CustomColors.mfinGrey),
                    ),
                  ),
                  ListTile(
                      leading: new Text(""),
                      title: DropdownButton(
                        isExpanded: true,
                        value: _selectedCompany,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                      )),
                  new Card(
                    child: new Container(
                      color: CustomColors.mfinBlue,
                      padding: EdgeInsets.all(10),
                      child: new Text(
                        "The selected Finance/Branch/Sub Branch will be set as Primary. And you will be permitted to perform actions only with the selected group",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: CustomColors.mfinButtonGreen,
                            fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(() {}, () {}),
      bottomNavigationBar: bottomBar(context),
    );
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }
}
