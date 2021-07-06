import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Tocsin/component/style_button.dart';
import 'package:Tocsin/component/style_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:Tocsin/Controller/LocationController.dart';
import 'package:Tocsin/component/custom_icons.dart';
import 'package:Tocsin/controller/UserLocationController.dart';
import 'package:Tocsin/loading.dart';
import 'package:Tocsin/src/api.dart';
import 'package:Tocsin/user_address_add.dart';
import 'package:Tocsin/user_address_add_default.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'component/style_crime_panel.dart';


const double CAMERA_ZOOM = 12.5;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932,-71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685,-122.0605916);


class CrimePage extends StatefulWidget {
  static const routeName = '/crime';

  final LocationApi api = LocationApi();

  @override
  State<StatefulWidget> createState() {
    return _CrimePageState();
  }
}

class _CrimePageState extends State<CrimePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uid;

  bool loading = true;
  bool isClicked = false;
  int clickedIndex = 0;
  String googleAPIKey = "AIzaSyBK6U98a7IoynZjrOPz6Riwtfhhp-368GE";
  String searchAddress;
  TextEditingController searchAddressController = TextEditingController();

  List _myLocation = [];
  List _crimeLists = [];
  List _crimeNearbyLists = [];
  List _distanceNearbyLists = [];
  List<Widget> _myLocationBuilder = [];
  List<Marker> allMarkers = [];
  List<Marker> nearbyMarkers = [];
  List<LatLng> polylineCoordinates = [];

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  LocationData _currentPosition;
  LocationData destinationLocation;
  Location location;
  LocationResult _pickedLocation;

  Set<Circle> circles;

  final PanelController _panelController = new PanelController();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  CarouselController buttonCarouselController = CarouselController();

  var lng, lat;

  BitmapDescriptor markerIcon;

  Future _trackingMe() async {
    final GoogleMapController controller = await _controller.future;
    await _getLocation();
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
            zoom: CAMERA_ZOOM,
        ))
      );
      _setCircle();
      getCrimeNearby();
      _panelController.close();
    });
  }

  _setCircle() async {
    circles = await Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: 5000,
          center: _createCenter(),
          fillColor: Color.fromRGBO(0, 165, 255, 0.1),
          strokeColor: Color.fromRGBO(0, 165, 255, 0.5),
          onTap: () {
            print('circle pressed');
          })
    ]);
  }

  _getLocation() async {
    var location = new Location();
    try {
      _currentPosition = await location.getLocation();
      setState(() {
        lat = _currentPosition.latitude;
        lng = _currentPosition.longitude;
        _setCircle();
      }); //rebuild the widget after getting the current location of the user
    } on Exception {
      _currentPosition = null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        target: SOURCE_LOCATION
    );
    if (_currentPosition != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(_currentPosition.latitude,
              _currentPosition.longitude),
          zoom: CAMERA_ZOOM,
      );
    }
    Size size = MediaQuery.of(context).size;
    BorderRadius radius = BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40));
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/tocsin_typo.png', height: 25,),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location, color: Colors.primary, size: 24,),
            onPressed: _trackingMe,
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _trackingMe,
      //   child: Icon(Icons.my_location),
      // ),
      body: SlidingUpPanel(
        // backdropEnabled: true,
        backdropOpacity: 0,
        maxHeight: ((130*(nearbyMarkers.length.toDouble()))+40) > 400 ? 400 : ((130*(nearbyMarkers.length.toDouble()))+40),
        minHeight: isClicked ? 200 : 100,
        renderPanelSheet: true,
        controller: _panelController,
        borderRadius: radius,
        header: Container(
          width: size.width,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.white
          ),
          child: Positioned(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: size.width*0.2,
              height: 5,
              color: Colors.black12,
            ),
          ),
        ),
        panel: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return;
          },
          child: Container(
            child: ListView.builder(
              padding: EdgeInsets.only(top: size.width*0.07+20),
              itemCount: isClicked ? 1 : nearbyMarkers.length,
              itemBuilder: (context, index){
                return isClicked ? CrimeNearbyDetails(
                  title: nearbyMarkers[clickedIndex].infoWindow.title,
                  createdAt: DateFormat( "dd MMMM yyyy  เวลา HH:mm น.", 'th').format(_crimeNearbyLists[clickedIndex]['created_at']).toString(),
                  description: _crimeNearbyLists[clickedIndex]['news_details'],
                  address: nearbyMarkers[clickedIndex].infoWindow.snippet,
                  onPressed: () async {
                    await _goToMarker(_crimeNearbyLists[clickedIndex]['lat'], _crimeNearbyLists[clickedIndex]['lng']);
                  },
                ) : CrimeNearbyTile(
                  title: nearbyMarkers[index].infoWindow.title,
                  distance: _distanceNearbyLists[index],
                  address: nearbyMarkers[index].infoWindow.snippet,
                  onPressed: () async {
                    await _goToMarker(_crimeNearbyLists[index]['lat'], _crimeNearbyLists[index]['lng']);
                    // print(index);
                    isClicked = true;
                    clickedIndex = index;
                  },
                  // onTap: (){
                  //   setState(() {
                  //     isClicked = true;
                  //     clickedIndex = index;
                  //   });
                  // }
                  // distance: distanceCal(LatLng(lat, lng), nearbyMarkers[index].position,),
                );
              },
            ),
          ),
        ),
        collapsed: Container(
          width: size.width,
          height: size.height*0.3,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: Colors.white
          ),
          child: Column(
            children: <Widget>[
              Positioned(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: size.width*0.2,
                  height: 5,
                  color: Colors.black12,
                ),
              ),
              isClicked ?
              CrimeCollapsed(
                title: nearbyMarkers[clickedIndex].infoWindow.title,
                // createdAt: DateFormat( "dd MMMM yyyy  เวลา HH:mm น.", 'th').format(_crimeNearbyLists[index]['created_at']).toString(),
                distance: _distanceNearbyLists[clickedIndex],
                address: nearbyMarkers[clickedIndex].infoWindow.snippet,
                directPress: () async {
                  await _goToMarker(_crimeNearbyLists[clickedIndex]['lat'], _crimeNearbyLists[clickedIndex]['lng']);
                  isClicked = true;
                  clickedIndex = clickedIndex;
                },
              )
              // SubTitleHighlight(text: nearbyMarkers[clickedIndex].infoWindow.title,)
              : SubTitleHighlight(text: nearbyMarkers.length > 0 ? 'พบ ${nearbyMarkers.length} สถานที่เสี่ยงใกล้คุณ' : 'ไม่พบเหตุร้ายใกล้คุณ',)
            ],
          ),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  circles: circles,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    //   target: LatLng(13.756096, 100.432069),
                    target: LatLng(lat, lng),
                    zoom: CAMERA_ZOOM,

                  ),
                  markers: Set.from(nearbyMarkers),
                  // onMapCreated: onMapCreated,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },

                  // myLocationEnabled: true,
                  // compassEnabled: true,
                  // tiltGesturesEnabled: false,
                  // // markers: _markers,
                  // polylines: _polylines,
                  // mapType: MapType.normal,
                  // initialCameraPosition: initialCameraPosition,
                  // onMapCreated: (GoogleMapController controller) {
                  //   _controller.complete(controller);
                  //   showPinsOnMap();
                  // }


                ),
                Positioned(
                  top: 10.0,
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                  child: Column(
                    children: <Widget>[
                      WhiteButton(
                        text: _pickedLocation != null ? _pickedLocation.address : "ค้นหาสถานที่",
                        // onPressSuff: searchAndNavigate,
                        icon: Icons.search,
                        press: () async {
                          LocationResult result = await showLocationPicker(
                            context, googleAPIKey,
                            initialCenter: LatLng(lat, lng),
                            myLocationButtonEnabled: true,
                          );
                          print("result = $result");

                          final GoogleMapController controller = await _controller.future;
                          setState((){
                            _pickedLocation = result;
                            lat = _pickedLocation.latLng.latitude;
                            lng = _pickedLocation.latLng.longitude;
                            controller.animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(lat, lng),
                                  zoom: CAMERA_ZOOM,
                                ))
                            );
                            _setCircle();
                            getCrimeNearby();
                            _panelController.close();
                          });
                        //   Prediction p = await PlacesAutocomplete.show(
                        //     context: context,
                        //     apiKey: "AIzaSyAIBeQYaZlb5pMZZ8qia-J3ujaa01OSSp4",
                        //     language: "th",
                        //     components: [
                        //       Component(Component.country, "th")
                        //     ]
                        //   );
                        },
                      ),
                      // builderMyLocation(),
                      Row(
                        children: <Widget>[
                          MyAddressButton(
                            icon: CustomIcons.home,
                            text: "บ้าน",
                            press: () async {
                              var home = _myLocation.where((e) => e['label'] == '${uid}_home').first;
                              print('home : '+home.toString());
                              if(home != null){
                                setLocation(home);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => NewAddressDefaultPage(isHome: true,))
                                );
                              }
                            },
                          ),
                          MyAddressButton(
                            icon: CustomIcons.work,
                            text: "ที่ทำงาน",
                            press: () async {
                              var work = _myLocation.where((e) => e['label'] == '${uid}_work').first;
                              if(work != null){
                                setLocation(work);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => NewAddressDefaultPage(isHome: false))
                                );
                              }
                            },
                          ),
                          MyAddressButton(
                            icon: Icons.add,
                            text: "เพิ่ม",
                            press: addLocation,
                          ),
                        ],
                      ),
                      // CarouselSlider(
                      //   options: CarouselOptions(
                      //     height: 37.0,
                      //     aspectRatio: 5.0,
                      //     enlargeCenterPage: false,
                      //     enableInfiniteScroll: false,
                      //     initialPage: 2,
                      //     viewportFraction: 0.4,
                      //   ),
                      //   items: customLocations,
                      // )
                    ],
                  ),
                ),
              ],
            )
        ),
      )
    );
  }


  LatLng _createCenter() {return _createLatLng(lat , lng);}
  LatLng _createLatLng(double lat, double lng) {return LatLng(lat, lng);}
  void onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
      print('search for location success!');
    });
  }

  setLocation(location) async {
    final GoogleMapController controller = await _controller.future;
    print('location : '+location.toString());
    setState(() {
      lat = location['lat'];
      lng = location['long'];
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: CAMERA_ZOOM,
          ))
      );
      _setCircle();
      getCrimeNearby();
      _panelController.close();
    });
  }

  _goToMarker(double lat, double long) async {
    print('_getCrimeLatLng');
    final GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: CAMERA_ZOOM,
          ))
      );
      _panelController.close();
      // if(SlidingUpPanelStatus.expanded==_panelController.status){
      //   _panelController.collapse();
      // }else{
      //   _panelController.expand();
      // }
    });
  }

  getData() async {
    await GetUid();
    await getMyLocation();
    setState(() {
      loading = false;
    });
    await getCrimeLocation();
    await getCrimeNearby();
  }

  getMyLocation() async {
    List myLocation = await GetUserLocation(uid);
    if(myLocation.length > 0){
      setState(() {
        _myLocation = myLocation;
        showCustomLocation();
        loading = false;
      });
    }
  }


  List<Widget> customLocations;

  showCustomLocation() {
    customLocations = _myLocation.map((item) {
      if(item['label'] == '${uid}_home'){
        return MyAddressButton(
          icon: CustomIcons.home,
          text: "บ้าน",
          press: () async {
            var home = _myLocation.where((e) => e['label'] == '${uid}_home').first;
            if(home != null){
              setLocation(home);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewAddressDefaultPage(isHome: true,))
              );
            }
          },
        );
      }
      else if(item['label'] == '${uid}_work'){
        return MyAddressButton(
          icon: CustomIcons.work,
          text: "ที่ทำงาน",
          press: () async {
            var work = _myLocation.where((e) => e['label'] == '${uid}_work').first;
            if(work != null){
              setLocation(work);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewAddressDefaultPage(isHome: false))
              );
            }
          },
        );
      }
      else {
        return MyAddressButton(
          icon: CustomIcons.location,
          text: item['label'],
          press: () async {
            if(item != null){
              setLocation(item);
            }
          },
        );
      }
      return MyAddressButton(
          icon: Icons.add,
          text: "เพิ่ม",
          press: addLocation,
      );
    }).toList();
    setState(() {
      loading = false;
    });
    return customLocations;
  }




  getCrimeLocation() async{
    final icon = await getBitmapDescriptorFromAssetBytes('assets/icons/crime_marker_01.png', 70);

    List locations = await GetLocation();
    if(locations.length > 0){
      print(location.toString());
      locations.forEach((location) {
        allMarkers.add(
          Marker(
            markerId: MarkerId(location['_id'].toString()),
            draggable: false,
            position: LatLng(location['lat'], location['lng']),
            infoWindow: InfoWindow(title: location['news_title'], snippet: '${location['loc_details']} ${location['district']} ${location['amphur']} ${location['province']} ${location['zipcode']}'),
            onTap: (){
              print(location['_id'].toString());
            },
            icon: icon,
          )
        );
      });
      setState(() {
        _crimeLists = locations;
        allMarkers;
      });
      print('crimeLists : ' + _crimeLists.toString());
    }
  }

  getCrimeNearby() {
    isClicked = false;
    nearbyMarkers = [];
    _crimeNearbyLists = [];
    _distanceNearbyLists = [];
    allMarkers.forEach((marker) async {
      final markerLocation = mp.LatLng(marker.position.latitude, marker.position.longitude);
      final myLocation = mp.LatLng(lat, lng);
      final distance = (mp.SphericalUtil.computeDistanceBetween(myLocation, markerLocation)) / 1000;
      final crimeList = _crimeLists.where((e) => e['_id'].toString() == marker.markerId.value.toString()).first;

      if (distance < 5) {
        nearbyMarkers.add(marker);
        _crimeNearbyLists.add(crimeList);
        _distanceNearbyLists.add(distance);
      }
    });
    setState(() {
      nearbyMarkers;
      _crimeNearbyLists;
      _distanceNearbyLists;
    });
  }

  builderMyLocation() {
    return Row(
      children: <Widget>[
        MyAddressButton(
          icon: CustomIcons.home,
          text: "Home",
          press: () async {
            var home = _myLocation.where((e) => e['label'] == '${uid}_home');
            if(home != null){
              setLocation(home);
            }
          },
        ),
        MyAddressButton(
          icon: CustomIcons.work,
          text: "Work",
          press: () async {
            var work = _myLocation.where((e) => e['label'] == '${uid}_work');
            if(work != null){
              setLocation(work);
            }
          },
        ),
        _builderCustomLocation(),
        MyAddressButton(
          icon: Icons.add,
          text: "Add",
          press: addLocation,
        ),
      ],
    );

    _myLocationBuilder.add(
      MyAddressButton(
        icon: Icons.add,
        text: "Add",
        press: addLocation,
      )
    );
  }

  _builderCustomLocation() {
    var locations = _myLocation.where((e) => (e['label'] != '${uid}_home' && e['label'] != '${uid}_work'));
    locations.forEach((e) {
      return MyAddressButton(
        icon: CustomIcons.location,
        text: e['label'],
        press: () {setLocation(e);},
      );
    });
  }


  GetUid () async {
    FirebaseUser user = await _auth.currentUser();
    setState(() {
      uid = user.uid;
    });
  }

  addLocation() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewAddressPage(uid: uid,))
    );
    if (result != null) {
      setState(() {
        loading = true;
        getMyLocation();
      });
    }
  }

  distanceCal(LatLng start, LatLng destination) async {
    double distanceInMeters = await Geolocator().distanceBetween(
      start.latitude,
      start.longitude,
      destination.latitude,
      destination.longitude,
    );
    return distanceInMeters.toString();
  }

















  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }


}