import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:instamfin/screens/transaction/add/AddTemplate.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';

class PaymentTemplateWidget extends StatelessWidget {
  PaymentTemplateWidget(this._scaffoldKey);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PaymentTemplate().streamTemplates(),
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
                  return ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue:
                          snapshot.data.documents[index].data['template_name'],
                      decoration: InputDecoration(
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        suffixIcon: customIconButton(Icons.navigate_next, 35.0,
                            CustomColors.mfinBlue, null),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinGrey)),
                      ),
                      enabled: false,
                      autofocus: false,
                    ),
                    onTap: () {},
                    trailing: IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        size: 35.0,
                        color: CustomColors.mfinAlertRed,
                      ),
                      onPressed: () async {
                        CustomDialogs.confirm(
                          context,
                          "Confirm",
                          "Are you sure to remove ${snapshot.data.documents[index].data['template_name']}",
                          () async {
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                    "Removing a template", 2));
                            PaymentTemplateController _ctc =
                                PaymentTemplateController();
                            PaymentTemplate temp = PaymentTemplate.fromJson(
                                snapshot.data.documents[index].data);
                            var result =
                                await _ctc.removeTemp(temp.getDocumentID());
                            if (!result['is_success']) {
                              _scaffoldKey.currentState.showSnackBar(
                                  CustomSnackBar.errorSnackBar(
                                      result['message'], 5));
                              print("Unable to remove Template: " +
                                  result['message']);
                            } else {
                              print("Template removed successfully");
                            }
                          },
                          () {
                            Navigator.pop(context);
                          },
                        );
                      },
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
                      "No Templates available!",
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
                      "Create your Templates!",
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
                        builder: (context) => AddCollectionTemplate(),
                        settings: RouteSettings(name: '/transactions/payment/template/add'),
                      ),
                    );
                  },
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
