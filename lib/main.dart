import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cslib/authenFileProcess.dart';
import 'pages/login.dart';
import 'package:sskcovid19/pages/operations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sisaket Fight Covid-19',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sisaket Fight Covid-19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  AuthenFileProcess authenticationFile = new AuthenFileProcess();

  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {

    // Prevent Screen Rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 180.0,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 35.0),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, _checkAuthentication);
  }

  void _checkAuthentication() {
    authenticationFile.readToken().then((val) {
      if(val == "fail" || val == "{}") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OperationPage()
          ),
        );
      }
    });
  }
}
