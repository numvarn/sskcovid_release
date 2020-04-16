import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sskcovid19/cslib/authenFileProcess.dart';
import 'package:sskcovid19/cslib/sideMenu.dart';
import 'package:sskcovid19/pages/checkedin_tracker_maps.dart';

class TrackerPage extends StatefulWidget {
  TrackerPage({Key key}) : super(key: key);

  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  TextStyle style = GoogleFonts.prompt(
    fontSize: 20,
  );

  TextStyle titleStyle = GoogleFonts.prompt(
    fontSize: 16,
  );

  TextStyle subTitleStyle = GoogleFonts.prompt(
    fontSize: 12,
  );

  //Read config file
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();

  String token;
  bool loadCheck = false;
  var jsonData;
  List<CheckedInHistory> dataList = [];

  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  Future<String> _getCheckedIn() async {
    if (token == null) {
      authenFileProcess.readToken().then((val) {
        final jsonToken = json.decode(val);
        setState(() {
          token = jsonToken['token'];
        });
      });
    }

    if (token != null && loadCheck == false) {
      //Prevent Next Load
      loadCheck = true;

      var response = await Http.get(
          "https://ssk-covid19.herokuapp.com/get/mycheckedin",
          headers: {HttpHeaders.authorizationHeader: "Token $token"}
          );

      jsonData = json.decode(utf8.decode(response.bodyBytes));

      for (var u in jsonData['results']) {
        //Convert DateTime
        var dateCreate = DateTime.parse(u['date_created']).toLocal();

        if(u['route'] == null) {
          u['route'] = "Unnamed Road";
        }

        CheckedInHistory history = CheckedInHistory(
            u['account'],
            double.parse(u['latitude']),
            double.parse(u['longitude']), u['status'],
            u['route'],
            u['subdistrict'],
            u['district'],
            u['province'],
            u['country'],
            u['postcode'],
            dateFormat.format(dateCreate)
        );
        dataList.add(history);
      }
    }

    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text(
            'ประวัติการเดินทาง',
            style: style,
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: new FutureBuilder(
            future: _getCheckedIn(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: new InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackerMapsPage(),
                                settings: RouteSettings(
                                  arguments: dataList[index],
                                ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: FlutterLogo(),
                          title: Text(
                              '${dataList[index].route}, '
                                  '${dataList[index].subDistrict}, \n'
                                  '${dataList[index].district}, \n'
                                  '${dataList[index].province}, '
                                  '${dataList[index].postcode}',
                            style: titleStyle,
                          ),
                          subtitle: Text(
                              '${dataList[index].date} \n'
                                  '[${dataList[index].latitude}, '
                                  '${dataList[index].longitude}]',
                            style: subTitleStyle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        ),
    );
  }
}

class CheckedInHistory {
  int account;
  double latitude;
  double longitude;
  int status;
  String route;
  String subDistrict;
  String district;
  String province;
  String country;
  String postcode;
  String date;

  CheckedInHistory(this.account, this.latitude, this.longitude, this.status, this.route, this.subDistrict, this.district, this.province, this.country, this.postcode, this.date);
}