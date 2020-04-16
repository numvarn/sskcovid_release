import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/cslib/profileFileProcess.dart';
import 'package:sskcovid19/cslib/sideMenu.dart';
import 'package:sskcovid19/pages/login.dart';
import 'package:sskcovid19/pages/checkin.dart';
import 'package:sskcovid19/pages/profile.dart';
import 'package:sskcovid19/pages/checkedin_tracker.dart';
import 'package:sskcovid19/pages/self_screening.dart';

// Operation Page After login
class OperationPage extends StatefulWidget {
  OperationPage({Key key}) : super(key: key);

  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  //Progress Dialog
  ProgressDialog pr;

  var btColors = Colors.lightBlue;

  //Read config file
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();
  ProfileFileProcess profileFileProcess = new ProfileFileProcess();

  String profileName = "waiting";

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();
    getProfileAPI();
  }

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
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    TextStyle style = GoogleFonts.prompt();

    TextStyle mainStyle = GoogleFonts.prompt(
      fontWeight: FontWeight.bold,
      fontSize: 27.0,
      color: Colors.white,
    );

    TextStyle descStyle = GoogleFonts.prompt(
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
      color: Colors.white,
    );

    TextStyle menuHeaderStyle = GoogleFonts.prompt(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: Colors.black,
    );

    TextStyle menuDesStyle = GoogleFonts.prompt(
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
      color: Colors.black54,
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('ศรีสะเกษสู้โควิด 19', style: style),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Center(
                  child: Card(
                    elevation: 4,
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: SizedBox(
                        height: 120,//MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Text("Sisaket Fight Covid-19", style: mainStyle),
                            SizedBox(height: 20.0),
                            Text("เราจะร่วมกันผ่านวิกฤติการระบาดโควิด 19 ไปด้วยกัน", style: descStyle),
                            SizedBox(height: 10.0),
                            Text("โดยจังหวัดศรีสะเกษ", style: descStyle),
                          ],
                        ),
                      ),
                    ),

                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Card(
                  elevation: 2,
                  color: Colors.lightBlue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckinPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        height: 80,//MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                          leading: Icon(Icons.location_on, size: 40),//FlutterLogo(),
                          title: Text("ส่งพิกัดการเดินทาง", style: menuHeaderStyle),
                          subtitle: Text("บันทึกการเดินทางของท่านเพื่อตรวจสอบการระบาดย้อนหลัง", style: menuDesStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Card(
                  elevation: 2,
                  color: Colors.lightBlue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrackerPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        height: 80,//MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                          leading: Icon(Icons.history, size: 40),//FlutterLogo(),
                          title: Text("ประวัติการเดินทาง", style: menuHeaderStyle),
                          subtitle: Text("รายการสถานที่ที่ท่านได้ทำการบันทึกพิกัดการเดินทางไว้", style: menuDesStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Card(
                  elevation: 2,
                  color: Colors.lightBlue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelfScreenPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        height: 80,//MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                          leading: Icon(Icons.assignment, size: 40),//FlutterLogo(),
                          title: Text("ประเมินความเสี่ยง", style: menuHeaderStyle),
                          subtitle: Text("ทำแบบประเมินความเสี่ยงในการได้รับเชื้อ และรับข้อแนะนำในการดูแลตัวเอง", style: menuDesStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Card(
                  elevation: 2,
                  color: Colors.lightBlue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        height: 80,//MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                          leading: Icon(Icons.account_box, size: 40),//FlutterLogo(),
                          title: Text("ข้อมูลส่วนตัว", style: menuHeaderStyle),
                          subtitle: Text("บันทึกข้อมูลส่วนตัว เพื่อแจ้งให้เจ้าหน้าที่รับทราบและใช้ในกรณีเกิดเหตุฉุกเฉิน", style: menuDesStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logoutProcess() async {
    // Progress Dialog
    pr = new ProgressDialog(context);
    pr.style(
      message: '  Loging out...',
      progressWidget: CircularProgressIndicator(),
    );

    pr.show();

    authenFileProcess.writeToken("{}");
    profileFileProcess.writeProfile("{}");

    pr.hide();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  void getProfileAPI() async {
    if (profileName == "waiting") {
      var url = "https://ssk-covid19.herokuapp.com/get/myuser";

      //Get user authentication token form auth file
      final jsonDec = authenFileProcess.readToken().then((val) {
        return json.decode(val);
      });

      //Get current user profile from API
      var httpResponse = jsonDec.then((val) {
        final token = val['token'];
        return Http.get(url, headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        });
      });

      //Write Profile of current user to json file
      httpResponse.then((response) {
        String body = utf8.decode(response.bodyBytes);
        profileFileProcess.writeProfile(body);

        final profile = json.decode(body);

        setState(() {
          profileName = profile['results'][0]['first_name'] +
              " " +
              profile['results'][0]['last_name'];
        });
      });
    }
  }
}
