import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/app/ProfilePictureUpload.dart';
import 'package:instamfin/screens/customer/ViewCustomer.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/utils/hash_generator.dart';

import '../../../app_localizations.dart';

Widget customerListTile(BuildContext context, int index, Customer customer) {
  Color tileColor = CustomColors.mfinBlue;
  Color textColor = CustomColors.mfinWhite;
  IconData custIcon = Icons.person;

  if ((index % 2) == 0) {
    tileColor = CustomColors.mfinWhite;
    textColor = CustomColors.mfinBlue;
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
          height: 75,
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
                        width: 60,
                        height: 60,
                        alignment: Alignment.topCenter,
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
                                      customer.getMediumProfilePicPath(),
                                      HashGenerator.hmacGenerator(
                                          customer.id.toString(),
                                          customer.financeID),
                                      customer.id),
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(
                                  custIcon,
                                  size: 25.0,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('upload'),
                                style: TextStyle(
                                  fontSize: 5.0,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: SizedBox(
                          width: 60.0,
                          height: 60.0,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: customer.getMiniProfilePicPath(),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 30.0,
                                backgroundImage: imageProvider,
                                backgroundColor: Colors.transparent,
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                size: 35,
                              ),
                              fadeOutDuration: Duration(seconds: 1),
                              fadeInDuration: Duration(seconds: 2),
                            ),
                          ),
                        ),
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
                    customer.mobileNumber != null
                        ? Text(
                            customer.mobileNumber != null
                                ? customer.mobileNumber.toString()
                                : "",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 14.0,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            customer.address.street != null
                                ? customer.address.street
                                : "",
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 12.0,
                                color:
                                    CustomColors.mfinAlertRed.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                          ),
                    customer.mobileNumber != null
                        ? Text(
                            customer.address.street != null
                                ? customer.address.street
                                : "",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 12.0,
                                color:
                                    CustomColors.mfinAlertRed.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                          )
                        : Container()
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
