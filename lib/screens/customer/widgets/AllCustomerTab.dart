import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/app_localizations.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/EditCustomer.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListTile.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/url_launcher_utils.dart';
import 'package:instamfin/services/controllers/customer/cust_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomerTab extends StatefulWidget {
  CustomerTab(this._scaffoldKey, this.title, this.status);

  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final int status;

  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  String orderBy = "0";
  Map<String, String> _selectedOrderBy = {
    "0": "Default",
    "1": "Recent",
    "2": "Name Asc",
    "3": "Name Desc"
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.status != 0
          ? Customer()
              .streamCustomersByStatus(widget.status, int.parse(orderBy))
          : Customer().streamAllCustomers(int.parse(orderBy)),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 155,
                    height: 50,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('order_by'),
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      items: _selectedOrderBy.entries.map(
                        (f) {
                          return DropdownMenuItem<String>(
                            value: f.key,
                            child: Text(f.value),
                          );
                        },
                      ).toList(),
                      onChanged: (newVal) {
                        _setOrderBy(newVal);
                      },
                      value: orderBy,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Customer cust =
                      Customer.fromJson(snapshot.data.documents[index].data);

                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.20,
                    closeOnScroll: true,
                    direction: Axis.horizontal,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Phone',
                        color: CustomColors.mfinPositiveGreen,
                        icon: Icons.call,
                        onTap: () {
                          if (cust.mobileNumber != null) {
                            UrlLauncherUtils.makePhoneCall(
                                cust.getContactNumber());
                          } else {
                            widget._scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(
                                  AppLocalizations.of(context)
                                      .translate('customer_invalid_number'),
                                  3),
                            );
                          }
                        },
                      ),
                      IconSlideAction(
                        caption: 'Message',
                        color: CustomColors.mfinGrey,
                        icon: Icons.message,
                        onTap: () {
                          if (cust.mobileNumber != null) {
                            UrlLauncherUtils.makeSMS(cust.getContactNumber());
                          } else {
                            widget._scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(
                                  AppLocalizations.of(context)
                                      .translate('customer_invalid_number'),
                                  3),
                            );
                          }
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: CustomColors.mfinBlue,
                        icon: Icons.edit,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCustomerProfile(cust),
                            settings:
                                RouteSettings(name: '/customers/profile/edit'),
                          ),
                        ),
                      ),
                      IconSlideAction(
                        caption: 'Remove',
                        color: CustomColors.mfinAlertRed,
                        icon: Icons.delete_forever,
                        onTap: () async {
                          var state = Slidable.of(context);
                          var dismiss = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: new Text(
                                  AppLocalizations.of(context)
                                      .translate('confirm'),
                                  style: TextStyle(
                                      color: CustomColors.mfinAlertRed,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                content: Text(
                                    '${AppLocalizations.of(context).translate('sure_remove')} ${cust.firstName} ${cust.lastName} ${AppLocalizations.of(context).translate('customer_question')}'),
                                actions: <Widget>[
                                  FlatButton(
                                    color: CustomColors.mfinButtonGreen,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('no'),
                                      style: TextStyle(
                                          color: CustomColors.mfinBlue,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  FlatButton(
                                    color: CustomColors.mfinAlertRed,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('yes'),
                                      style: TextStyle(
                                          color: CustomColors.mfinLightGrey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                    onPressed: () async {
                                      CustController _cc = CustController();
                                      var result =
                                          await _cc.removeCustomer(cust.id);
                                      if (result == null) {
                                        Navigator.pop(context);
                                        widget._scaffoldKey.currentState
                                            .showSnackBar(
                                          CustomSnackBar.errorSnackBar(
                                            AppLocalizations.of(context)
                                                .translate('remove_payment'),
                                            3,
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                        widget._scaffoldKey.currentState
                                            .showSnackBar(
                                          CustomSnackBar.successSnackBar(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'customer_removed'),
                                              2),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          if (dismiss != null && dismiss && state != null) {
                            state.dismiss();
                          }
                        },
                      ),
                    ],
                    child: customerListTile(context, index, cust),
                  );
                },
              ),
            ];
          } else {
            // No cistomers available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      AppLocalizations.of(context).translate('no_customers'),
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('search_type'),
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
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

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }

  _setOrderBy(String newVal) {
    setState(() {
      orderBy = newVal;
    });
  }
}
