import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleTextWhite extends StatelessWidget{
  final String text;
  const TitleTextWhite({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),)
    );
  }
}

class TitleTextDark extends StatelessWidget{
  final String text;
  const TitleTextDark({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.textDark),)
    );
  }
}

class TextWhiteLight extends StatelessWidget{
  final String text;
  const TextWhiteLight({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100, color: Colors.white),),
    );
  }
}

class SubTitleBlack extends StatelessWidget{
  final String text;
  const SubTitleBlack({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.textDark));
  }
}

class SubTitleHighlight extends StatelessWidget{
  final String text;
  const SubTitleHighlight({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.primary2));
  }
}

class TextBlackNormal extends StatelessWidget{
  final String text;
  final Color color;
  const TextBlackNormal({
    Key key,
    this.text,
    this.color = Colors.textDark,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: color));
  }
}

class TextBlackLight extends StatelessWidget{
  final String text;
  const TextBlackLight({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100, color: Colors.textDark));
  }
}

class TextSecondaryNormal extends StatelessWidget{
  final String text;
  final Color color;
  const TextSecondaryNormal({
    Key key,
    this.text,
    this.color = Colors.black45,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: color));
  }
}

class TextSecondaryLight extends StatelessWidget{
  final String text;
  final Color color;
  const TextSecondaryLight({
    Key key,
    this.text,
    this.color = Colors.black45,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100, color: color));
  }
}

class ParagraphText extends StatelessWidget{
  final String text;
  final Color color;
  const ParagraphText({
    Key key,
    this.text,
    this.color = Colors.textDark,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Text(
          text,
          style: TextStyle(fontFamily: 'K2D', fontSize: 14, fontWeight: FontWeight.normal, color: color)
        )
      ],
    );
  }
}

class ParagraphOneLine extends StatelessWidget{
  final String text;
  const ParagraphOneLine({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontFamily: 'K2D', fontSize: 14, fontWeight: FontWeight.normal, color: Colors.textDark)
        )
      ],
    );
  }
}

class ParagraphHighlight extends StatelessWidget{
  final String text;
  const ParagraphHighlight({
    Key key,
    this.text,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontFamily: 'K2D', fontSize: 14, fontWeight: FontWeight.normal, color: Colors.primary2));
  }
}

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Row(
        children: <Widget>[
          buildDivider(),
          TextWhiteLight(text: " หรือ "),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider(){
    return Expanded(
      child: Divider(color: Colors.white, height: 1,),
    );
  }
}