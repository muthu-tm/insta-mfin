import 'package:flutter/material.dart';
import 'package:instamfin/screens/transaction/AddTemplate.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class CollectionTemplateWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.mfinLightGrey,
      child: new Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.library_books,
              size: 35.0,
              color: CustomColors.mfinButtonGreen,
            ),
            title: new Text(
              "Collection Templates",
              style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 18.0,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_box,
                size: 35.0,
                color: CustomColors.mfinBlue,
              ),
              onPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddCollectionTemplate(),
                          ),
                        );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          suffixIcon: customIconButton(Icons.navigate_next,
                              35.0, CustomColors.mfinBlue, null),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinGrey)),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         addNewPayment(),
                        //   ),
                        // );
                      },
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          size: 35.0,
                          color: CustomColors.mfinAlertRed,
                        ),
                        onPressed: () {
                        //   int userID = subBranch.admins[index];
                        //   UserController _uc = UserController();
                        //   if (userID == _uc.getCurrentUserID()) {
                        //     CustomDialogs.information(context, "Warning",
                        //         "You cannot remove yourself");
                        //   } else {
                        //     String subBranchName = subBranch.subBranchName;
                        //     CustomDialogs.confirm(
                        //       context,
                        //       "Confirm",
                        //       "Are you sure to remove $userID from $subBranchName",
                        //       () async {
                        //         SubBranchController _sbc =
                        //             SubBranchController();
                        //         try {
                        //           await _sbc.updateSubBranchAdmins(
                        //             false,
                        //             [userID],
                        //             financeID,
                        //             branchName,
                        //             subBranchName,
                        //           );

                        //           List<SubBranch> sbList =
                        //               await _sbc.getSubBranchesForUserID(
                        //                   financeID, branchName, userID);
                        //           if (sbList != null && sbList.length == 0) {
                        //             BranchController _bc = BranchController();
                        //             await _bc.updateBranchUsers(
                        //                 false, [userID], financeID, branchName);
                        //           }
                        //         } catch (err) {
                        //           print(
                        //             "Error while removing $userID from $subBranchName" +
                        //                 err.toString(),
                        //           );
                        //           _scaffoldKey.currentState.showSnackBar(
                        //             CustomSnackBar.errorSnackBar(
                        //                 "Error while removing $userID from $subBranchName",
                        //                 3),
                        //           );
                        //         }

                        //         Navigator.pop(context);
                        //       },
                        //       () {
                        //         Navigator.pop(context);
                        //       },
                        //     );
                        //   }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
