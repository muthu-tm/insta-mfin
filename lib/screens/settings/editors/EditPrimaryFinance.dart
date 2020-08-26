import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class EditPrimaryFinance extends StatefulWidget {
  @override
  _EditPrimaryFinanceState createState() => _EditPrimaryFinanceState();
}

class _EditPrimaryFinanceState extends State<EditPrimaryFinance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FinanceController financeController = FinanceController();
  Map<String, String> _finances = {"0": "Choose your Finance"};
  Map<String, String> _branches = {"0": "Choose your Branch"};
  Map<String, String> _subBranches = {"0": "Choose your subBranch"};

  String _selectedFinance = "0";
  String _selectedBranch = "0";
  String _selectedSubBranch = "0";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Finance>>(
      future: financeController.getFinanceByUserID(cachedLocalUser.getIntID()),
      builder: (BuildContext context, AsyncSnapshot<List<Finance>> snapshot) {
        Container container;
        if (snapshot.hasData) {
          snapshot.data.forEach(
            (fin) {
              _finances[fin.getID()] = fin.financeName;
            },
          );
          container = Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.account_balance,
                    color: CustomColors.mfinButtonGreen,
                    size: 35.0,
                  ),
                  title: new Text(
                    AppLocalizations.of(context).translate('finance'),
                    style: TextStyle(color: CustomColors.mfinGrey),
                  ),
                ),
                ListTile(
                  leading: Text(""),
                  title: DropdownButton<String>(
                    isExpanded: true,
                    items: _finances.entries.map(
                      (f) {
                        return DropdownMenuItem<String>(
                          value: f.key,
                          child: Text(f.value),
                        );
                      },
                    ).toList(),
                    onChanged: onFinanceDropdownItem,
                    value: _selectedFinance,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.view_stream,
                    color: CustomColors.mfinButtonGreen,
                    size: 35.0,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('branch'),
                    style: TextStyle(color: CustomColors.mfinGrey),
                  ),
                ),
                ListTile(
                  leading: Text(""),
                  title: DropdownButton<String>(
                    isExpanded: true,
                    items: _branches.entries.map(
                      (f) {
                        return DropdownMenuItem<String>(
                          value: f.key,
                          child: Text(f.value),
                        );
                      },
                    ).toList(),
                    onChanged: onBranchDropdownItem,
                    value: _selectedBranch,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.menu,
                    color: CustomColors.mfinButtonGreen,
                    size: 35.0,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('sub_branch'),
                    style: TextStyle(color: CustomColors.mfinGrey),
                  ),
                ),
                ListTile(
                  leading: Text(""),
                  title: DropdownButton<String>(
                    isExpanded: true,
                    items: _subBranches.entries.map(
                      (f) {
                        return DropdownMenuItem<String>(
                          value: f.key,
                          child: Text(f.value),
                        );
                      },
                    ).toList(),
                    onChanged: onSubBranchDropdownItem,
                    value: _selectedSubBranch,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CustomColors.mfinBlue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "IMPORTANT!\nThe selected Finance/Branch/SubBranch will be set as Primary. YOU will permitted to perform actions only on the selected GROUP!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: CustomColors.mfinButtonGreen,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 6,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          container = Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncError(),
              ),
            ),
          );
        } else {
          container = Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncWaiting(),
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: CustomColors.mfinLightGrey,
          appBar: AppBar(
            title: Text(
                AppLocalizations.of(context).translate('edit_primary_finance')),
            backgroundColor: CustomColors.mfinBlue,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: CustomColors.mfinBlue,
            onPressed: () {
              _submit();
            },
            label: Text(
              AppLocalizations.of(context).translate('save'),
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
          body: container,
        );
      },
    );
  }

  onFinanceDropdownItem(String financeID) async {
    BranchController _branchController = BranchController();

    List<Branch> branches = await _branchController.getBranchesForUserID(
        financeID, cachedLocalUser.getIntID());
    Map<String, String> branchList = Map();
    if (branches.length > 0) {
      branches.forEach(
        (b) {
          branchList[b.branchName] = b.branchName;
        },
      );

      setState(
        () {
          _selectedFinance = financeID;
          _branches = _branches..addAll(branchList);
        },
      );
    } else {
      setState(
        () {
          _selectedFinance = financeID;
        },
      );
    }
  }

  onBranchDropdownItem(String branchName) async {
    SubBranchController _subBranchController = SubBranchController();

    List<SubBranch> subBranches =
        await _subBranchController.getSubBranchesForUserID(
            _selectedFinance, branchName, cachedLocalUser.getIntID());
    Map<String, String> subBranchList = Map();
    if (subBranches.length > 0) {
      subBranches.forEach(
        (b) {
          subBranchList[b.subBranchName] = b.subBranchName;
        },
      );

      setState(
        () {
          _selectedBranch = branchName;
          _subBranches = _subBranches..addAll(subBranchList);
        },
      );
    } else {
      setState(
        () {
          _selectedBranch = branchName;
        },
      );
    }
  }

  onSubBranchDropdownItem(String subBranchName) async {
    setState(
      () {
        _selectedSubBranch = subBranchName;
      },
    );
  }

  _submit() async {
    if (_selectedFinance == "0") {
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("No Finance Selected!", 3));
    } else {
      CustomDialogs.actionWaiting(context, "Validating Details!");
      try {
        if (_selectedSubBranch != "0") {
          _updatePrimary(cachedLocalUser.getIntID(), _selectedFinance,
              _selectedBranch, _selectedSubBranch);
        } else if (_selectedBranch != "0") {
          BranchController _bc = BranchController();
          bool isAdmin = await _bc.isUserAdmin(
              _selectedFinance, _selectedBranch, cachedLocalUser.getIntID());
          if (!isAdmin) {
            Navigator.pop(context);
            _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
                "You cannot set $_selectedBranch as Primary; Because you are not an Admin of $_selectedBranch!",
                3));
          } else {
            _updatePrimary(cachedLocalUser.getIntID(), _selectedFinance,
                _selectedBranch, "");
          }
        } else {
          bool isAdmin = await financeController.isUserAdmin(
              _selectedFinance, cachedLocalUser.getIntID());
          if (!isAdmin) {
            Navigator.pop(context);
            _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
                "You cannot set $_selectedFinance as Primary; Because you are not an Admin of $_selectedFinance!",
                3));
          } else {
            _updatePrimary(
                cachedLocalUser.getIntID(), _selectedFinance, "", "");
          }
        }
      } catch (err) {
        print(err.toString());
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            "Something went wrong, sorry! Try again later.", 3));
      }
    }
  }

  _updatePrimary(int userID, String financeID, String branchName,
      String subBranchName) async {
    Navigator.pop(context);
    CustomDialogs.actionWaiting(context, "Updating..");
    UserController _uc = UserController();
    await _uc.updatePrimaryFinance(financeID, branchName, subBranchName);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => UserFinanceSetup(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
