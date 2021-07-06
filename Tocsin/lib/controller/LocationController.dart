import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';

GetLocation () async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  // var db = await Db.create("mongodb://localhost:27017/tocsin");
  await db.open();

  var collLocation = db.collection('locations');
  List locations = await collLocation.find(where.eq('status', 'on')).toList();

  db.close();

  return locations;
}