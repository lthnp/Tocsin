import 'package:Tocsin/component/style_text.dart';
import 'package:Tocsin/models/emer_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressList extends StatelessWidget {
  final String label;
  final String address;
  final Function onTap;
  final Function onPress;
  final IconData icon;
  final bool isNull;
  final bool isHome;

  const AddressList({
    Key key,
    this.label,
    this.address = '',
    this.onTap,
    this.onPress,
    this.icon,
    this.isNull = true,
    this.isHome = false,
  }) : super (key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        isHome ? SizedBox() : Divider(color: Colors.secondary, height: 1,),
        Container(
            padding: EdgeInsets.only(left: size.width*0.05, top: size.height*0.02, bottom: size.height*0.02),
            // color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: TitleTextDark(text: label),
                  subtitle: Ink(
                    child: GestureDetector(
                      child: isNull ? ParagraphOneLine(text: address,) : ParagraphHighlight(text: 'เพิ่มที่อยู่',),
                      onTap: onTap,
                    ),
                  ),
                  leading: Icon(icon, color: Colors.primary, size: 30,),
                  trailing: PopupMenuButton(
                    icon: new Icon(Icons.more_vert),
                    onSelected: onPress,
                    itemBuilder: (BuildContext context) {
                      return EmerPopup.emer_choices.map((choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                  // onTap: press,
                ),
                // Divider(color: Colors.black26, height: 1,),
              ],
            )
        )
      ],
    );
  }
}


class ContactList extends StatelessWidget {
  final String label;
  final String tel;
  final Function press;

  const ContactList({
    Key key,
    this.label,
    this.tel,
    this.press,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(top: size.width*0.04, right: size.width*0.04),
        padding: EdgeInsets.only(top: size.width*0.02, bottom: size.width*0.04, left: size.width*0.04),
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
          ListTile(
            title: TitleTextDark(text: label),
            subtitle: ParagraphText(text: tel,),
            trailing: PopupMenuButton(
              icon: new Icon(Icons.more_vert),
              onSelected: press,
              itemBuilder: (BuildContext context) {
                return EmerPopup.emer_choices.map((choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
            // onTap: press,
          ),
          // Divider(color: Colors.black26, height: 1,),
        ],
      )
    );
  }
}
