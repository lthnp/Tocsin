import 'package:Tocsin/main.dart';
import 'package:Tocsin/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Component/style_bg.dart';
import 'Component/style_button.dart';
import 'Component/style_textfield.dart';
import 'Component/style_text.dart';

class LoginPage extends StatefulWidget{
  // getMethod()async{
  //   String url
  // }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.height*0.10, bottom: size.height*0.07),
              height: size.height*0.36,
              width: size.width,
              color: Colors.white,
              child: Image.asset('assets/tocsin_nonebg.png', height: size.height,),
            ),
            Positioned(
              // margin: EdgeInsets.only(top: 270),
              child: CustomPaint(
                painter: CurvePainter(),
              ),
              height: size.height,
              width: size.width,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.08),
                margin: EdgeInsets.only(top: size.height*0.36),
                width: size.width,
                height: size.height*0.64,
                alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  TitleTextWhite(text: "เข้าสู่ระบบ",),
                  LoginTextField(
                    hintText: "อีเมล หรือ เบอร์โทรศัพท์",
                    onChanged: (value) {},
                    controller: emailController,
                  ),
                  PasswordTextField(
                    hintText: "รหัสผ่าน",
                    onChanged: (value) {},
                    controller: passwordController,
                  ),
                  PrimaryButton(
                    text: "เข้าสู่ระบบ",
                    press: (){
                      signIn();
                    },
                  ),
                  TextWhiteLight(text: "ลืมรหัสผ่าน ?"),
                  OrDivider(),
                  TextWhiteLight(text: "เข้าสู่ระบบด้วยบัญชี"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Image.asset("assets/svg/facebook.png", height: 45, width: 45),
                        padding: EdgeInsets.all(8),
                        shape: CircleBorder(),
                        onPressed: (){},
                      ),
                      FlatButton(
                        child: Image.asset("assets/svg/google.png", height: 45, width: 45,),
                        padding: EdgeInsets.all(8),
                        shape: CircleBorder(),
                        onPressed: (){
                          loginWithGoogle(context);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: size.height*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextWhiteLight(text: "ยังไม่มีบัญชีผู้ใช้ ?   "),
                      Ink(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpPage()),
                            );
                          },
                          child: Text("ลงทะเบียน", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.primary2),),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<FirebaseUser> signIn() async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((user) {
      print("signed in ${user.email}");
      checkAuth(context);
    }).catchError((error) {
      print(error.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.primary2,
      ));
    });
  }

  Future loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/user.birthday.read',
      ],
    );
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user.authentication;

    await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: userAuth.idToken, accessToken: userAuth.accessToken)
    );
    checkAuth(context); // after success route to home.


  }

  // _signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleAuth.idToken,
  //       accessToken: googleAuth.accessToken
  //   );
  //   final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  // }

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      print("Already singed-in with");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(user)));
    }
  }



}




