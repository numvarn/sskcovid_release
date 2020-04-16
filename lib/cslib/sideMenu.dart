import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/cslib/profileFileProcess.dart';

import 'package:sskcovid19/pages/operations.dart';
import 'package:sskcovid19/pages/checkin.dart';
import 'package:sskcovid19/pages/checkedin_tracker.dart';
import 'package:sskcovid19/pages/profile.dart';
import 'package:sskcovid19/pages/login.dart';
import 'package:sskcovid19/pages/self_screening.dart';
import 'package:sskcovid19/pages/about.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();
  ProfileFileProcess profileFileProcess = new ProfileFileProcess();

  String accountName;
  String email;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('$accountName'),
            accountEmail: Text('$email'),
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(size: 40.0,),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('ศรีสะเกษสู้โควิด 19'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OperationPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('เกี่ยวกับเรา'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('ส่งพิกัดปัจจุบัน'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckinPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('ประวัติการเดินทาง'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackerPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('ประเมินความเสี่ยง'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelfScreenPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('ประวัติส่วนตัว'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('ออกจากระบบ'),
            onTap: () {
              _logoutProcess(context);
            },
          ),
        ],
      ),
    );
  }

  void _getProfile() async {
    var profile = profileFileProcess.readProfile();
    profile.then((value) {
      var profileJson = json.decode(value);
      setState(() {
        accountName = profileJson['results'][0]['first_name']+" "+profileJson['results'][0]['last_name'];
        email = profileJson['results'][0]['email'];
      });
    });
  }

  void _logoutProcess(context) async {
    // Progress Dialog
    ProgressDialog pr = new ProgressDialog(context);
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
}