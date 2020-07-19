import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_collection.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class ViewChitCollections extends StatelessWidget {
  ViewChitCollections(this.chitID, this.fundDetails);

  final String chitID;
  final ChitFundDetails fundDetails;
  final UserPrimary _primary = UserController().getUserPrimary();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chit $chitID - ${fundDetails.chitNumber}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(child: _getBody()),
    );
  }

  Widget _getBody() {
    return StreamBuilder(
      stream: ChitCollection().streamCollectionsForChit(
          _primary.financeID,
          _primary.branchName,
          _primary.subBranchName,
          chitID,
          fundDetails.chitNumber),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  ChitCollection chitColl = ChitCollection.fromJson(
                      snapshot.data.documents[index].data);

                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ViewChitFund(chit),
                        //     settings:
                        //         RouteSettings(name: '/chit/collection/view'),
                        //   ),
                        // );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: CustomColors.mfinBlue,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Text(
                                chitColl.collectionAmount.toString(),
                                style: TextStyle(
                                  color: CustomColors.mfinLightGrey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                chitColl.customerNumber.toString(),
                                style: TextStyle(
                                  color: CustomColors.mfinLightGrey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Text(
                                'Recived:',
                                style: TextStyle(
                                  color: CustomColors.mfinGrey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                chitColl.getReceived().toString(),
                                style: TextStyle(
                                  color: CustomColors.mfinLightGrey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              color: CustomColors.mfinButtonGreen,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton.icon(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ViewChitCollections(
                                    //         chit.chitID, _fund),
                                    //     settings: RouteSettings(
                                    //         name: '/chit/collections'),
                                    //   ),
                                    // );
                                  },
                                  icon: Icon(Icons.remove_red_eye),
                                  label: Text("View"),
                                ),
                                FlatButton.icon(
                                  onPressed: () {
                                    print("Clicked Collected");
                                  },
                                  icon: Icon(Icons.monetization_on),
                                  label: Text("Mark As Collected"),
                                ),
                                FlatButton.icon(
                                  onPressed: () {
                                    print("Clicked Collection Edit");
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text("Edit"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ];
          } else {
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Collections for this Chit!",
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Spacer(),
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Container(
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Text(
                  'Chit Date:',
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  DateUtils.formatDate(DateTime.fromMillisecondsSinceEpoch(
                      fundDetails.chitDate)),
                  style: TextStyle(
                    color: CustomColors.mfinGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Text(
                  'Total Amount:',
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  'Rs.${fundDetails.totalAmount}',
                  style: TextStyle(
                    color: CustomColors.mfinGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Column(children: children),
              ),
            ],
          ),
        );
      },
    );
  }
}
