import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.darkBlue;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.38);
    path.quadraticBezierTo(
        size.width / 2, size.height*0.25,
        size.width, size.height * 0.38
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainterTop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.darkBlue;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.32);
    path.quadraticBezierTo(
        size.width / 2, size.height*0.45,
        size.width, size.height * 0.32
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BgShadow extends StatelessWidget{
  final Widget child;

  const BgShadow({
    Key key,
    this.child,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}


class RowProfile extends StatelessWidget{
  final Widget child;

  const RowProfile({
    Key key,
    this.child,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(top: size.height*0.012, bottom: size.height*0.018, left: size.width*0.08, right: size.width*0.04),
      child: child,
    );
  }
}

class BgEdit extends StatelessWidget{
  final Widget child;

  const BgEdit({
    Key key,
    this.child,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(top: size.height*0.025, bottom: size.height*0.018, left: size.width*0.08, right: size.width*0.08),
      child: child,
    );
  }
}

