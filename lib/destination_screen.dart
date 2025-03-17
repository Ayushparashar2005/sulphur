import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'main.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _onPlaceSelected(dynamic place) {
    double lat = place['geometry']['location']['lat'];
    double lng = place['geometry']['location']['lng'];
    setState(() {
      _selectedLocation = LatLng(lat, lng);
      _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
    });
  }

  void _startTracking() {
    if (_selectedLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(destination: _selectedLocation!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Destination")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(28.7041, 77.1025),
              zoom: 12.0,
            ),
            onTap: _onMapTap,
            markers: _selectedLocation != null
                ? {
                    Marker(
                        markerId: MarkerId("selected"),
                        position: _selectedLocation!)
                  }
                : {},
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _searchController,
              googleAPIKey: "YOUR_GOOGLE_API_KEY_HERE",
              inputDecoration: InputDecoration(
                hintText: "Search destination...",
                border: OutlineInputBorder(),
              ),
              debounceTime: 600,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (place) => _onPlaceSelected(place),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _startTracking,
              child: Text("Set Destination & Start"),
            ),
          ),
        ],
      ),
    );
  }
}
