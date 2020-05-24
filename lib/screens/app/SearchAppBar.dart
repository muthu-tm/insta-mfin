import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/screens/customer/widgets/CustomerListTile.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int minNumber = 0;
  int maxNumber = 0;
  Stream<QuerySnapshot> snapshot;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: CustomColors.mfinBlue,
        centerTitle: true,
        title: Form(
          key: _formKey,
          child: new TextFormField(
            style: new TextStyle(
              color: CustomColors.mfinWhite,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the customer number';
              } else {
                if (value.length < 10) {
                  minNumber = int.parse(value.padRight(10, '0'));
                  maxNumber = int.parse(value.padRight(10, '9'));
                } else if (value.length == 10) {
                  minNumber = int.parse(value);
                  maxNumber = int.parse(value);
                }
                return null;
              }
            },
            decoration: new InputDecoration(
                hintText: "Type Customer Number here...",
                hintStyle: new TextStyle(color: CustomColors.mfinWhite)),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              size: 35.0,
              color: CustomColors.mfinWhite,
            ),
            onPressed: () {
              final FormState form = _formKey.currentState;

              if (form.validate()) {
                setState(
                  () {
                    snapshot =
                        Customer().streamCustomersByRange(minNumber, maxNumber);
                  },
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: snapshot,
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
                      return customerListTile(
                          context, index, snapshot.data.documents[index].data);
                    })
              ];
            } else {
              // No customers found
              children = <Widget>[
                Text(
                  "No Cusomters Found",
                  style: new TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ];
            }
          } else if (snapshot.hasError) {
            children = AsyncWidgets.asyncError();
          } else {
            children = AsyncWidgets.asyncWaiting();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
