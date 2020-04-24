import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/BranchWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

final UserService _userService = locator<UserService>();

class EditBranchSetting extends StatelessWidget {
  final User user = _userService.cachedUser;
  final Address updatedAddress = new Address();
  final Map<String, dynamic> updatedBranch = new Map();

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Branch Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  BranchWidget(),
                  ListTile(
                    title: new TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: user.emailID,
                      decoration: InputDecoration(
                        hintText: 'Enter your EmailID',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      validator: (passkey) =>
                          FieldValidator.emailValidator(passkey, setEmailID),
                    ),
                  ),
                  AddressWidget("Address", user.address, updatedAddress),
                ]),
          ),
        ),
      ),
      bottomSheet: EditorsActionButtons((){},(){}),
      bottomNavigationBar: bottomBar(context),
    );
  }


  setEmailID(String emailID) {
    updatedBranch[emailID] = emailID;
  }
}
