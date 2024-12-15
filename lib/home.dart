import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

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
  final Map<String, Map<String, dynamic>> _markerDetails = {
    "SaFi-1": {
      "title": "SaFi Bin 1",
      "location": "CSE BLOCK RIT",
      "description": "60% Filled",
      "coordinates": LatLng(9.579483847276773, 76.62201380100855),
    },
    "SaFi-2": {
      "title": "SaFi Bin 2",
      "location": "MECH BLOCK RIT",
      "description": "80% Filled",
      "coordinates": LatLng(9.579802075667732, 76.62361088852967),
    },
    "SaFi-3": {
      "title": "SaFi Bin 3",
      "location": "EEE BLOCK RIT",
      "description": "50% Filled",
      "coordinates": LatLng(9.57992642403981, 76.62405676678246),
    },
    "SaFi-4": {
      "title": "SaFi Bin 4",
      "location": "EC BLOCK RIT",
      "description": "40% Filled",
      "coordinates": LatLng(9.57918255364003, 76.62417836994817),
    },
    "SaFi-5": {
      "title": "SaFi Bin 5",
      "location": "CIVIL BLOCK RIT",
      "description": "60% Filled",
      "coordinates": LatLng(9.577842048559074, 76.62287861768607),
    },
    "SaFi-6": {
      "title": "SaFi Bin 6",
      "location": "B-ARCH BLOCK RIT",
      "description": "70% Filled",
      "coordinates": LatLng(9.578541832056205, 76.62271873431126),
    },
  };

  String? _selectedMarkerId;
  Set<Polyline> _polylines = {}; // To track the selected marker

  @override
  void initState() {
    customMarker();
    super.initState();
    _getUserLocation();
  }

  void customMarker() {
    BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(50, 50)), "assets/marker.png")
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

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final apiUrl =
        "https://routing.openstreetmap.de/routed-car/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> coordinates =
            data["routes"][0]["geometry"]["coordinates"];
        List<LatLng> polylineCoordinates =
            coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

        setState(() {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        });
      } else {
        print("Failed to fetch route: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching route: $e");
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
      backgroundColor: Color.fromARGB(255, 42, 254, 169),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 42, 254, 169),
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
                final markerCoordinates =
                    markerDetails["coordinates"] as LatLng;
                return Marker(
                  markerId: MarkerId(markerId),
                  position: markerCoordinates, // Replace with actual positions
                  onTap: () => _onMarkerTapped(markerId),
                  infoWindow: InfoWindow(
                    title: markerDetails["title"],
                    snippet: markerDetails["location"],
                  ),
                  icon: customIcon,
                );
              }).toSet(),
              polylines: _polylines,
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
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      // Left side content (Icons + Texts)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_right,
                                  color: const Color.fromARGB(255, 36, 36, 36),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _markerDetails[_selectedMarkerId]![
                                        "title"]!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color:
                                          const Color.fromARGB(255, 36, 36, 36),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.percent,
                                    color:
                                        const Color.fromARGB(255, 36, 36, 36),
                                    size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _markerDetails[_selectedMarkerId]![
                                        "description"]!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          const Color.fromARGB(255, 36, 36, 36),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color:
                                        const Color.fromARGB(255, 36, 36, 36),
                                    size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _markerDetails[_selectedMarkerId]![
                                        "location"]!,
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 36, 36, 36),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 37, 232, 154),
                                    Color.fromARGB(255, 42, 254, 169),
                                    Color.fromARGB(255, 29, 213, 140),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  final selectedMarkerCoords = _markerDetails[
                                          _selectedMarkerId]!["coordinates"]
                                      as LatLng;
                                  _fetchRoute(
                                      _initialPosition, selectedMarkerCoords);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .transparent, // Make button background transparent
                                  shadowColor: Colors
                                      .transparent, // Remove shadow to avoid overlay issues
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Match border radius with container
                                  ),
                                ),
                                child: Text(
                                  "Directions",
                                  style: TextStyle(
                                      color: Colors
                                          .white, // Text color for better contrast
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Gilroy'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      // Right side content (Image)
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/forgot.png",
                            fit: BoxFit.cover,
                            height: 120, // Adjust height to fit UI design
                          ),
                        ),
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
