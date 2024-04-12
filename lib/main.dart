import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LocationData? _currentLocation;
  Location _location = Location();

  static const LatLng _center = const LatLng(37.42796133580664, -122.085749655962);
  static const LatLng _lakeLocation = const LatLng(37.43296265331129, -122.08832357078792);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.from([
          Marker(markerId: MarkerId('lake'), position: _lakeLocation, infoWindow: InfoWindow(title: 'Lake')),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_currentLocation != null) {
            _goToLocation(_lakeLocation);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location not available')));
          }
        },
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 18.0)));
  }

  Future<void> _requestLocationPermission() async {
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        // Handle the scenario when the permission is not granted.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location permission required')));
      } else {
        _getLocation();
      }
    } else {
      _getLocation();
    }
  }

  Future<void> _getLocation() async {
    try {
      var location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });
    } catch (e) {
      // Handle any errors that occur while fetching the location.
      print('Error getting location: $e');
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: MapSample(),
  ));
}
