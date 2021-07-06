import 'package:Tocsin/Component/style_bg.dart';
import 'package:Tocsin/Component/style_button.dart';
import 'package:Tocsin/user_address.dart';
import 'package:Tocsin/user_emergency.dart';
import 'package:Tocsin/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Controller/UserController.dart';
import 'login.dart';

class MorePage extends StatefulWidget{

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var profile;
  var uid;
  bool _load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUid();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.bg,
      appBar: AppBar(
        title: Image.asset('assets/tocsin_typo.png', height: 25,),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: size.height*0.05,),
          BgShadow(
            child: Column(
              children: <Widget>[
                ListButton(
                  text: 'ข้อมูลส่วนตัว',
                  press: () async {
                    await GetUid();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage(uid: uid,)),
                    );
                  },
                ),
                ListButton(
                  text: 'ที่อยู่ของคุณ',
                  press: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserAddressPage(uid: uid,)),
                    );
                  },
                ),
                ListButton(
                  text: 'ตั้งค่าเบอร์ฉุกเฉิน',
                  press: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserEmergencyPage(uid: uid,)),
                    );
                  },
                ),
                ListButton(
                  text: 'บัญชีผู้ใช้',
                  press: (){},
                ),
              ],
            ),
          ),
          SizedBox(height: size.height*0.01,),
          ListTile(
            title: Text('อื่นๆ', style: TextStyle(fontSize: 14),),),
          BgShadow(
            child: Column(
              children: <Widget>[
                ListButton(
                  text: 'เกี่ยวกับเรา',
                  press: (){},
                ),
                // ListButton(
                //   text: 'แนะนำการใช้งาน',
                //   press: (){},
                // ),
                ListButton(
                  text: 'ข้อกำหนดและเงื่อนไข',
                  press: (){},
                ),
                ListButton(
                  text: 'ติดต่อเรา',
                  press: (){},
                ),
              ],
            ),
          ),
          SizedBox(height: size.height*0.03,),
          SignOutButton(
            text: 'ออกจากระบบ',
            icon: Icons.exit_to_app,
            press: (){
              signOut(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {

    GoogleSignIn _googleSignIn = GoogleSignIn();
    bool isSigned = await _googleSignIn.isSignedIn();
    if(isSigned){
      await _googleSignIn.signOut();
    }

    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/'));
  }


  GetUid () async {
    FirebaseUser user = await _auth.currentUser();
    uid = user.uid;
  }


}