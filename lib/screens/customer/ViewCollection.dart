import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class ViewCollection extends StatelessWidget {
  ViewCollection(this.collection, this.iconColor);

  final Collection collection;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Collection - ${collection.customerNumber}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AddPayment(customer),
          //     settings: RouteSettings(name: '/customers/payments/add'),
          //   ),
          // );
        },
        label: Text(
          "Edit",
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.edit,
          size: 35,
          color: CustomColors.mfinFadedButtonGreen,
        ),
      ),
      body: SingleChildScrollView(
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.drafts,
                  size: 35.0,
                  color: iconColor,
                ),
                title: Text(
                  getType(collection.type),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  collection.totalPaid.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.mfinPositiveGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinButtonGreen,
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        "GENERAL INFO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Georgia",
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mfinBlue,
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinBlue,
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "COLL NO",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: collection.collectionNumber.toString(),
                        decoration: InputDecoration(
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.mfinGrey,
                            ),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "AMOUNT",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: collection.collectionAmount.toString(),
                        decoration: InputDecoration(
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.mfinGrey,
                            ),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "RECEIVED",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: collection.totalPaid.toString(),
                        decoration: InputDecoration(
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.mfinGrey,
                            ),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 100,
                        child: Text(
                          "DATE",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinGrey),
                        ),
                      ),
                      title: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue:
                            DateUtils.formatDate(collection.collectionDate),
                        decoration: InputDecoration(
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.mfinGrey,
                            ),
                          ),
                        ),
                        enabled: false,
                        autofocus: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getType(int type) {
    switch (type) {
      case 0:
        return "COLLECTION";
        break;
      case 1:
        return "DOC CHARGE";
        break;
      case 2:
        return "SURCHARGE";
        break;
      case 3:
        return "CLOSING";
        break;
      default:
        return "COLLECTION";
        break;
    }
  }
}
