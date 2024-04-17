import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'MyPage.dart';

void main() => runApp(
  MaterialApp(
    home: MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  late Location location;
  bool _isLocationEnabled = false;
  late LatLng _currentLocation;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();
    location = Location();
    _getCurrentLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_isLocationEnabled) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final currentLocationData = await location.getLocation();
      setState(() {
        _currentLocation = LatLng(currentLocationData.latitude!, currentLocationData.longitude!);
        _isLocationEnabled = true;
      });
    } catch (error) {
      print("Error getting current location: $error");
    }
  }

  Future<void> _openForm(BuildContext context) async {
    // Implement code to open the form here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _isLocationEnabled
                  ? {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: _currentLocation,
                  infoWindow: const InfoWindow(
                    title: 'Current Location',
                  ),
                ),
              }
                  : {},
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                tooltip: 'Get Current Location',
                child: Icon(Icons.location_searching),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child:ElevatedButton(
                onPressed: () {
                  _openForm(context);
                },
                child: Icon(Icons.add),
              )

            ),
          ],
        ),
      ),
    );
  }
}
