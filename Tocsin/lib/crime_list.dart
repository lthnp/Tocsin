import 'package:flutter/material.dart';

class CrimeList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text("เหตุใกล้คุณ", style: TextStyle(color: Colors.textDark),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
    );
  }
}