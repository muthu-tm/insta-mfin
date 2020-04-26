import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';

class EditPrimaryFinance extends StatefulWidget {
  EditPrimaryFinance(this.userID);

  final String userID;

  @override
  _EditPrimaryFinanceState createState() => _EditPrimaryFinanceState();
}

class _EditPrimaryFinanceState extends State<EditPrimaryFinance> {
  final FocusNode myFocusNode = FocusNode();
  FinanceController financeController = new FinanceController();
  Map<String, String> _finances = {"0": "Choose your Finance"};
  Map<String, String> _branches = {"0": "Choose your Branch"};
  Map<String, String> _subBranches = {"0": "Choose your subBranch"};

  String _selectedFinance = "Choose your Finance";
  String _selectedBranch = "Choose your Branch";
  String _selectedSubBranch = "Choose your subBranch";

  @override
  void initState() {
    financeController.getFinanceByUserID(widget.userID).then((data) {
      data.forEach((fin) {
        _finances[fin.getID()] = fin.financeName;
      });
    });
    super.initState();
  }

  // List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
  //   List<DropdownMenuItem<Company>> items = List();
  //   for (Company company in companies) {
  //     items.add(
  //       DropdownMenuItem(
  //         value: company,
  //         child: Text(company.name),
  //       ),
  //     );
  //   }
  //   return items;
  // }

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
                  title: DropdownButton<String>(
                    isExpanded: true,
                    items: _finances.entries.map((f) {
                      return DropdownMenuItem<String>(
                        value: f.key,
                        child: Text(f.value),
                      );
                    }).toList(),
                    onChanged: onFinanceDropdownItem,
                    value: _selectedFinance,
                  ),
                ),
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
                  title: DropdownButton<String>(
                    isExpanded: true,
                    items: _branches.entries.map((f) {
                      return DropdownMenuItem<String>(
                        value: f.key,
                        child: Text(f.value),
                      );
                    }).toList(),
                    onChanged: onBranchDropdownItem,
                    value: _selectedBranch,
                  ),
                ),
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
                  title: DropdownButton<String>(
                    isExpanded: true,
                    items: _subBranches.entries.map((f) {
                      return DropdownMenuItem<String>(
                        value: f.key,
                        child: Text(f.value),
                      );
                    }).toList(),
                    onChanged: onSubBranchDropdownItem,
                    value: _selectedSubBranch,
                  ),
                ),
                new Card(
                  child: new Container(
                    color: CustomColors.mfinBlue,
                    padding: EdgeInsets.all(10),
                    child: new Text(
                      "The selected Finance/Branch/Sub Branch will be set as Primary. And you will be permitted to perform actions only with the selected group",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: CustomColors.mfinButtonGreen, fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(() {}, () {}),
    );
  }

  onFinanceDropdownItem(String financeID) async {
    BranchController _branchController = BranchController();

    List<Branch> branches =
        await _branchController.getBranchByUserID(financeID, widget.userID);
    Map<String, String> branchList = Map();
    if (branches.length > 0) {
      branches.forEach((b) {
        branchList[b.branchName] = b.branchName;
      });

      setState(() {
        _selectedFinance = financeID;
        _branches = _branches..addAll(branchList);
      });
    } else {
      setState(() {
        _selectedFinance = financeID;
      });
    }
  }

  onBranchDropdownItem(String branchName) async {
    SubBranchController _subBranchController = SubBranchController();

    List<SubBranch> subBranches = await _subBranchController
        .getSubBranchesForUserID(_selectedFinance, branchName, widget.userID);
    Map<String, String> subBranchList = Map();
    if (subBranches.length > 0) {
      subBranches.forEach((b) {
        subBranchList[b.subBranchName] = b.subBranchName;
      });

      setState(() {
        _selectedBranch = branchName;
        _subBranches = _subBranches..addAll(subBranchList);
      });
    } else {
      setState(() {
        _selectedBranch = branchName;
      });
    }
  }

  onSubBranchDropdownItem(String subBranchName) async {
    setState(() {
      _selectedSubBranch = subBranchName;
    });
  }
}
