import 'package:Tocsin/Component/soscontact.dart';
import 'package:Tocsin/Component/style_button.dart';
import 'package:Tocsin/Component/style_text.dart';
import 'package:Tocsin/add_emergency.dart';
import 'package:Tocsin/loading.dart';
import 'package:Tocsin/models/emergency_contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Component/style_bg.dart';
import 'Controller/EmergencyController.dart';

class SosPage extends StatefulWidget{
  @override
  _SosPageState createState() => _SosPageState();
}

class _SosPageState extends State<SosPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<EmergencyContactModel> contactsList = List();
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmergencyContacts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.bg,
      appBar: AppBar(
        title: Image.asset('assets/tocsin_typo.png', height: 25,),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[Stack(
                children: <Widget>[
                  Positioned(
                    child: CustomPaint(
                      painter: CurvePainterTop(),
                    ),
                    height: size.height,
                    width: size.width,
                  ),
                  Container(
                    width: size.width,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: size.height*0.03,),
                        TitleTextWhite(text: "ขอความช่วยเหลือ",),
                        SizedBox(height: size.height*0.02,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Positioned(
                              child: Image.asset("assets/icons/icn_police.png", height: size.height*0.2, width: size.height*0.2,),
                            ),
                            Positioned(
                              // right: 20,
                              child: FlatButton(
                                child: Image.asset("assets/icons/btn_call.png", height: size.height*0.1, width: size.height*0.1),
                                // color: Colors.bg,
                                padding: EdgeInsets.all(15),
                                shape: CircleBorder(),
                                onPressed: (){
                                  launch(('tel://191'));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height*0.08,),
                        ContactList(
                          text: "สถาบันการแพทย์ฉุกเฉินแห่งชาติ",
                          icnAsset: "assets/icons/icn_Emergency.png",
                          press: (){
                            launch(('tel://1669'));
                          },
                        ),
                        ContactList(
                          text: "มูลนิธิเพื่อนหญิง",
                          icnAsset: "assets/icons/icn_FriendsOfWomen.png",
                          press: (){
                            launch(('tel://025131001'));
                          },
                        ),
                        ContactList(
                          text: "ศูนย์ช่วยเหลือสังคม",
                          icnAsset: "assets/icons/icn_1300.png",
                          press: (){
                            launch(('tel://1300'));
                          },
                        ),
                        ContactList(
                          text: "กรมสุขภาพจิต",
                          icnAsset: "assets/icons/icn_1323.png",
                          press: (){
                            launch(('tel://1323'));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),]
            )
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return showMyContacts(index);
              },
              childCount: contactsList.length,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[Stack(
                children: <Widget>[
                  Container(
                    width: size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                          child: SecondaryButton(
                            text: " เพิ่มเบอร์ฉุกเฉินอื่น",
                            icon: Icons.add,
                            press: (){_awaitReturnValueFromAddContact(context);},
                          ),
                        ),
                        SizedBox(height: size.height*0.01,),
                      ],
                    ),
                  ),
                ],
              ),]
            )
          ),
        ],
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Image.asset('assets/tocsin_typo.png', height: 25,),
  //       centerTitle: true,
  //     ),
  //     body: ListView.builder(
  //         itemCount: contactsList.length,
  //         itemBuilder: (BuildContext buildContext, int index){
  //           return showMyContacts(index);
  //         }
  //       ),
  //   );
  // }

  Widget showMyContacts(int index) {
    return ContactList(
      text: contactsList[index].label,
      icnAsset: "assets/icons/icn_CustomContact.png",
      press: (){
        launch(('tel://${contactsList[index].phone}'));
      },
    );
  }

  Future<Widget> getEmergencyContacts() async {
    contactsList = [];
    FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    List emerContacts = await GetEmerContact(uid);
    setState(() {
      emerContacts.forEach((contact) {
        contactsList.add(EmergencyContactModel(contact['_id'], contact['emer_label'], contact['emer_tel']));
      });
      loading = false;
    });
  }

  void _awaitReturnValueFromAddContact(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmerContactAddPage(),
        )
    );

    if(result != null) {
      setState(() {
        loading = true;
        print('setState : New Contact');
      });
      await getEmergencyContacts();
    }
  }

}