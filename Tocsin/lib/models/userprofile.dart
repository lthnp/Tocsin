import 'package:mongo_dart/mongo_dart.dart';

class UserProfile {
  final String firstname;
  final String lastname;
  final DateTime birthdate;
  final String gender;
  final String blood;
  final String weight;
  final String height;

  // UserProfile(this.firstname, this.lastname, this.birthdate, this.gender, this.blood, this.weight, this.height);

  // UserProfile.fromJson(Map<String, dynamic> json)
  //     : _id = json['_id'],
  //       firstname = json['firstname'],
  //       lastname = json['lastname'],
  //       birthdate = json['birthdate'],
  //       gender = json['gender'],
  //       blood = json['blood'],
  //       weight = json['weight'],
  //       height = json['height'];
  //
  // Map<String, dynamic> toJson() =>
  //     {
  //       '_id': _id,
  //       'firstname': firstname,
  //       'lastname': lastname,
  //       'birthdate': birthdate,
  //       'gender': gender,
  //       'blood': blood,
  //       'weight': weight,
  //       'height': height,
  //     };

  const UserProfile({
    this.firstname,
    this.lastname,
    this.birthdate,
    this.gender,
    this.blood,
    this.weight,
    this.height
  });
}