class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({this.latitude, this.longitude});
}

class MyLocation {
  Object id;
  String label;
  double latitude;
  double longitude;
  String address;

  // MyLocation({this.id, this.label, this.latitude, this.longitude, this.address});

  MyLocation(Map json) {
    id = json['_id'];
    label = json['label'];
    latitude = json['lat'];
    longitude = json['long'];
    address = json['address'];
  }
  Map<String, dynamic> toJson() => {'_id': id, 'label': label, 'lat': latitude, 'long': longitude, 'address': address};
}