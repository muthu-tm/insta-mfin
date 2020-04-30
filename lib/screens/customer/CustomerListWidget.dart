import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';

class CustomerListWidget extends StatelessWidget {
  CustomerListWidget(this.title, [this.userStatus = 0]);
  final Customer _cust = Customer();

  final int userStatus;
  final String title;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cust.getCustomerByStatus(userStatus),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: CustomColors.mfinWhite,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Text(
                            snapshot
                                .data.documents[index].data['customer_name'],
                            style: TextStyle(
                              color: CustomColors.mfinBlue,
                              fontSize: 18,
                            ),
                          ),
                          title: Text(
                            snapshot.data.documents[index].data['mobile_number']
                                .toString(),
                            style: TextStyle(
                              color: CustomColors.mfinBlue,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {},
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 35.0,
                              color: CustomColors.mfinBlue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCustomerProfile(
                                      snapshot.data.documents[index].data),
                                ),
                              );
                            },
                          ),
                        ),
                        new Divider(
                          color: CustomColors.mfinButtonGreen,
                          thickness: 1,
                        ),
                        ListTile(
                          leading: RaisedButton.icon(
                            color: CustomColors.mfinWhite,
                            highlightColor: CustomColors.mfinWhite,
                            onPressed: null,
                            icon: Icon(
                              Icons.call,
                              size: 35.0,
                              color: CustomColors.mfinPositiveGreen,
                            ),
                            label: Text(
                              "Phone",
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          title: RaisedButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.message,
                              size: 35.0,
                              color: CustomColors.mfinGrey,
                            ),
                            label: Text(
                              "Text",
                              style: TextStyle(
                                color: CustomColors.mfinBlue,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onTap: () {},
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 35.0,
                              color: CustomColors.mfinAlertRed,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        new Divider(
                          // color: CustomColors.mfinBlue,
                          thickness: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ];
          } else {
            // No branches available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Customers!",
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
                      "Search for different type!",
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
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.supervisor_account,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                title: new Text(
                  title,
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                  ),
                ),
                trailing: RaisedButton.icon(
                  onPressed: null,
                  icon: customIconButton(
                    Icons.menu,
                    35.0,
                    CustomColors.mfinBlue,
                    null,
                  ),
                  label: Text("Sort by"),
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
                thickness: 1,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
