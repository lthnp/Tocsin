import 'package:Tocsin/src/DBConnection.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserLocationController{

}


GetUserLocation (String uid) async {
  // return DBConnection.getInstance();
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  // return print('Database : ${DBConnection().getConnection()}');
  await db.open();

  var collLocation = db.collection('user_locations');
  // var collLocation = DBConnection().getCollection('user_locations');
  List myLocations = await collLocation.find(where.eq('user_id', uid)).toList();

  // print(myLocations);

  db.close();

  return myLocations;
}

AddUserLocation(String uid, String label, double lat, double long, String address) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  await db.open();

  var collUserLocation = db.collection('user_locations');

  var newLocation = await collUserLocation.insertOne(
      {
        'label': label,
        'lat': lat,
        'long': long,
        'address' : address,
        'user_id' : uid
      }
  );

  db.close();

  return newLocation;
}

EditUserLocation(Object id, String label, double lat, double long, String address) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  await db.open();

  var collUserLocation = db.collection('user_locations');

  var newLocation = await collUserLocation.findOne({"_id": id});
  newLocation["label"] = label;
  newLocation["lat"] = lat;
  newLocation["long"] = long;
  newLocation["address"] = address;

  await collUserLocation.save(newLocation);

  db.close();

  return newLocation;
}

DeleteUserLocation(Object id) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  await db.open();

  var collUserLocation = db.collection('user_locations');

  await collUserLocation.remove(where.id(id));

  db.close();
}