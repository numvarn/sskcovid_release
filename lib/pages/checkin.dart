import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as Http;
import 'package:google_fonts/google_fonts.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/cslib/profileFileProcess.dart';
import 'package:sskcovid19/cslib/sideMenu.dart';
import 'package:sskcovid19/pages/operations.dart';

class CheckinPage extends StatefulWidget {
  CheckinPage({Key key}) : super(key: key);

  @override
  _CheckinPageState createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  //Read File
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();
  ProfileFileProcess profileFileProcess = new ProfileFileProcess();

  //Get Location by Geolocator
  Geolocator geolocator = Geolocator();
  Position userLocation;

  //Google Maps
  GoogleMapController mapController;
  LatLng _center = new LatLng(15.120674, 104.321636);

  //Progress Dialog
  ProgressDialog pr;

  //For Communicate with API
  String Token;
  int userID;

  //Style
  TextStyle style = GoogleFonts.prompt(
    fontSize: 20,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Get User Profile
    profileFileProcess.readProfile().then((profileJSON){
      final profile = json.decode(profileJSON);
      setState(() {
        userID = profile['results'][0]['id'];
      });
    });

    //Get Authen Token
    authenFileProcess.readToken().then((tokenJSON) {
      final token = json.decode(tokenJSON);

      setState(() {
        Token = token['token'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      _getLocation().then((value) {
        setState(() {
          userLocation = value;
          mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(userLocation.latitude,userLocation.longitude),15));
        });
      });
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('พิกัดที่อยู่ปัจจุบัน', style: style),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          sendLocation(context);
        },
        label: Text('Send my location'),
        icon: Icon(Icons.near_me),
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void sendLocation(context){
    //UPdate Current location
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });

    pr = new ProgressDialog(context);
    pr.style(
      message: '  Sending Location...',
      progressWidget: CircularProgressIndicator(),
    );

    pr.show();

    Map<String, String> data = {
      "account": userID.toString(),
      "latitude": userLocation.latitude.toStringAsFixed(6),
      "longitude": userLocation.longitude.toStringAsFixed(6),
      "status": '1'
    };

    //Sending Location to API
    Http.post(
      "https://ssk-covid19.herokuapp.com/api/checkedin",
      body: data,
      headers: {HttpHeaders.authorizationHeader: "Token $Token"},
    ).then((response) {
      final body = utf8.decode(response.bodyBytes);
      final resJson = json.decode(body);

      if (resJson['checkedin'] == 'successed') {
        pr.hide();
        _showAlertCheckinSuccessed(context);
      } else {
        pr.hide();
        _showAlertCheckinFail(context);
      }
    });
  }

  void _showAlertCheckinSuccessed(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("ส่งพิกัดที่อยู่ปัจจุบันเรียบร้อย"),
          content: Text("พิกัดปัจจุบันของคุณถูกรายงานเข้าระบบเรียบร้อยแล้ว"),
          actions: <Widget>[
            FlatButton(
              child: Text('รับทราบ'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OperationPage()),
                );
              },
            )
          ],
        )
    );
  }

  void _showAlertCheckinFail(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("เกิดความผิดพลาด"),
          content: Text("พิกัดปัจจุบันของคุณถูกยังไม่ถูกรายงานเข้าระบบ !!"),
          actions: <Widget>[
            FlatButton(
              child: Text('ลองอีกครั้ง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
    );
  }
}
