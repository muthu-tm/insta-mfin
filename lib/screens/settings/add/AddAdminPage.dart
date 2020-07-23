import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserController _userController = UserController();

  Map<String, dynamic> _userDetails;
  List<int> userList = new List<int>();

  bool searchTriggered = false;
  bool showSearch = false;

  String mobileNumber = "";
  bool mobileNumberValid = true;

  @override
  Widget build(BuildContext context) {
    String _groupName = widget.groupName;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('add_admin')),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CustomColors.mfinAlertRed.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Important! \nThis user will get ADMIN access over your selected $_groupName. And the user will have full access over this $_groupName",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: CustomColors.mfinLightGrey,
                          fontSize: 16.0,
                          fontFamily: 'Georgia',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => mobileNumber = value,
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        hintText: AppLocalizations.of(context).translate('type_user_mobile_no'),
                        errorText: !mobileNumberValid
                            ? AppLocalizations.of(context).translate('enter_valid_phone')
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
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: CustomColors.mfinBlue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: searchTriggered
                    ? ListTile(
                        leading: Icon(
                          Icons.person,
                          color: CustomColors.mfinButtonGreen,
                          size: 50,
                        ),
                        title: Text(
                          _userDetails['user_name'],
                          style: TextStyle(
                            color: CustomColors.mfinLightGrey,
                          ),
                        ),
                        subtitle: Text(
                          _userDetails['mobile_number'].toString(),
                          style: TextStyle(
                            color: CustomColors.mfinLightGrey,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          AppLocalizations.of(context).translate('no_user_select'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.mfinLightGrey,
                            fontSize: 16.0,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onSearch() async {
    if (mobileNumber != "" &&
        int.parse(mobileNumber) == UserController().getCurrentUserID()) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
        AppLocalizations.of(context).translate('type_user_mobile_no'), 3));
      return;
    }

    if (mobileNumber != null && mobileNumber.length == 10) {
      Map<String, dynamic> apiResponse =
          await _userController.getByMobileNumber(int.parse(mobileNumber));
      if (apiResponse['is_success']) {
        Map<String, dynamic> resp = {};
        if (apiResponse['message'] == null) {
          resp['mobile_number'] = int.parse(mobileNumber);
          resp['user_name'] = "<Unknown_User>";
        } else {
          resp = apiResponse['message'];
        }
        setState(() {
          _userDetails = resp;
          userList = [_userDetails['mobile_number']];
          mobileNumberValid = true;
        });
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
      userList = [];
      setState(() {
        mobileNumberValid = false;
        searchTriggered = false;
      });
    }
  }

  Future<void> _submit() async {
    if (userList.length == 0) {
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar(AppLocalizations.of(context).translate('no_user_select'), 2));
    } else {
      String groupName = widget.groupName;
      CustomDialogs.actionWaiting(context, AppLocalizations.of(context).translate('updating_admin'));
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
      }

      if (!response['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
            'Unable to update admins for $groupName! Please contact support',
            5));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }
}
