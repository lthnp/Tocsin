import 'dart:async';

import 'package:Tocsin/models/user_location.dart';
import 'package:location/location.dart';

class LocationService {
  UserLocation _currentLocation;
  Location location = Location();

  StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();

  LocationService(){
    location.requestPermission().then((value) {
      if(value != null){
        location.onLocationChanged().listen((locationData) {
          if(locationData != null){
            _locationController.add(UserLocation(
                latitude: locationData.latitude,
                longitude: locationData.longitude
            ));
          }
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
          latitude: userLocation.latitude,
          longitude: userLocation.longitude
      );
    } catch(e) {
      print('Cannot get current location $e');
    }

    return _currentLocation;

  }
}