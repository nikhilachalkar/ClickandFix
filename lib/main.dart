import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

void main() {
  runApp(MapWithCurrentLocation());
}

class MapWithCurrentLocation extends StatefulWidget {
  @override
  _MapWithCurrentLocationState createState() => _MapWithCurrentLocationState();
}

class _MapWithCurrentLocationState extends State<MapWithCurrentLocation> {
  LocationData? _currentLocation;
  MapmyIndiaMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Location location = Location();
      LocationData currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map with Current Location'),
        ),
        body: Stack(
          children: [
            if (_currentLocation != null)
              MapmyIndiaMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _currentLocation!.latitude!,
                    _currentLocation!.longitude!,
                  ),
                  zoom: 14.0,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),
            if (_currentLocation == null)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
