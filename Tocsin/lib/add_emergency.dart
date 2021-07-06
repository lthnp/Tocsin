import 'package:Tocsin/Component/style_bg.dart';
import 'package:Tocsin/Component/style_button.dart';
import 'package:Tocsin/loading.dart';
import 'package:Tocsin/models/emergency_contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Component/datepicker.dart';
import 'Component/style_text.dart';
import 'Component/style_textfield.dart';
import 'Controller/EmergencyController.dart';
import 'Controller/UserController.dart';

class EmerContactAddPage extends StatefulWidget{

  @override
  _EmerContactAddPageState createState() => _EmerContactAddPageState();
}

class _EmerContactAddPageState extends State<EmerContactAddPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController labelController = TextEditingController();
  TextEditingController telController = TextEditingController();

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
      backgroundColor: Colors.bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text("เบอร์ฉุกเฉินใหม่", style: TextStyle(color: Colors.textDark),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
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
                    TextBlackNormal(text: 'เพิ่มเบอร์ฉุกเฉิน',),
                    SizedBox(height: size.height*0.03,),
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
                          TextSecondaryLight(text: 'ชื่อเบอร์ติดต่อ',),
                          NormalTextField(
                            hintText: 'ex. ก้อย, ต้น, กร',
                            controller: labelController,
                          ),
                          TextSecondaryLight(text: 'เบอร์ติดต่อ',),
                          NormalTextField(
                            hintText: '0123456789',
                            controller: telController,
                            inputType: TextInputType.phone,
                          ),
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
                  if(labelController.text.isNotEmpty && telController.text.isNotEmpty) {
                    setState(() {
                      loading = true;
                    });
                    var newContact = await newEmergencyContact();
                    print(newContact);
                    if (newContact[0]) {
                      Navigator.pop(context, newContact);
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


  newEmergencyContact () async {
    String label = labelController.text.trim();
    String tel = telController.text.trim();

    FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    await AddEmergencyContact(uid, label, tel);
    return [true, label, tel];
  }

}