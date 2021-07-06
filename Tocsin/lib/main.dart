import 'package:Tocsin/login.dart';
import 'package:Tocsin/src/DBConnection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
as location_picker;
import 'package:google_map_location_picker/generated/l10n.dart';

void main(){
  // server.start();

  Paint.enableDithering = true;

  runApp(
      MaterialApp(
          home:LoginPage(),
          theme: ThemeData(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            fontFamily: 'Mitr',
            scaffoldBackgroundColor: Colors.bg,
          ),
      )
  );
}

class HomePage extends StatefulWidget{
  final FirebaseUser user;
  HomePage(this.user, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // List<EmergencyContactModel> contactsList = List();
  // bool loading = true;

  @override
  initState() {
    super.initState();
    // getEmergencyContacts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('ar', ''),
        Locale('pt', ''),
        Locale('tr', ''),
        Locale('es', ''),
        Locale('it', ''),
        Locale('ru', ''),
        Locale('th', ''),
        const Locale.fromSubtags(languageCode: 'th'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Mitr',
        primaryColor: Colors.white,
        accentColor: Colors.primary,
        scaffoldBackgroundColor: Colors.bg,
        textTheme: TextTheme(body1: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      title: 'Tocsin',
      // centerTitle: true,
      // initialRoute: '/crime', // สามารถใช้ home แทนได้
      routes: {
        Launcher.routeName: (context) => Launcher(),
      },

    );
  }

  // Future<Widget> getEmergencyContacts() async {
  //   FirebaseUser user = await _auth.currentUser();
  //   final uid = user.uid;
  //   List emerContacts = await GetEmerContact(uid);
  //   setState(() {
  //     emerContacts.forEach((contact) {
  //       contactsList.add(EmergencyContactModel(contact['emer_label'], contact['emer_tel']));
  //     });
  //     loading = false;
  //   });
  // }
}