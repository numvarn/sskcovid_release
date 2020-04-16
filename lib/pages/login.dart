import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/pages/operations.dart';
import 'package:sskcovid19/pages/register.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  // TextField Controller
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  TextStyle style = GoogleFonts.prompt(
    fontSize: 20,
  );

  TextStyle styleButton = GoogleFonts.prompt(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('หยุดการทำงานโปรแกรม'),
        content: new Text('คุณต้องการหยุดการทำงานโปรแกรม ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('ไม่ใช่'),
          ),
          new FlatButton(
            onPressed: () => exit(0), //Navigator.of(context).pop(true),
            child: new Text('ใช่'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "ชื่อผู้ใช้ระบบ/อีเมล",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "รหัสผ่าน",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = RoundedLoadingButton(
        child: Text("เข้าสู่ระบบ",
            textAlign: TextAlign.center,
            style: styleButton,
        ),
        controller: _btnController,
        width: MediaQuery.of(context).size.width,
        color: Colors.lightBlue,
        onPressed: () {
          _signIn();
        },
    );

    final registerButton = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightBlue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()),);
        },
        child: Text(
            "ลงทะเบียนผู้ใช้งานใหม่",
            textAlign: TextAlign.center,
            style: styleButton
        ),
      ),
    );

    return WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
          appBar: AppBar(
            title: Text('เช้าใช้งานระบบ', style: style),
            automaticallyImplyLeading: false,
          ),

          body: Center(
            child: SingleChildScrollView (
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 180.0,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(height: 35.0),
                  loginButton,
                  SizedBox(height: 15.0),
                  registerButton,
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
    );
  }

  void _signIn() async {
    var url = "https://ssk-covid19.herokuapp.com/api/login";

    Map<String, String> data = {
      "username":emailController.text.trim(),
      "password":passwordController.text.trim()
    };

    if(emailController.text.trim() != "" && passwordController.text.trim() != "") {
      var response = await Http.post(url, body:data);

      final responseJson = json.decode(response.body);
      if(responseJson['token'] != null) {
        String data = '{"token": "${responseJson['token']}"}';

        AuthenFileProcess authenFileProcess = new AuthenFileProcess();
        authenFileProcess.writeToken(data);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OperationPage())
        );
      } else {
        _showAlertLoginFail(context);
        _btnController.stop();
      }
    } else {
      _showAlertLoginFail(context);
      _btnController.stop();
    }
  }

  void _showAlertLoginFail(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Invalid Username/Password"),
          content: Text("Please, check your username or password"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        )
    );
  }
}
