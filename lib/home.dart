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
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(9.57906989243186, 76.62288789505747);
  bool _isPermissionGranted = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _placeSuggestions = []; // To store place suggestions
  bool _isDropdownVisible = false; // To control dropdown visibility
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    // Dispose the debounce timer and search controller
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

    // Permission granted
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _isPermissionGranted = true;
    });

    // Recenter map to user's current location
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

  void _showPermissionError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Permission Required"),
        content: Text(
            "Location permission is required to access your current location."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showLocationServiceError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Location Services Disabled"),
        content: Text("Please enable location services."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showNoLocationFoundError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("No Location Found"),
        content:
            Text("The entered location could not be found. Please try again."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _onPlacePicked(LatLng pickedLocation) {
    setState(() {
      _initialPosition = pickedLocation;
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(pickedLocation, 14));
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
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: _isPermissionGranted,
              // myLocationButtonEnabled: _isPermissionGranted,
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
                border:
                    Border.all(color: const Color.fromARGB(255, 185, 182, 182)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) async {
                        await _searchLocation(value.trim());
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for a building, street name, or area',
                        hintStyle:
                            TextStyle(fontSize: 14, fontFamily: 'Gilroy'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search_rounded),
                    onPressed: () async {
                      bool found =
                          await _searchLocation(_searchController.text.trim());
                      if (!found) {
                        _showNoLocationFoundError();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Dropdown for place suggestions
          if (_isDropdownVisible)
            Positioned(
              top: 70,
              left: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(12), // Set the desired roundness
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _placeSuggestions.length,
                  itemBuilder: (context, index) {
                    // Check if the current item is not the last one
                    bool isLastItem = index == _placeSuggestions.length - 1;

                    return Column(
                      children: [
                        ListTile(
                          title: Text(_placeSuggestions[index]),
                          onTap: () async {
                            // When user selects a suggestion, fetch its coordinates
                            String selectedPlace = _placeSuggestions[index];
                            List<Location> selectedLocation =
                                await locationFromAddress(selectedPlace);

                            if (selectedLocation.isNotEmpty) {
                              final pickedLocation = LatLng(
                                  selectedLocation.first.latitude,
                                  selectedLocation.first.longitude);
                              _onPlacePicked(pickedLocation);
                              setState(() {
                                _isDropdownVisible = false;
                              });
                            }
                          },
                        ),
                        if (!isLastItem)
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                            indent: 15,
                            endIndent: 15,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),

          Positioned(
            bottom: 100,
            left: 120,
            right: 120,
            child: ElevatedButton(
              onPressed: _getUserLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 249, 249),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.adjust_rounded,
                    color: const Color(0xFF18cc84),
                    size: 22.0,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Use Current Location',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Gilroy',
                      color: const Color(0xFF18cc84),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 300,
            left: 0,
            right: 0,
            bottom: 0,
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 1.0,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e1f21),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 19, 212, 151)
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 25,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 74, 74, 79),
                                Color.fromARGB(255, 19, 18, 18),
                                Color.fromARGB(255, 39, 39, 40),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 100.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
