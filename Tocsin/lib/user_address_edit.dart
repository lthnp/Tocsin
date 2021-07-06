import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'component/custom_icons.dart';
import 'component/style_bg.dart';
import 'component/style_button.dart';
import 'component/style_text.dart';
import 'component/style_textfield.dart';
import 'controller/UserLocationController.dart';
import 'loading.dart';

class EditAddressPage extends StatefulWidget {
  final uid;
  final address;

  const EditAddressPage({Key key, this.uid, this.address}) : super(key: key);
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _labelController = TextEditingController();

  LocationResult _pickedLocation;
  bool loading = false;
  double lat, long;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationController.text = widget.address['address'];
    _labelController.text = widget.address['label'];
    lat = widget.address['lat'];
    long = widget.address['long'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("แก้ไขที่อยู่", style: TextStyle(color: Colors.textDark),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: size.width*0.08),
              child: Column(
                children: <Widget>[
                  SizedBox(height: size.height*0.04,),
                  (widget.address['label'] == '${widget.uid}_home' || widget.address['label'] == '${widget.uid}_work') ?
                  Column(
                    children: <Widget>[
                      TextBlackNormal(text: (widget.address['label'] == '${widget.uid}_home') ? 'บ้าน' : 'ที่ทำงาน',),
                      SizedBox(height: size.height*0.03,),
                    ],
                  ) : SizedBox(height: 0,),
                ]
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: size.height*0.005, bottom: size.height*0.005),
              decoration: new BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                  children: <Widget>[
                    BgEdit(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (widget.address['label'] == '${widget.uid}_home' || widget.address['label'] == '${widget.uid}_work') ?
                          SizedBox(height: 0,) :
                          Column(
                            children: <Widget>[
                              TextSecondaryLight(text: 'ชื่อที่อยู่',),
                              NormalTextField(
                                hintText: 'ex. บ้าน, บริษัท',
                                controller: _labelController,
                              ),
                            ],
                          ),
                          TextBlackNormal(text: _locationController.text,),
                          SizedBox(height: size.height*0.02,),
                          WhiteButton(
                            icon: CustomIcons.location,
                            text: ' เลือกที่อยู่',
                            press: () async {
                              LocationResult result = await showLocationPicker(
                                context, 'AIzaSyAIBeQYaZlb5pMZZ8qia-J3ujaa01OSSp4',
                                initialCenter: LatLng(lat, long),
                                myLocationButtonEnabled: true,
                                automaticallyAnimateToCurrentLocation: false
                              );
                              if(result != null){
                                setState((){
                                  _pickedLocation = result;
                                  _locationController.text = _pickedLocation.address.toString();
                                });
                              }
                            },
                          ),
                          SizedBox(height: size.height*0.03,),
                        ],
                      ),
                    ),
                  ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.08, vertical: 25),
              child: PrimaryButton(
                text: "ยืนยัน",
                press: () async {
                  var location;
                  if(_locationController.text != null && _locationController.text != widget.address['address']) {
                    setState(() {
                      loading = true;
                    });
                    location = await addLocation();
                    print(location);
                  }
                  Navigator.pop(context, location);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  addLocation () async {
    String label;
    double lat = _pickedLocation.latLng.latitude;
    double long = _pickedLocation.latLng.longitude;
    String address = _pickedLocation.address;

    if(widget.address['label'] == '${widget.uid}_home' || widget.address['label'] == '${widget.uid}_work')
      label = widget.address['label'];
    else
      label = _labelController.text.trim();

    return await EditUserLocation(widget.address['_id'], label, lat, long, address);
  }
}
