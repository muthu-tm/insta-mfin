import 'package:flutter/material.dart';
import 'package:instamfin/Common/CustomTextFormField.dart';
import './../services/authenticate/auth.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({this.toggleView});

  final Function toggleView;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email;
  String password;

  bool _passwordVisible = false;
  bool showPassword = false;
  bool requiredFieldsFilled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[900],
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.teal[900],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
                foregroundColor: Colors.teal[200],
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
                title: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(
                        Icons.mail,
                        color: Colors.teal[200],
                        size: 35.0,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email ID is required';
                      }

                      setState(() => email = value);
                      return null;
                    })),
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
                        color: Colors.teal[200], size: 35.0,
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password is required';
                    }

                    setState(() => password = value);
                    return null;
                  }),
            ),
            new ListTile(
              title: TextFormField(
                decoration: new InputDecoration(
                  hintText: "Confirm Password",
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value.isEmpty) {
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
                        color: Colors.teal[900],
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                new Container(
                  child: const Text(
                    ' Already have an account? ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
                FlatButton(
                  padding: const EdgeInsets.all(20.0),
                  onPressed: () => {
                    // Navigator.pushNamed(context, '/home');
                    widget.toggleView(),
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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

  void _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      print(email);
      print("Going to Register new user: " + email);

      dynamic result = await _auth.registerWithEmailPassword(email, password);
      if (result == null) {
        print("Unable to register USER");
      }
    } else {
      print("Invalid form values");
    }
  }
}
