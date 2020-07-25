import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/app/ProfilePictureUpload.dart';
import 'package:instamfin/screens/customer/ViewCustomer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

import '../../../app_localizations.dart';

Widget customerListTile(BuildContext context, int index, Customer customer) {
  Color tileColor = CustomColors.mfinBlue;
  Color textColor = CustomColors.mfinWhite;
  IconData custIcon = Icons.person_outline;

  if ((index % 2) == 0) {
    tileColor = CustomColors.mfinWhite;
    textColor = CustomColors.mfinBlue;
    custIcon = Icons.person;
  }
  return Padding(
    padding: EdgeInsets.only(left: 12.0, top: 5.0, right: 12.0, bottom: 5.0),
    child: Material(
      color: tileColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewCustomer(customer),
              settings: RouteSettings(name: '/customers/view'),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.width / 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: tileColor,
          ),
          child: Row(
            children: <Widget>[
              customer.getProfilePicPath() == ""
                  ? Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CustomColors.mfinFadedButtonGreen,
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              routeSettings:
                                  RouteSettings(name: "/profile/upload"),
                              builder: (context) {
                                return Center(
                                  child: ProfilePictureUpload(
                                      1,
                                      customer.getProfilePicPath(),
                                      customer.financeID +
                                          '_' +
                                          customer.id.toString(),
                                      customer.id),
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                custIcon,
                                size: 35.0,
                                color: textColor,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('upload'),
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CircleAvatar(
                              radius: 35.0,
                              backgroundImage:
                                  NetworkImage(customer.getProfilePicPath()),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            left: 20,
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  routeSettings:
                                      RouteSettings(name: "/profile/upload"),
                                  builder: (context) {
                                    return Center(
                                      child: ProfilePictureUpload(
                                          1,
                                          customer.getProfilePicPath(),
                                          customer.financeID +
                                              '_' +
                                              customer.id.toString(),
                                          customer.id),
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: CustomColors.mfinButtonGreen,
                                radius: 10,
                                child: Icon(
                                  Icons.edit,
                                  color: CustomColors.mfinBlue,
                                  size: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Container(
                padding: EdgeInsets.only(left: 20.0, top: 5.0),
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${customer.firstName} ${customer.lastName}',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18.0,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      customer.mobileNumber != null
                          ? customer.mobileNumber.toString()
                          : "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14.0,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      customer.address.street != null
                          ? customer.address.street
                          : "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12.0,
                          color: CustomColors.mfinAlertRed.withOpacity(0.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
