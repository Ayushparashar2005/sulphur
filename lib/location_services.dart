import 'package:geolocator/geolocator.dart';

class LocationService {
  Function(double distance)? onDistanceChanged;
  Position? _currentPosition;
  bool _tracking = false;
  double _destinationLat = 0.0;
  double _destinationLng = 0.0;

  Future<void> requestPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permissions are denied.");
    }
  }

  void startTracking(double destLat, double destLng) {
    _destinationLat = destLat;
    _destinationLng = destLng;
    _tracking = true;

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      if (!_tracking) return;

      _currentPosition = position;
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _destinationLat,
        _destinationLng,
      );

      if (onDistanceChanged != null) {
        onDistanceChanged!(distance);
      }
    });
  }

  void stopTracking() {
    _tracking = false;
  }
}
