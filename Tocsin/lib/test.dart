import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'controller/LocationController.dart';

class Gmap extends StatefulWidget {
  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
  GoogleMapController mapController;

  LocationData _currentPosition;

  var lng, lat, loading;
  bool sitiosToggle = false;

  var sitios = [];
  Set<Marker> allMarkers = Set();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Circle> circles;

  @override
  initState() {
    _getLocation();
    loading = true;
    super.initState();
  }

  _getLocation() async {
    var location = new Location();
    try {
      _currentPosition = await location.getLocation();
      setState(() {
        lat = _currentPosition.latitude;
        lng = _currentPosition.longitude;
        loading = false;
        print(_currentPosition);
      }); //rebuild the widget after getting the current location of the user
    } on Exception {
      _currentPosition = null;
    }
    setState(() {
      circles = Set.from([
        Circle(
            circleId: CircleId("myCircle"),
            radius: 500,
            center: _createCenter(),
            fillColor: Color.fromRGBO(171, 39, 133, 0.1),
            strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
            onTap: () {
              print('circle pressed');
            })
      ]);
    });
  }

  getCrimeLocation() async{
    sitios = [];
    List locations = await GetLocation();
    if(locations.length > 0){
      setState(() {
        sitiosToggle = true;
      });
      locations.forEach((location) {
        // print(location);
        allMarkers.add(
            Marker(
              markerId: MarkerId(location['news_title']),
              draggable: false,
              // onTap: () {
              //   print('ทำแผน "เจ้ต๋อย" ฆ่าเมียใหม่ของผัวเก่า พูดก่อนยิง "อย่างนี้ฉันต้องจัดให้เธอ 1 ดอก"');
              // },
              position: LatLng(location['lat'], location['lng']),
              infoWindow: InfoWindow(title: location['news_title'], snippet: '${location['loc_details']} ${location['district']} ${location['amphur']} ${location['province']}'),
            )
        );
      });
    }
    setState(() {
      allMarkers;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: new AppBar(
            centerTitle: true,
            title: Text(
              'YOUR NEAREST STORES',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            loading == false
                ? GoogleMap(
              // circles: circles,
              mapType: MapType.normal,
              circles: circles,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 15.0,
              ),
              markers: allMarkers,
            )
                : Center(
              child: CircularProgressIndicator(),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height - 70.0),
                right: 10.0,
                child: FloatingActionButton(
                  onPressed: () {
                    getCrimeLocation();
                  },
                  mini: true,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.refresh),
                )),
          ],
        ),
      ),
    );
  }

  LatLng _createCenter() {
    return _createLatLng(lat , lng);
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}