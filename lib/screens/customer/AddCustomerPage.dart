import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/utils/CustomTextFormField.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key key}) : super(key: key);

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: topAppBar(),
      drawer: openDrawer(context),
      body: Column(children: <Widget>[
              Row(
                //ROW 1
                children: [
                 Text('Customer ID:'),
                 customTextFormField('Customer ID', Colors.black, null, TextInputType.text)
                ],
              ),
              Row(//ROW 2
                  children: [
                Container(
                  color: Colors.orange,
                  margin: EdgeInsets.all(25.0),
                  child: FlutterLogo(
                    size: 60.0,
                  ),
                ),
                Container(
                  color: Colors.blue,
                  margin: EdgeInsets.all(25.0),
                  child: FlutterLogo(
                    size: 60.0,
                  ),
                ),
                Container(
                  color: Colors.purple,
                  margin: EdgeInsets.all(25.0),
                  child: FlutterLogo(
                    size: 60.0,
                  ),
                )
              ]),
              Row(// ROW 3
                  children: [
                Container(
                  color: Colors.orange,
                  margin: EdgeInsets.all(25.0),
                  child: FlutterLogo(
                    size: 60.0,
                  ),
                ),
                Container(
                  color: Colors.blue,
                  margin: EdgeInsets.all(25.0),
                  child: FlutterLogo(
                    size: 60.0,
                  ),
                ),
                Container(
                  color: Colors.purple,
                  margin: EdgeInsets.all(25.0),
                  child: FlutterLogo(
                    size: 60.0,
                  ),
                ),
              ]),
            ])
    );
  }

  void _submit() {
    _formKey.currentState.validate();
    print('Form submitted');
  }
}
