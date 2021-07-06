
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';

AddUserProfile (String firstname, String lastname, String phone, String birthdate, String uid) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  // var db = await Db.create("mongodb://localhost:27017/tocsin");
  await db.open();

  var collUserProfile = db.collection('user_profiles');

  await collUserProfile.insertOne(
    {
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'birthdate': DateTime.parse(birthdate),
      'gender': '',
      'blood': '',
      'weight': '',
      'height': '',
      'user_id': uid,
      'created_at': DateTime.now(),
      'updated_at': DateTime.now()
    }
  );

  db.close();

  return print('Add user profile successful!');
}