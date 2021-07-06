import 'package:mongo_dart/mongo_dart.dart';

GetEmerContact(String uid) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  // var db = await Db.create("mongodb://localhost:27017/tocsin");
  await db.open();

  var collEmerCont = db.collection('emergency_contacts');

  List emerContact = await collEmerCont.find(where.eq('user_id', uid).fields(['_id', 'emer_label', 'emer_tel'])).toList();

  db.close();

  return emerContact;
}

AddEmergencyContact(String uid, String label, String tel) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  await db.open();

  var collEmerCont = db.collection('emergency_contacts');

  await collEmerCont.insertOne(
      {
        'emer_label': label,
        'emer_tel': tel,
        'user_id': uid
      }
  );

  db.close();

  return print('Add emergency contact successful!');
}

EditEmergencyContact(Object id, String label, String tel) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  await db.open();

  var collEmerCont = db.collection('emergency_contacts');

  var newContact = await collEmerCont.findOne({"_id": id});
  newContact["emer_label"] = label;
  newContact["emer_tel"] = tel;

  await collEmerCont.save(newContact);

  db.close();

  return newContact;
}

DeleteEmergencyContact(Object id) async {
  var db = await Db.create('mongodb+srv://elle:BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net/tocsin?retryWrites=true&w=majority');
  await db.open();

  var collEmerCont = db.collection('emergency_contacts');

  await collEmerCont.remove(where.id(id));

  db.close();
}