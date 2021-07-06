import 'package:Tocsin/Component/style_bg.dart';
import 'package:Tocsin/Component/style_button.dart';
import 'package:Tocsin/controller/EmergencyController.dart';
import 'package:Tocsin/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Component/style_text.dart';
import 'Component/style_textfield.dart';

class EmerContactEditPage extends StatefulWidget{
  final selected_emer_id;
  final selected_emer_label;
  final selected_emer_tel;

  const EmerContactEditPage({Key key, this.selected_emer_id, this.selected_emer_label, this.selected_emer_tel}) : super(key: key);

  @override
  _EmerContactEditPageState createState() => _EmerContactEditPageState();
}

class _EmerContactEditPageState extends State<EmerContactEditPage>{
  TextEditingController labelController = TextEditingController();
  TextEditingController telController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    labelController.text = widget.selected_emer_label;
    telController.text = widget.selected_emer_tel;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text("แก้ไข", style: TextStyle(color: Colors.textDark),),
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
                    TextBlackNormal(text: 'แก้ไขเบอร์ฉุกเฉิน',),
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
                  var label = labelController.text;
                  var tel = telController.text;
                  var newContact;
                  if(label.isNotEmpty && tel.isNotEmpty) {
                    if(label != widget.selected_emer_label || tel != widget.selected_emer_tel){
                      setState(() {
                        loading = true;
                      });
                      newContact = await newEmergencyContact();
                      // print(newContact);
                      if (newContact != null) {
                      }
                    }
                    Navigator.pop(context, newContact);
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

    return await EditEmergencyContact(widget.selected_emer_id, label, tel);
  }

}