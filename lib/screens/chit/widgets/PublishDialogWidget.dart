import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:instamfin/screens/chit/PublishChitFund.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget chitPublishDialog(BuildContext context, List<ChitTemplate> temps) {
  return SingleChildScrollView(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Select from Template",
              style: TextStyle(
                fontSize: 16.0,
                color: CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: CustomColors.mfinButtonGreen,
            ),
            temps.length > 0
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: temps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          color: CustomColors.mfinLightGrey,
                          child: ListTile(
                            leading: Text(
                              temps[index].tenure.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: CustomColors.mfinButtonGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(temps[index].name,
                             style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),),
                            subtitle: Text(
                                'Amount: ${temps[index].chitAmount}, Profit: ${temps[index].getProfitAmount()}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PublishChitFund(temps[index]),
                                  settings:
                                      RouteSettings(name: '/chit/publish/new'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    child: Text(" No Templates"),
                  ),
            Divider(
              color: CustomColors.mfinButtonGreen,
            ),
            SizedBox(height: 15),
            RaisedButton.icon(
              icon: Icon(
                Icons.email,
                color: CustomColors.mfinLightGrey,
              ),
              elevation: 15.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PublishChitFund(null),
                    settings: RouteSettings(name: '/chit/publish/new'),
                  ),
                );
              },
              label: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Custom',
                  style: TextStyle(
                    color: CustomColors.mfinButtonGreen,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              color: CustomColors.mfinBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
