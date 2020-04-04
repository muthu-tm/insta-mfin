import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/Common/CustomTextFormField.dart';
import 'package:instamfin/Customer/customerOptions.dart';


class CustomerTransactionScreen extends StatefulWidget {
  @override
  _CustomerTransactionScreenState createState() => _CustomerTransactionScreenState();
}

class _CustomerTransactionScreenState extends State<CustomerTransactionScreen> {
  int _selectedOption = 0;

  get child => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: topAppBar(),
      drawer:Drawer(
child: customTextFormField('Email',Colors.white,Icons.mail,TextInputType.emailAddress)

      ),
      body: 
      ListView.builder(
        itemCount: options.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(height: 5.0);
          } else if (index == options.length + 1) {
            return SizedBox(height: 100.0);
          }
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10.0),
              border: _selectedOption == index - 1
                  ? Border.all(color: Colors.white)
                  : null,
            ),
            child: ListTile(
              trailing: Text( 
                options[index - 1].value),
              title: Text(
                options[index - 1].title,
                style: TextStyle(
                  color: _selectedOption == index - 1
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
              selected: _selectedOption == index - 1,
              onTap: () {
                setState(() {
                  _selectedOption = index - 1;
                });
              },
            ),
          );
        },
      ),
      bottomSheet: bottomBar(context),
    );
  }
}