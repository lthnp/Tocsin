import 'package:Tocsin/component/style_button.dart';
import 'package:Tocsin/component/style_text.dart';
import 'package:Tocsin/loading.dart';
import 'package:Tocsin/user_emergency_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_emergency.dart';
import 'component/style_user_contact.dart';
import 'controller/EmergencyController.dart';
import 'models/emer_popup.dart';
import 'models/emergency_contact.dart';

class UserEmergencyPage extends StatefulWidget{
  final uid;
  const UserEmergencyPage({Key key, this.uid}) : super(key: key);

  @override
  _UserEmergencyPageState createState() => _UserEmergencyPageState();
}

class _UserEmergencyPageState extends State<UserEmergencyPage>{
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
        appBar: AppBar(
          centerTitle: true,
          title: Text("เบอร์ฉุกเฉิน", style: TextStyle(color: Colors.textDark),),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: addEmergency,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return;
          },
          child: ListView.builder(
              padding: EdgeInsets.only(top: 20, bottom: 50),
              itemCount: contactsList.length,
              itemBuilder: (BuildContext context, int index) {
                return showContactList(index);
              }
          ),
        )
    );
  }

  showContactList(int index) {
    return ContactList(
      label: contactsList[index].label,
      tel: contactsList[index].phone,
      press: (String choice) async {
        if(choice == EmerPopup.edit){
          print('edit ' + contactsList[index].label);
          print('edit ' + contactsList[index].id.toString());
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmerContactEditPage(
              selected_emer_id : contactsList[index].id,
              selected_emer_label : contactsList[index].label,
              selected_emer_tel: contactsList[index].phone,
            )),
          );
          if(result != null){
            setState(() {
              contactsList[index].label = result['emer_label'];
              contactsList[index].phone = result['emer_tel'];
              // print('index ' + index.toString());
              // print(contactsList[index].label + ' | ' + contactsList[index].phone);
            });
          }
        } else if(choice == EmerPopup.delete){
          print('delete ' + contactsList[index].label);
          showAlertDialog(context, index);
        }
      },
    );
  }

  Future<Widget> getEmergencyContacts() async {
    contactsList = [];
    List emerContacts = await GetEmerContact(widget.uid);
    setState(() {
      emerContacts.forEach((contact) {
        contactsList.add(EmergencyContactModel(contact['_id'], contact['emer_label'], contact['emer_tel']));
      });
      loading = false;
    });
    print(contactsList);
  }

  Future<Widget> editEmergencyContacts() async {
    List emerContacts = await GetEmerContact(widget.uid);
    setState(() {
      emerContacts.forEach((contact) {
        contactsList.add(EmergencyContactModel(contact['_id'], contact['emer_label'], contact['emer_tel']));
      });
      loading = false;
    });
    print(contactsList);
  }

  showAlertDialog(BuildContext context, int index) {
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
        await DeleteEmergencyContact(contactsList[index].id);
        getEmergencyContacts();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันการลบ ?"),
      content: ParagraphText(text: "ต้องการลบหมายเลข ${contactsList[index].phone} (${contactsList[index].label}) ใช่หรือไม่?"),
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


  addEmergency() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmerContactAddPage())
    );
    if (result != null) {
      setState(() {
        loading = true;
        getEmergencyContacts();
      });
    }
  }

}