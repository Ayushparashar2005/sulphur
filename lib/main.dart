import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neomax/location_services.dart';
import 'package:neomax/alarm_services.dart';
import 'destination_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DestinationScreen(),
  ));
}

class MyApp extends StatefulWidget {
  final LatLng destination;
  const MyApp({super.key, required this.destination});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController? mapController;
  LocationService locationService = LocationService();
  AlarmService alarmService = AlarmService();
  bool _alarmTriggered = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    alarmService.initialize();

    locationService.onDistanceChanged = (double distance) {
      if (distance < 500 && !_alarmTriggered) {
        alarmService.triggerAlarm();
        _alarmTriggered = true;
      }
    };

    locationService.startTracking(
        widget.destination.latitude, widget.destination.longitude);
  }

  @override
  void dispose() {
    locationService.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tracking...")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: widget.destination,
              zoom: 12.0,
            ),
            markers: {
              Marker(
                  markerId: MarkerId("destination"),
                  position: widget.destination),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                locationService.stopTracking();
                Navigator.pop(context);
              },
              child: Text("Stop Tracking"),
            ),
          ),
        ],
      ),
    );
  }
}
