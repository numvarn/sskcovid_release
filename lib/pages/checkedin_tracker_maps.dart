import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sskcovid19/pages/checkedin_tracker.dart';

class TrackerMapsPage extends StatefulWidget {

  TrackerMapsPage({Key key}) : super(key: key);

  @override
  _TrackerMapsPageState createState() => _TrackerMapsPageState();
}

class _TrackerMapsPageState extends State<TrackerMapsPage> {
  //Style
  TextStyle style = GoogleFonts.prompt(
    fontSize: 20,
  );

  TextStyle titleStyle = GoogleFonts.prompt(
    fontSize: 16,
  );

  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  //Google Maps
  GoogleMapController mapController;
  LatLng _center;

  //Set google maps marker;
  Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    //Get value from previous page
    CheckedInHistory history = ModalRoute.of(context).settings.arguments;

    //Set Google Maps Center
    _center = new LatLng(history.latitude, history.longitude);

    //Set Google Maps Marker
    final marker = new Marker(
      markerId: MarkerId('Hello'),
      position: LatLng(history.latitude, history.longitude),
      infoWindow: InfoWindow(
        title: history.route+", "+history.subDistrict+", "+history.district+", "+history.province+", "+history.postcode,
        snippet: history.date,
      ),
    );

    _markers["0"] = marker;

    return Scaffold(
      appBar: AppBar(
        title: Text('ตำแหน่งที่เคยเดินทาง', style: style),
      ),
      body: Column(
          children: [
            Container(
              child: Card(
                elevation: 2.0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    markers: _markers.values.toSet(),
                    rotateGesturesEnabled: false,
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                height: MediaQuery.of(context).size.height * 0.35,
                child: Card(
                  elevation: 1,
                  child: Container(
                    child: ListTile(
                      leading: FlutterLogo(),
                      title: Text(""
                          "ถนน ${history.route}\n"
                          "${history.subDistrict}\n"
                          "${history.district}\n"
                          "จังหวัด ${history.province}\n\n"
                          "เวลา ${history.date}\n"
                          "พิกัด ${history.latitude}, ${history.longitude}",
                      style: titleStyle),
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }
}
