import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNav extends StatelessWidget{
  const BottomNav({
    Key key,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
  return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width*0.12),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          offset: Offset(0, -10),
          blurRadius: 10,
          color: Colors.black12,
        )],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset("assets/svg/location.svg"),
            color: Colors.primary,
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset("assets/svg/sos.svg"),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset("assets/svg/more.svg"),
            onPressed: () {

            },
          )
        ],
      ),
    );
  }
}