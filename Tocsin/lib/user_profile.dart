import 'dart:async';
import 'package:Tocsin/Component/style_bg.dart';
import 'package:Tocsin/Component/style_button.dart';
import 'package:Tocsin/loading.dart';
import 'package:Tocsin/user_profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Component/style_text.dart';
import 'Controller/UserController.dart';

class UserProfilePage extends StatefulWidget{
  final uid;
  const UserProfilePage({
    Key key,
    this.uid,
  }) : super(key: key);

  // String get uid => null;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>{
  DateFormat _dateFormat;
  var profile = {
    'firstname': '',
    'lastname': '',
    'birthdate': DateTime.now(),
    'gender': 'loading..',
    'blood': 'loading..',
    'weight': 'loading..',
    'height': 'loading..',
  };
  var isUpdated = false;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateFormat = DateFormat.yMMMd();
    // if(!isUpdated){
    //   profile = widget.profile;
    //   print(profile);
    //   print(isUpdated);
    // }
    GetUid();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text("ข้อมูลผู้ใช้", style: TextStyle(color: Colors.textDark),),
      ),
      body: Column(
        children: <Widget>[
          Container(child: Column(
            children: <Widget>[
              SizedBox(height: size.height*0.04,),
              Positioned(
                child: Image.asset("assets/icons/icn_Information.png", height: size.height*0.11, width: size.height*0.11),
              ),
              SizedBox(height: size.height*0.01,),
              TextBlackNormal(text: 'ข้อมูลส่วนตัว',),
              SizedBox(height: size.height*0.03,),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(right: size.width*0.04),
            padding: EdgeInsets.only(top: size.height*0.005, bottom: size.height*0.005),
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
              RowProfile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SubTitleBlack(text: profile['firstname'].toString() + ' ' + profile['lastname'],),
                    SizedBox(height: size.height*0.008,),
                    TextBlackLight(text: _dateFormat.format(profile['birthdate']).toString()),
                  ],
                ),
              ),
              Divider(color: Colors.secondary, height: 1,),
              RowProfile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextSecondaryLight(text: 'เพศ',),
                    SizedBox(height: size.height*0.008,),
                    TextBlackNormal(text: profile['gender']),
                  ],
                ),
              ),
              Divider(color: Colors.secondary, height: 1,),
              RowProfile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextSecondaryLight(text: 'กลุ่มเลือด',),
                    SizedBox(height: size.height*0.008,),
                    TextBlackNormal(text: profile['blood']),
                  ],
                ),
              ),
              Divider(color: Colors.secondary, height: 1,),
              RowProfile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextSecondaryLight(text: 'น้ำหนัก',),
                    SizedBox(height: size.height*0.008,),
                    TextBlackNormal(text: profile['weight'] == '' ? '' : profile['weight'].toString() + ' kg'),
                  ],
                ),
              ),
              Divider(color: Colors.secondary, height: 1,),
              RowProfile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextSecondaryLight(text: 'ส่วนสูง',),
                    SizedBox(height: size.height*0.008,),
                    TextBlackNormal(text: profile['height'] == '' ? '' : profile['height'].toString() + ' cm'),
                  ],
                ),
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.08, vertical: 25),
            child: SecondaryButton(
              text: " แก้ไขข้อมูล",
              icon: Icons.edit,
              press: (){
                _awaitReturnValueFromEditUserProfile(context);
              },
            ),
          ),
        ],
      ),
    );
  }



  void _awaitReturnValueFromEditUserProfile(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileEditPage(profile: profile, uid: widget.uid),
        )
    );

    if(result != null) {
      setState(() {
        profile = result;
        print('setState : Profile');
      });
    }
  }

  Future<void> GetUid () async {
    var profileStr = await GetUserProfile(widget.uid);
    setState(() {
      profile = profileStr;
      loading = false;
    });
  }

}