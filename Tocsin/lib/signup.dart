import 'package:Tocsin/Component/custom_icons.dart';
import 'package:Tocsin/Component/style_textfield.dart';
import 'package:Tocsin/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'src/api.dart';

import 'Component/datepicker.dart';
import 'Component/style_button.dart';
import 'Component/style_text.dart';
import 'Controller/SignupController.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget{
  static const routeName = '/signup';

  final UserProfileApi api = UserProfileApi();

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  var coll_userprofile;
  bool loading = false;
  String errMessage = '';
  String oldEmail = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    birthController.text = DateTime.now().toString();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.darkBlue,
      appBar: AppBar(
        title: Text("ลงทะเบียน", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.black)
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height*0.03,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 25),

              decoration: new BoxDecoration(
                  color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
                  borderRadius: new BorderRadius.circular(15),
              ),
              child: new Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: FormSignUpUI(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(height: size.height*0.12,),
                TextWhiteLight(text: "มีบัญชีผู้ใช้แล้ว ?   "),
                Ink(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.primary2),),
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }

  signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmController.text.trim();
    String firstname = fNameController.text.trim();
    String lastname = lNameController.text.trim();
    String phone = phoneController.text.trim();
    bool isSuccessful = false;

    if (password == confirmPassword && password.length >= 8 && password.length <= 16) {
      if (firstname.length >= 1 && lastname.length >= 1) {
        if (phone.length == 10) {
          _auth.createUserWithEmailAndPassword(email: email, password: password).then((user) {
            print("Sign up user successful.");
            isSuccessful = true;
            CreateUserProfile(isSuccessful, firstname, lastname, phone);
            setState(() {
              loading = true;
            });
          }).catchError((error) {
            print(error.message);
            oldEmail = email;
            errMessage = error.message;
            print(errMessage);
          });
        } else {
          print("Please check your phone number.");
        }
      } else {
        print("Input is empty.");
      }
    } else {
      print("Password and Confirm-password is not match.");
    }
  }

  CreateUserProfile (bool isSuccessful, String firstname, String lastname, String phone) async {
    String birthdate = birthController.text.trim();
    if (isSuccessful) {
      FirebaseUser user = await _auth.currentUser();
      final uid = user.uid;
      await AddUserProfile(firstname, lastname, phone, birthdate, uid);
      checkAuth(context);
    }
  }

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      print("Already singed-in with");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(user)));
    }
  }

  Widget FormSignUpUI() {
    return new Column(
      children: <Widget>[
        RegisterTextField(
          icon: CustomIcons.address,
          labelText: 'อีเมล',
          controller: emailController,
          validator: validateEmail,
          onSaved: (String val) {emailController.text = val;},
        ),
        RegisterPasswordTextField(
          icon: CustomIcons.password,
          labelText: 'รหัสผ่าน 8-16 ตัวอักษร',
          controller: passwordController,
          validator: validatePassword,
          onSaved: (String val) {passwordController.text = val;},
        ),
        RegisterPasswordTextField(
          icon: CustomIcons.password,
          labelText: 'ยืนยันรหัสผ่าน',
          controller: confirmController,
          validator: validateConfirmPassword,
          onSaved: (String val) {confirmController.text = val;},
        ),
        SizedBox(height: 20,),
        RegisterTextField(
          icon: CustomIcons.user,
          labelText: 'ชื่อจริง',
          controller: fNameController,
          validator: validateFirstname,
          onSaved: (String val) {fNameController.text = val;},
        ),
        RegisterTextField(
          icon: CustomIcons.user,
          labelText: 'นามสกุล',
          controller: lNameController,
          validator: validateLastname,
          onSaved: (String val) {lNameController.text = val;},
        ),
        RegisterTextField(
          inputType: TextInputType.phone,
          icon: CustomIcons.telephone,
          labelText: 'เบอร์โทรศัพท์',
          controller: phoneController,
          validator: validateMobile,
          onSaved: (String val) {phoneController.text = val;},
        ),
        MyTextFieldDatePicker(
          labelText: "วันเกิด",
          lastDate: DateTime.now().add(Duration(days: 1)),
          firstDate: DateTime(1900),
          initialDate: DateTime.now(),
          onDateChanged: (selectedDate) {
            birthController.text = selectedDate.toString();
          },
        ),
        SizedBox(height: 20,),
        PrimaryButton(
          text: "สมัครสมาชิก",
          press: _validateInputs,
        ),
      ],
    );
  }


  void _validateInputs () {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      signUp();
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail (String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return 'อีเมลไม่ถูกต้อง โปรดตรวจสอบ';
    else if(errMessage == 'The email address is already in use by another account.' || oldEmail == email){
      print(errMessage);
      errMessage = '';
      return 'มีอีเมลนี้ในระบบแล้ว';
    }
    else {
      return null;
    }
  }

  String validatePassword (String password) {
    if (password.length <= 8 || password.length >= 16)
      return 'โปรดกรอกรหัสผ่าน 8-16 ตัวอักษร';
    else
      return null;
  }

  String validateConfirmPassword (String confirm) {
    if(confirm != passwordController.text) {
      if(confirm.isEmpty)
        return 'โปรดยืนยันรหัสผ่าน';
      return 'รหัสผ่านไม่ตรงกัน';
    }
    else
      return null;
  }

  String validateFirstname (String fName) {
    if(fName.isEmpty)
      return 'โปรดกรอกชื่อจริง';
    else
      return null;
  }

  String validateLastname (String lName) {
    if(lName.isEmpty)
      return 'โปรดกรอกนามสกุล';
    else
      return null;
  }

  String validateMobile (String phone) {
    if(phone.length != 10)
      return 'เบอร์โทรศัพท์ไม่ถูกต้อง';
    else
      return null;
  }


}