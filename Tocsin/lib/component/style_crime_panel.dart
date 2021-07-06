import 'package:Tocsin/component/custom_icons.dart';
import 'package:Tocsin/component/style_button.dart';
import 'package:Tocsin/component/style_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrimeCollapsed extends StatelessWidget {
  final String title;
  final String address;
  final double distance;
  final Function onPressed;
  final Function directPress;

  const CrimeCollapsed({
    Key key,
    this.title,
    this.address,
    this.distance,
    this.onPressed,
    this.directPress,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SubTitleHighlight(text: '$title',),
            SizedBox(height: 5,),
            ParagraphText(text: '$address',),
            SizedBox(height: 15,),
            Row(
              children: [
                MyAddressButton(
                  icon: Icons.near_me,
                  text: 'Direction',
                  press: directPress,
                ),
                Icon(CustomIcons.location, color: Colors.secondary,),
                SizedBox(width: 5,),
                ParagraphText(text: (distance > 1) ? '${distance.toStringAsFixed(3)} KM' : '${(distance*1000).toStringAsFixed(0)} KM', color: Colors.secondary,),
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      )
    );
  }
}

class CrimeNearbyTile extends StatelessWidget {
  final String title;
  final String address;
  final double distance;
  final Function onTap;
  final Function onPressed;

  const CrimeNearbyTile({
    Key key,
    this.title,
    this.address,
    this.distance,
    this.onTap, this.onPressed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return GestureDetector(
      // onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: size.width * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SubTitleHighlight(text: '$title',),
                        ParagraphText(text: '$address',),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Icon(
                              CustomIcons.location, color: Colors.secondary,),
                            SizedBox(width: 5,),
                            ParagraphText(text: (distance > 1) ? '${distance
                                .toStringAsFixed(3)} KM' : '${(distance * 1000)
                                .toStringAsFixed(0)} KM',
                              color: Colors.secondary,),
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onPressed,
                    child: Container(
                      height: 80,
                      child: Icon(Icons.location_on, color: Colors.primary, size: 30,),
                    ),
                  ),
                ]
            )
        )
    );
  }
}

class CrimeNearbyDetails extends StatelessWidget {
  final String title;
  final String createdAt;
  final String description;
  final String address;
  final String ref;
  final Function onPressed;

  const CrimeNearbyDetails({
    Key key,
    this.title,
    this.createdAt,
    this.description,
    this.address,
    this.ref,
    this.onPressed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width*0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SubTitleHighlight(text: '$title',),
          TextSecondaryNormal(text: '$createdAt',),
          SizedBox(height: 20,),
          ParagraphText(text: '$description',),
          SizedBox(height: 40,),
          TextSecondaryNormal(text: 'บริเวณ', color: Colors.primary2,),
          SizedBox(height: 10,),
          ParagraphText(text: '$address',),
          SizedBox(height: 20,),
          // Divider(color: Colors.black26,),
          // SizedBox(height: 10,),
          // TextSecondaryLight(text: 'ที่มา : $ref', color: Colors.primary,)
        ],
      ),
    );
  }
}