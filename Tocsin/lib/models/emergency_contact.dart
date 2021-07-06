import 'package:mongo_dart/mongo_dart.dart';

class EmergencyContactModel {
  Object id;
  String label, phone;

  EmergencyContactModel(this.id, this.label, this.phone);

  EmergencyContactModel.fromMap(Map<String, dynamic> map){
    id = map['_id'];
    label = map['emer_label'];
    phone = map['emer_tel'];
  }
}