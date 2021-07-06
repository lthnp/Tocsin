import 'package:Tocsin/Component/style_bg.dart';
import 'package:Tocsin/component/custom_icons.dart';
import 'package:Tocsin/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Component/style_text.dart';
import 'Component/style_textfield.dart';
import 'Controller/EmergencyController.dart';
import 'component/style_button.dart';
import 'controller/UserLocationController.dart';

class NewAddressPage extends StatefulWidget{
  final uid;

  const NewAddressPage({Key key, this.uid}) : super(key: key);

  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage>{
  TextEditingController _labelController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  LocationResult _pickedLocation;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("เพิ่มที่อยู่", style: TextStyle(color: Colors.textDark),),
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
                  ]),
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
                        children: <Widget>[
                          TextSecondaryLight(text: 'ชื่อที่อยู่',),
                          NormalTextField(
                            hintText: 'ex. บ้าน, บริษัท',
                            controller: _labelController,
                          ),
                          TextBlackNormal(text: _locationController.text,),
                          SizedBox(height: size.height*0.02,),
                          WhiteButton(
                            icon: CustomIcons.location,
                            text: ' เลือกที่อยู่',
                            press: () async {
                              LocationResult result = await showLocationPicker(
                                context, 'AIzaSyBK6U98a7IoynZjrOPz6Riwtfhhp-368GE',
                                initialCenter: LatLng(31.1975844, 29.9598339),
                                myLocationButtonEnabled: true,
                                layersButtonEnabled: true,
                              );
                              setState((){
                                _pickedLocation = result;
                                _locationController.text = _pickedLocation.address.toString();
                              });
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
                  if(_labelController.text.isNotEmpty && _locationController.text.isNotEmpty) {
                    setState(() {
                      loading = true;
                    });
                    var location = await addLocation();
                    if (location != null) {
                      Navigator.pop(context, location);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  addLocation () async {
    String label = _labelController.text.trim();
    double lat = _pickedLocation.latLng.latitude;
    double long = _pickedLocation.latLng.longitude;
    String address = _pickedLocation.address;

    return await AddUserLocation(widget.uid, label, lat, long, address);
  }

}