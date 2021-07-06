import 'package:Tocsin/Component/style_bg.dart';
import 'package:Tocsin/Component/style_text.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const PrimaryButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.primary,
    this.textColor = Colors.white,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: color,
            onPressed: press,
            child: Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
            )
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final IconData icon;
  const SecondaryButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.primary,
    this.textColor = Colors.primary,
    this.icon,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlatButton(
            shape: RoundedRectangleBorder(side: BorderSide(
                color: color,
                width: 2,
                style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            onPressed: press,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: textColor,),
                Text(
                  text,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
                )
              ],
            )
        ),
      ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final IconData icon;
  const WhiteButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.white,
    this.textColor = Colors.textDark,
    this.icon,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 3),),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: color,
            onPressed: press,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: textColor,),
                SizedBox(width: 10,),
                Text(
                  text,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
                )
              ],
            )
        ),
      ),
    );
  }
}

class ListButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  const ListButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.white,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      borderOnForeground: true,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0,0,0,0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: TextBlackNormal(text: text),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: press,
          ),
          Divider(color: Colors.black26, height: 1,),
        ],
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  final IconData icon;
  const SignOutButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.white,
    this.icon,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return BgShadow(
      child: Card(
          color: color,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          borderOnForeground: true,
          elevation: 0,
          margin: EdgeInsets.fromLTRB(0,0,0,0),
          child: ListTile(
            leading: Icon(icon),
            title: TextBlackNormal(text: text),
            onTap: press,
          )
      ),
    );
  }
}

class MyAddressButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final IconData icon;

  const MyAddressButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.white,
    this.textColor = Colors.textDark,
    this.icon,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: -3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.black12)
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          color: color,
          onPressed: press,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: textColor, size: 18,),
              SizedBox(width: 8,),
              Text(
                text,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
              )
            ],
          )
      ),

    );
  }
}

class AlertButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, outlinecolor, textColor;

  const AlertButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.white,
    this.outlinecolor = Colors.black12,
    this.textColor = Colors.textDark,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: outlinecolor)
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          color: color,
          onPressed: press,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
              )
            ],
          )
      ),

    );
  }
}