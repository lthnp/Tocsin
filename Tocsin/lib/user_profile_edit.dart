import 'package:Tocsin/Component/style_bg.dart';
import 'package:Tocsin/Component/style_button.dart';
import 'package:Tocsin/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Component/datepicker.dart';
import 'Component/style_text.dart';
import 'Component/style_textfield.dart';
import 'Controller/UserController.dart';

class UserProfileEditPage extends StatefulWidget{
  final profile;
  final uid;
  const UserProfileEditPage({Key key, this.profile, this.uid}) : super(key: key);

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  DateFormat _dateFormat;
  var profile;

  List<String> gender = <String>['ชาย', 'หญิง'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedGender;
  List<String> blood = <String>['O+', 'O-', 'B+', 'B-', 'A+', 'A-', 'AB+', 'AB-'];
  List<DropdownMenuItem<String>> _dropdownBloodMenuItems;
  String _selectedBlood;

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    _dropdownMenuItems = buildGenderItems(gender);
    _dropdownMenuItems.forEach((element) {
      if(element.value == widget.profile['gender']){
        _selectedGender = element.value;
      }
    });
    _dropdownBloodMenuItems = buildBloodItems(blood);
    _dropdownBloodMenuItems.forEach((element) {
      if(element.value == widget.profile['blood']){
        _selectedBlood = element.value;
      }
    });
    _dateFormat = DateFormat.yMd();
    fNameController.text = widget.profile['firstname'];
    lNameController.text = widget.profile['lastname'];
    birthController.text = widget.profile['birthdate'].toString();
    weightController.text = widget.profile['weight'];
    heightController.text = widget.profile['height'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text("แก้ไข", style: TextStyle(color: Colors.textDark),),
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
                    TextBlackNormal(text: 'ข้อมูลส่วนตัว',),
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
                          TextSecondaryLight(text: 'ชื่อ',),
                          NormalTextField(
                            hintText: 'ชื่อ',
                            controller: fNameController,
                          ),
                          TextSecondaryLight(text: 'นามสกุล',),
                          NormalTextField(
                            hintText: 'นามสกุล',
                            controller: lNameController,
                          ),
                          TextSecondaryLight(text: 'วันเกิด',),
                          DatePickerEdit(
                            lastDate: DateTime.now().add(Duration(days: 1)),
                            firstDate: DateTime(1900),
                            initialDate: widget.profile['birthdate'],
                            onDateChanged: (selectedDate) {
                              birthController.text =  selectedDate.toString();
                            },
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextSecondaryLight(text: 'เพศ',),
                                      Container(
                                        width: size.width,
                                        margin: EdgeInsets.only(bottom: size.height*0.025),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          underline: Container(
                                            height: 1.3,
                                            color: Colors.black26,
                                          ),
                                          value: _selectedGender,
                                          items: _dropdownMenuItems,
                                          onChanged: onChangeGenderItem,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width*0.08,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextSecondaryLight(text: 'กลุ่มเลือด',),
                                      Container(
                                        width: size.width,
                                        margin: EdgeInsets.only(bottom: size.height*0.025),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          underline: Container(
                                            height: 1.3,
                                            color: Colors.black26,
                                          ),
                                          value: _selectedBlood,
                                          items: _dropdownBloodMenuItems,
                                          onChanged: onChangeBloodItem,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextSecondaryLight(text: 'น้ำหนัก',),
                                      TextFieldWithSuffix(
                                        hintText: 'น้ำหนัก',
                                        suffText: 'kg',
                                        controller: weightController,
                                        inputType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width*0.08,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextSecondaryLight(text: 'ส่วนสูง',),
                                      TextFieldWithSuffix(
                                        hintText: 'ส่วนสูง',
                                        suffText: 'cm',
                                        controller: heightController,
                                        inputType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                  profile = await UpdateProfile();
                  Navigator.pop(context, profile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  onChangeGenderItem(String selectedGender) {
    setState(() {
      _selectedGender = selectedGender;
    });
  }

  List<DropdownMenuItem<String>> buildGenderItems(List gender) {
    List<DropdownMenuItem<String>> items = List();
    for (String gd in gender) {
      items.add(
        DropdownMenuItem(
          value: gd,
          child: Text(gd),
        ),
      );
    }
    return items;
  }

  onChangeBloodItem(String selectedBlood) {
    setState(() {
      _selectedBlood = selectedBlood;
    });
  }

  List<DropdownMenuItem<String>> buildBloodItems(List blood) {
    List<DropdownMenuItem<String>> items = List();
    for (String b in blood) {
      items.add(
        DropdownMenuItem(
          value: b,
          child: Text(b),
        ),
      );
    }
    return items;
  }

  UpdateProfile () async {
    String firstname = fNameController.text.trim();
    String lastname = lNameController.text.trim();
    String birthdate = birthController.text.trim();
    String gender = _selectedGender;
    String blood = _selectedBlood;
    String weight = weightController.text.trim();
    String height = heightController.text.trim();

    if (
      firstname != widget.profile['firstname'] ||
      lastname != widget.profile['lastname'] ||
      birthdate != widget.profile['birthdate'].toString() ||
      gender != widget.profile['gender'] ||
      blood != widget.profile['blood'] ||
      weight != widget.profile['weight'] ||
      height != widget.profile['height']
    ) {
      setState(() {
        loading = true;
      });
      return await UpdateUserProfile(widget.uid, firstname, lastname, birthdate, gender, blood, weight, height);
    }
  }

  void _sendDataBack(BuildContext context) {
    var dataToSendBack = profile;
    Navigator.pop(context, dataToSendBack);
  }

}