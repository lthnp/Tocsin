import 'package:mongo_dart/mongo_dart.dart';

GetUserProfile (String uid) async {
  final db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  // var db = Db("mongodb://localhost:27017/tocsin");
  // Db db = new Db("mongodb://localhost:27017/tocsin");
  print(db);
  await db.open();
  final collUserProfile = db.collection('user_profiles');
  final userprofile = await collUserProfile.findOne(where.eq('user_id', uid));
  db.close();
  return userprofile;
}

UpdateUserProfile (String uid, String firstname, String lastname, String birthdate, String gender, String blood, String weight, String height) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  // var db = await Db.create("mongodb://localhost:27017/tocsin");
  await db.open();
  var collUserProfile = db.collection('user_profiles');

  final new_userprofile = await collUserProfile.findOne(where.eq('user_id', uid));

  new_userprofile['firstname'] = firstname;
  new_userprofile['lastname'] = lastname;
  new_userprofile['birthdate'] = DateTime.parse(birthdate);
  new_userprofile['gender'] = gender;
  new_userprofile['blood'] = blood;
  new_userprofile['weight'] = weight;
  new_userprofile['height'] = height;
  new_userprofile['updated_at'] = DateTime.now();

  // print(new_userprofile);

  await collUserProfile.save(new_userprofile);

  db.close();

  print('Update successful.');

  return new_userprofile;
}