import 'package:dio/dio.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../Models/location.dart';

final db = Db('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/Tocsin?retryWrites=true&w=majority');

class UserProfileApi {
  // final _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8081/'));
  final _dio = new Dio();

  Future<List> getProfileColl() async {
    final response = await _dio.get('/signup');
    return response.data['coll_userprofiles'];
  }
}

// class LocationApi {
//   final _dio = new Dio();
//
//   Future<List<Location>> getProfileColl() async {
//     final response = await _dio.get('/crime');
//     return (response.data['locations'] as List).map<Location>((json) => Location.fromJson(json)).toList();
//   }
// }

class LocationApi {
  final coll_location = db.collection('locations');
  Future getLocations() async {
    final locations = await coll_location.find().toList();
    return (locations as List).map<CrimeLocation>((json) => CrimeLocation.fromJson(json)).toList();;
  }

  // Future<List<Location>> getLocations() async {
  //   final locations = await coll_location.find().toList();
  //   final response = await locations;
  //   return (response.data['locations'] as List).map<Location>((json) => Location.fromJson(json)).toList();
  // }
}