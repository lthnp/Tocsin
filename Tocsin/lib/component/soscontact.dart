import 'package:Tocsin/Component/style_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget{
  final String text;
  final String icnAsset;
  final Function press;

  const ContactList({
    Key key,
    this.text,
    this.icnAsset,
    this.press,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: size.width*0.05),
      margin: EdgeInsets.only(right: size.width*0.05, top: 15),
      decoration: new BoxDecoration(
        color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
        borderRadius: new BorderRadius.only(topRight: Radius.circular(100), bottomRight: Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(icnAsset, height: size.width*0.12, width: size.width*0.12,),
          SizedBox(width: size.width*0.05,),
          Container(
            width: size.width*0.47,
            child: SubTitleBlack(text: text,),
          ),
          FlatButton(
            child: Image.asset("assets/icons/btn_call.png", height: size.width*0.15, width: size.width*0.15),
            shape: CircleBorder(),
            onPressed: press,
          ),
        ],
      ),
    );
  }
}