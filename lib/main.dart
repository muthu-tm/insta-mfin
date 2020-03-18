import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MFIN',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.blue[800],
        accentColor: Colors.blue[800],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(title: 'Signup Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 100.0,
            width: 100.0,
            padding: new EdgeInsets.only(top: 22.0),
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
            title: TextFormField(
              decoration: new InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.blue[200],
                    size: 50.0,
                  )),
              validator: (value) => value.isEmpty ? 'Name is required' : null,
            ),
          ),
          new ListTile(
            title: TextFormField(
              decoration: new InputDecoration(
                  hintText: "Mobile Number",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.phone_android,
                      color: Colors.blue[200], size: 50.0)),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value.isEmpty ? 'Mobile Number is required' : null,
            ),
          ),
          new ListTile(
            title: TextFormField(
              decoration: new InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                  suffixIcon:
                      Icon(Icons.email, color: Colors.blue[200], size: 50.0)),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value.isEmpty ? 'Email is required' : null,
            ),
          ),
          new ListTile(
            title: TextFormField(
              decoration: new InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off,
                      color: Colors.blue[200], size: 50.0)),
              validator: (value) =>
                  value.isEmpty ? 'Password is required' : password = value,
            ),
          ),
          new ListTile(
            title: TextFormField(
              decoration: new InputDecoration(
                hintText: "Confirm Password",
                border: OutlineInputBorder(),
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
                color: Colors.blueAccent,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Center(
                child: new Text(
                  'SIGN UP',
                  style: new TextStyle(fontSize: 18.0, color: Colors.white),
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
                onPressed: null,
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() {
    _formKey.currentState.validate();
    print('Form submitted');
  }
}
