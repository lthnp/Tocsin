import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
as location_picker;
import 'package:google_map_location_picker/generated/l10n.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePicker extends StatefulWidget {
  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  LocationResult _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.dark(),
      title: 'location picker',
      localizationsDelegates: const [
        location_picker.S.delegate,
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('ar', ''),
        Locale('pt', ''),
        Locale('tr', ''),
        Locale('es', ''),
        Locale('it', ''),
        Locale('ru', ''),
        Locale('th', ''),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('location picker'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    LocationResult result = await showLocationPicker(
                      context, 'AIzaSyAIBeQYaZlb5pMZZ8qia-J3ujaa01OSSp4',
                      initialCenter: LatLng(31.1975844, 29.9598339),
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                      myLocationButtonEnabled: true,
                      layersButtonEnabled: true,
                      // countries: ['AE', 'NG']

//                      resultCardAlignment: Alignment.bottomCenter,
                    );
                    print("result = $result");
                    setState(() => _pickedLocation = result);
                  },
                  child: Text('Pick location'),
                ),
                Text(_pickedLocation.toString()),
              ],
            ),
          );
        }),
      ),
    );
  }
}
