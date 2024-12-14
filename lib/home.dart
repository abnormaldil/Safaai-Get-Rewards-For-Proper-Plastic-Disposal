import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(9.57906989243186, 76.62288789505747);
  bool _isPermissionGranted = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _placeSuggestions = [];
  bool _isDropdownVisible = false;
  Timer? _debounce;

  // Marker details map
  final Map<String, Map<String, String>> _markerDetails = {
    "SaFi-1": {
      "title": "SaFi Bin 1",
      "location": "RIT Campus Kottayam",
      "description": "Smart bin for waste disposal with rewards."
    },
    "SaFi-2": {
      "title": "SaFi Bin 2",
      "location": "City Center",
      "description": "Located near the mall entrance."
    },
  };

  String? _selectedMarkerId; // To track the selected marker

  @override
  void initState() {
    customMarker();
    super.initState();
    _getUserLocation();
  }

  void customMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), "marker.png")
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/light.json');
    mapController.setMapStyle(style);
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceError();
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      _showPermissionError();
      return;
    }

    if (permission == LocationPermission.denied) {
      _showPermissionError();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _isPermissionGranted = true;
    });

    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 14),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMapStyle();
    if (_isPermissionGranted) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 14),
      );
    }
  }

  Future<bool> _searchLocation(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    Completer<bool> completer = Completer();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _placeSuggestions = [];
          _isDropdownVisible = false;
        });
        completer.complete(false);
        return;
      }

      try {
        List<Location> locations = await locationFromAddress(query);
        if (locations.isNotEmpty) {
          List<String> suggestions = [];
          for (Location loc in locations) {
            List<Placemark> placemarks =
                await placemarkFromCoordinates(loc.latitude, loc.longitude);
            if (placemarks.isNotEmpty) {
              final placemark = placemarks.first;
              String placeName =
                  "${placemark.name}, ${placemark.locality}, ${placemark.country}";
              suggestions.add(placeName);
            }
          }

          setState(() {
            _placeSuggestions = suggestions;
            _isDropdownVisible = true;
          });
          completer.complete(true);
        } else {
          setState(() {
            _placeSuggestions = [];
            _isDropdownVisible = false;
          });
          completer.complete(false);
        }
      } catch (e) {
        setState(() {
          _placeSuggestions = [];
          _isDropdownVisible = false;
        });
        completer.complete(false);
      }
    });

    return completer.future;
  }

  void _onMarkerTapped(String markerId) {
    setState(() {
      _selectedMarkerId = markerId;
    });
  }

  void _showLocationServiceError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Services Disabled"),
        content: Text("Please enable location services to use this feature."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showPermissionError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text(
            "Location permission is required to access your current location."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF18cc84),
      appBar: AppBar(
        backgroundColor: Color(0xFF18cc84),
        automaticallyImplyLeading: false,
        title: Text(
          'SaFaai',
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontFamily: 'AvantGardeLT',
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              markers: _markerDetails.entries.map((entry) {
                final markerId = entry.key;
                final markerDetails = entry.value;

                return Marker(
                  markerId: MarkerId(markerId),
                  position: LatLng(
                      _initialPosition.latitude + 0.01,
                      _initialPosition
                          .longitude), // Replace with actual positions
                  onTap: () => _onMarkerTapped(markerId),
                  infoWindow: InfoWindow(
                    title: markerDetails["title"],
                    snippet: markerDetails["location"],
                  ),
                  icon: customIcon,
                );
              }).toSet(),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: _isPermissionGranted,
              mapType: MapType.normal,
            ),
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color.fromARGB(255, 185, 182, 182), width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search location",
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Color(0xFF18cc84)),
                      ),
                      onChanged: (query) {
                        _searchLocation(query);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.my_location, color: Color(0xFF18cc84)),
                    onPressed: _getUserLocation,
                  ),
                ],
              ),
            ),
          ),
          if (_isDropdownVisible)
            Positioned(
              top: 65,
              left: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _placeSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_placeSuggestions[index]),
                      onTap: () async {
                        try {
                          List<Location> locations = await locationFromAddress(
                              _placeSuggestions[index]);
                          if (locations.isNotEmpty) {
                            Location location = locations.first;
                            mapController.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                LatLng(location.latitude, location.longitude),
                                14,
                              ),
                            );
                            setState(() {
                              _isDropdownVisible = false;
                              _searchController.clear();
                            });
                          }
                        } catch (e) {
                          print("Error navigating to location: $e");
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          if (_selectedMarkerId != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _markerDetails[_selectedMarkerId]!["title"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(_markerDetails[_selectedMarkerId]!["description"]!),
                      SizedBox(height: 10),
                      Text(
                        "Location: ${_markerDetails[_selectedMarkerId]!["location"]!}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedMarkerId = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF18cc84),
                        ),
                        child: Text("Close"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
