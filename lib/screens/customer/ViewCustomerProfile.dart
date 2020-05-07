import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ViewCustomerProfile extends StatelessWidget {
  ViewCustomerProfile(this.customer);

  final Map<String, dynamic> customer;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(customer['customer_name']),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.assignment_ind,
                  size: 35.0,
                  color: CustomColors.mfinFadedButtonGreen,
                ),
                title: new Text(
                  "Customer Profile",
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  initialValue: customer['customer_name'],
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: CustomColors.mfinGrey,
                    )),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: customer['customer_id'],
                  decoration: InputDecoration(
                    labelText: 'Customer ID',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: CustomColors.mfinGrey,
                    )),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: customer['mobile_number'].toString(),
                  decoration: InputDecoration(
                    labelText: 'Customer Mobile Number',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: customer['customer_profession'],
                  decoration: InputDecoration(
                    labelText: 'Profession',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: customer['gender'],
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: new TextFormField(
                  initialValue: customer['age'].toString(),
                  decoration: InputDecoration(
                    labelText: "Customer's Age",
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinWhite)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: customer['guarantied_by'].toString(),
                  decoration: InputDecoration(
                    labelText: 'Gurantied by',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: customer['added_by'].toString(),
                  decoration: InputDecoration(
                    labelText: 'Customer Added by',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              ),
              ListTile(
                title: TextFormField(
                  initialValue:
                      Address.fromJson(customer['address']).toString(),
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Customer Address',
                    fillColor: CustomColors.mfinWhite,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 1.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.mfinGrey)),
                  ),
                  enabled: false,
                  autofocus: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
