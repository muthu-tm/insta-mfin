import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/miscellaneous_category.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/transaction/add/AddMiscellaneousCategory.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class MiscellaneousCategoryScreen extends StatelessWidget {
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Miscellaneous Categories"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMiscellaneousCategory(),
            ),
          );
        },
        label: Text(
          'Add',
          style: TextStyle(
            color: CustomColors.mfinWhite,
            fontSize: 16,
          ),
        ),
        icon: Icon(
          Icons.add,
          size: 40,
          color: CustomColors.mfinFadedButtonGreen,
        ),
        // backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: MiscellaneousCategory().streamCategories(_user.primaryFinance,
              _user.primaryBranch, _user.primarySubBranch),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Widget widget;

            if (snapshot.hasData) {
              if (snapshot.data.documents.isNotEmpty) {
                widget = ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Text(
                        snapshot.data.documents[index].data['category_name'],
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              } else {
                // No cistomers available
                widget = Container(
                  height: 90,
                  child: Column(
                    children: <Widget>[
                      new Spacer(),
                      Text(
                        "No Categories!",
                        style: TextStyle(
                          color: CustomColors.mfinAlertRed,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new Spacer(
                        flex: 2,
                      ),
                      Text(
                        "Add your Categories!",
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      new Spacer(),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              widget = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: AsyncWidgets.asyncError(),
                ),
              );
            } else {
              widget = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: AsyncWidgets.asyncWaiting(),
                ),
              );
            }

            return widget;
          },
        ),
      ),
    );
  }
}
