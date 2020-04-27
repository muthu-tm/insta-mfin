import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AddAdminPage extends StatefulWidget {
  AddAdminPage(this.title, this.groupName,
      [this.financeID = "", this.branchName = "", this.subBranchName = ""]);

  final String title;
  final String groupName;
  final String financeID;
  final String branchName;
  final String subBranchName;

  @override
  _AddAdminPageState createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserController _userController = UserController();

  Map<String, dynamic> _userDetails;
  List<int> userList = new List<int>();

  bool searchTriggered = false;
  bool showSearch = false;

  var mobileNumber;
  bool mobileNumberValid = true;

  @override
  Widget build(BuildContext context) {
    String _groupName = widget.groupName;

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Admin'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: new Container(
          // height: MediaQuery.of(context).size.height * 0.80,
          color: CustomColors.mfinLightGrey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Card(
                child: new Container(
                  color: CustomColors.mfinBlue,
                  padding: EdgeInsets.all(10),
                  child: new Text(
                    " Important! \nThis user will get ADMIN access over your selected $_groupName. And the user would have full WRITE access over this $_groupName",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: CustomColors.mfinAlertRed,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => mobileNumber = value,
                  decoration: InputDecoration(
                    fillColor: CustomColors.mfinGrey,
                    filled: true,
                    hintText: "Search user by mobile number",
                    errorText: !mobileNumberValid
                        ? 'Enter the valid 10 digit MobileNumber'
                        : null,
                    suffixIcon: customIconButton(
                        Icons.search, 30.0, CustomColors.mfinBlue, _onSearch),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              new Card(
                child: searchTriggered
                    ? new Container(
                        color: CustomColors.mfinBlue,
                        child: new ListTile(
                          leading: Icon(
                            Icons.person,
                            color: CustomColors.mfinButtonGreen,
                            size: 50,
                          ),
                          title: new Text(
                            _userDetails['user_name'],
                            style: TextStyle(
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                          subtitle: new Text(
                            _userDetails['mobile_number'].toString(),
                            style: TextStyle(
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      )
                    : new Container(),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons(() {
        _submit();
      }, () {
        _close();
      }),
    );
  }

  _onSearch() async {
    if (mobileNumber.length == 10) {
      Map<String, dynamic> apiResponse =
          await _userController.getByMobileNumber(int.parse(mobileNumber));
      if (apiResponse['is_success']) {
        setState(() {
          _userDetails = apiResponse['message'];
          userList.add(_userDetails['mobile_number']);
          mobileNumberValid = true;
        });
        print(_userDetails.toString());
        searchTriggered = true;
      } else {
        setState(() {
          mobileNumberValid = true;
          searchTriggered = false;
          _scaffoldKey.currentState.showSnackBar(
              CustomSnackBar.errorSnackBar(apiResponse['message'], 3));
        });
      }
    } else {
      setState(() {
        mobileNumberValid = false;
        searchTriggered = false;
      });
    }
  }

  Future<void> _submit() async {
    if (userList.length == 0) {
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar("No User Selected!", 2));
      Navigator.pop(context);
    } else {
      String groupName = widget.groupName;
      CustomDialogs.actionWaiting(context, "Updating Admin for $groupName");
      var response;

      try {
        if (widget.subBranchName != "") {
          SubBranchController _subBranchController = SubBranchController();
          response = await _subBranchController.updateSubBranchAdmins(
              true,
              userList,
              widget.financeID,
              widget.branchName,
              widget.subBranchName);
          BranchController _branchController = BranchController();
          await _branchController.updateBranchUsers(
              true, userList, widget.financeID, widget.branchName);
        } else if (widget.branchName != "") {
          BranchController _branchController = BranchController();
          response = await _branchController.updateBranchAdmins(
              true, userList, widget.financeID, widget.branchName);

          FinanceController _financeController = FinanceController();
          await _financeController.updateFinanceUsers(
              true, userList, widget.financeID);
        } else {
          FinanceController _financeController = FinanceController();
          response = await _financeController.updateFinanceAdmins(
              true, userList, widget.financeID);
        }
      } catch (err) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Unable to update admins for $groupName! Please contact support',
            5));
        print('Unable to update admins for $groupName: ' + err.toString());
      }

      if (!response['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Unable to update admins for $groupName! Please contact support',
            5));
        print('Unable to update admins for $groupName: ' + response['message']);
      } else {
        Navigator.pop(context);
        print('Admins added for $groupName successfully');
        Navigator.pop(context);
      }
    }
  }

  _close() {
    Navigator.pop(context);
  }
}
