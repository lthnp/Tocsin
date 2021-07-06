import 'dart:convert';

import 'package:Tocsin/component/custom_icons.dart';
import 'package:Tocsin/component/style_user_contact.dart';
import 'package:Tocsin/controller/UserLocationController.dart';
import 'package:Tocsin/loading.dart';
import 'package:Tocsin/models/user_location.dart';
import 'package:Tocsin/user_address_add.dart';
import 'package:Tocsin/user_address_add_default.dart';
import 'package:Tocsin/user_address_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'component/style_button.dart';
import 'component/style_text.dart';
import 'models/emer_popup.dart';

class UserAddressPage extends StatefulWidget{
  final uid;
  const UserAddressPage({Key key, this.uid}) : super(key: key);

  @override
  _UserAddressPageState createState() => _UserAddressPageState();
}

class _UserAddressPageState extends State<UserAddressPage>{
  bool loading = true;
  int _silverCount = 0;

  List _myLocations = [];
  var _myHome;
  var _myWork;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ที่อยู่", style: TextStyle(color: Colors.textDark),),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addLocation,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: size.height*0.05,),
                  Container(
                    margin: EdgeInsets.only(right: size.width*0.04),
                    padding: EdgeInsets.only(bottom: size.height*0.005),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(topLeft: Radius.zero, bottomLeft: Radius.zero, topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
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
                          AddressList(
                            isHome: true,
                            icon: CustomIcons.home,
                            label: 'บ้าน',
                            address: (_myHome != null ? _myHome['address'] : ''),
                            isNull: (_myHome != null ? true : false),
                            onTap: (){_myHome != null ? onTap(_myHome) : onTapNull(true);},
                            onPress: (String choice){
                              _onPress(choice, _myHome);
                            },
                          ),
                          AddressList(
                            icon: CustomIcons.work,
                            label: 'ที่ทำงาน',
                            address: (_myWork != null ? _myWork['address'] : ''),
                            isNull: (_myWork != null ? true : false),
                            onTap: (){_myWork != null ? onTap(_myWork) : onTapNull(false);},
                            onPress: (String choice){
                              _onPress(choice, _myWork);
                            },
                          ),
                          Container(
                            child: Column(children: customLocations),
                          ),

                        ]
                    ),
                  ),
                  SizedBox(height: size.height*0.05,),
                ],
              )
            ])
          ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //         (BuildContext context, int index) {
          //       return showMyLocation(index);
          //     },
          //     childCount: _myLocations.length+1,
          //   ),
          // ),
        ],
      ),
    );
  }

  onTap(address) async {
    if (address != null){
      final location = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditAddressPage(uid: widget.uid, address: address,))
      );
      if(location != null){
        await getMyLocation();
      }
    }
  }

  onTapNull(bool isHome) async {
    final location = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewAddressDefaultPage(uid: widget.uid, isHome: isHome,))
    );
    if(location != null){
      await getMyLocation();
    }
  }

  getMyLocation() async{
    List myLocations = await GetUserLocation(widget.uid);
    _myLocations = [];
    if(myLocations.length > 0){
      setState(() {
        myLocations.forEach((e){
          if(e['label'] == '${widget.uid}_home'){
            _myHome = e;
          }
          else if(e['label'] == '${widget.uid}_work'){
            _myWork = e;
          }
          else {
            _myLocations.add(e);
          }
        });
        print('_myLocations : ' + _myLocations.toString());
        loading = false;
        showCustomLocation();
      });
    }
  }

  addLocation() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewAddressPage(uid: widget.uid,))
    );
    if (result != null) {
      setState(() {
        loading = true;
        getMyLocation();
      });
    }
  }

  List<Widget> customLocations;

  showCustomLocation() {
    customLocations = _myLocations.map((item) {
      return AddressList(
        icon: CustomIcons.location,
        label: item['label'],
        address: item['address'],
        onTap: (){onTap(item);},
        onPress: (String choice){
          _onPress(choice, item);
        },
      );
    }).toList();
    setState(() {
      loading = false;
    });
    return customLocations;
  }



  void _onPress (String choice, selectedLocation) async {
    if(choice == EmerPopup.delete){
      print('selectedLocation : ' + selectedLocation.toString());
      print('delete ' + selectedLocation['_id'].toString());
      showAlertDialog(context, selectedLocation);
    }
  }


  Widget showMyLocation(int index) {
    index -= 1;
    if(_silverCount == 0){
      _silverCount++;
      return Column(
          children: <Widget>[
            AddressList(
              icon: CustomIcons.home,
              label: 'บ้าน',
              address: (_myHome != null ? _myHome['address'] : ''),
              isNull: (_myHome != null ? true : false),
              onTap: (){_myHome != null ? onTap(_myHome) : onTapNull(true);},
            ),
            Divider(color: Colors.secondary, height: 1,),
            AddressList(
              icon: CustomIcons.work,
              label: 'ที่ทำงาน',
              address: (_myWork != null ? _myWork['address'] : ''),
              isNull: (_myWork != null ? true : false),
              onTap: (){_myWork != null ? onTap(_myWork) : onTapNull(false);},
            ),
          ]
      );
    }
    return Column(
      children: [
        Divider(color: Colors.secondary, height: 1,),
        AddressList(
          icon: CustomIcons.work,
          label: _myLocations[index]['label'],
          address: _myLocations[index]['address'],
          onTap: (){onTap(_myLocations[index]);},
        ),
      ],
    );
  }





  showAlertDialog(BuildContext context, selectedLocation) {
    // set up the buttons
    Widget cancelButton = AlertButton(
      text: "ยกเลิก",
      press:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = AlertButton(
      text: "ลบ",
      textColor: Colors.primary,
      outlinecolor: Colors.primary,
      press:  () async {
        setState(() {
          loading = true;
          Navigator.of(context, rootNavigator: true).pop('dialog');
        });
        await DeleteUserLocation(selectedLocation['_id']);
        getMyLocation();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันการลบ ?"),
      content: ParagraphText(text: (selectedLocation['label'] != '${widget.uid}_home' && selectedLocation['label'] != '${widget.uid}_work') ?
      "ต้องการลบที่อยู่ \"${selectedLocation['label']}\" ใช่หรือไม่?" :
      "ต้องการลบที่อยู่ \"${selectedLocation['label'] != '${widget.uid}_home' ? 'ที่ทำงาน' : 'บ้าน'}\" ใช่หรือไม่?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}