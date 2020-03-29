import 'package:flutter/material.dart';
import 'package:instamfin/Common/CustomTextFormField.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = "";

  bool _passwordVisible = false;
  bool showPassword = false;
  bool requiredFieldsFilled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.white, Colors.grey[700]])),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              height: 75.0,
              width: 100.0,
              padding: new EdgeInsets.only(top: 5.0),
              child: FloatingActionButton(
                onPressed: null,
                backgroundColor: Colors.white,
                child: new Icon(
                  Icons.file_upload,
                  size: 50,
                ),
                foregroundColor: Colors.blue[200],
              ),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            new ListTile(
              title: customTextFormField('Name', Colors.white,
                  Icons.sentiment_satisfied, TextInputType.text),
            ),
            new ListTile(
              title: customTextFormField('Mobile Number', Colors.white,
                  Icons.phone, TextInputType.phone),
            ),
            new ListTile(
              title: customTextFormField('Email', Colors.white, Icons.email,
                  TextInputType.emailAddress),
            ),
            new ListTile(
              title: TextFormField(
                obscureText: showPassword,
                decoration: new InputDecoration(
                  hintText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.blue[200], size: 35.0,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Password is required' : password = value,
              ),
            ),
            new ListTile(
              title: TextFormField(
                decoration: new InputDecoration(
                  hintText: "Confirm Password",
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Confirm your Password';
                  } else if (password != value) {
                    return 'Password should be matched';
                  }
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(15.0)),
            new InkWell(
              onTap: _submit,
              child: new Container(
                width: 200.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(
                  child: new Text(
                    'SIGN UP',
                    style: new TextStyle(
                        fontSize: 22.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                new Container(
                  child: const Text(
                    'Already have an account ?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                FlatButton(
                  padding: const EdgeInsets.all(20.0),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    _formKey.currentState.validate();
    print('Form submitted');
  }
}
