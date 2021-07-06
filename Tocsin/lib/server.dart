import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:sevr/sevr.dart';

void start() async{
  final db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/Tocsin?retryWrites=true&w=majority');
  await db.open();

  final collLocation = db.collection('locations');
  print(await collLocation.find().toList());

  // const port = 8081;
  // final server = Sevr();
  //
  // server.get('/crime', [
  //   (ServRequest req, ServResponse res) async {
  //     final collLocation = db.collection('locations');
  //     final locations = await collLocation.find().toList();
  //     return res.status(200).json({'locations': locations});
  //   }
  // ]);
  //
  // server.get('/signup', [
  //   (ServRequest req, ServResponse res) async {
  //     final collUserProfile = await db.collection('user_profiles');
  //     final UserProfile = await collUserProfile.find().toList();
  //     return res.status(200).json({'coll_userprofile': UserProfile});
  //   }
  // ]);
  //
  //
  //
  // server.listen(port, callback: () {
  //   print('Server listening on port: $port');
  // });

}