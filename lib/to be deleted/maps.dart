// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart';
//
// import 'const.dart';
//
// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);
//
//   @override
//   State<MapPage> createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   Location _locationController = Location();
//
//   final Completer<GoogleMapController> _mapController =
//   Completer<GoogleMapController>();
//
//   static const LatLng _cairo = LatLng(30.033333, 31.233334); // Cairo coordinates
//   static const LatLng _giza = LatLng(30.013056, 31.208853); // Giza coordinates
//   LatLng? _currentLocation;
//
//   Map<PolylineId, Polyline> polylines = {};
//
//   @override
//   void initState() {
//     super.initState();
//     getLocationUpdates().then(
//           (_) {
//         getPolylinePoints().then((coordinates) {
//           generatePolyLineFromPoints(coordinates);
//         });
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentLocation == null
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : GoogleMap(
//         onMapCreated: ((GoogleMapController controller) =>
//             _mapController.complete(controller)),
//         initialCameraPosition: CameraPosition(
//           target: _cairo,
//           zoom: 11,
//         ),
//         markers: {
//           Marker(
//             markerId: const MarkerId("_currentLocation"),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueAzure),
//             position: _currentLocation!,
//             infoWindow: const InfoWindow(
//               title: "Current Location",
//             ),
//           ),
//           Marker(
//             markerId: const MarkerId("_cairo"),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueRed),
//             position: _cairo,
//             infoWindow: const InfoWindow(
//               title: "Cairo",
//             ),
//           ),
//           Marker(
//             markerId: const MarkerId("_giza"),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueGreen),
//             position: _giza,
//             infoWindow: const InfoWindow(
//               title: "Giza",
//             ),
//           ),
//         },
//         polylines: Set<Polyline>.of(polylines.values),
//       ),
//     );
//   }
//
//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(
//       target: pos,
//       zoom: 13,
//     );
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(_newCameraPosition),
//     );
//   }
//
//   Future<void> getLocationUpdates() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     _serviceEnabled = await _locationController.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await _locationController.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await _locationController.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await _locationController.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _locationController.onLocationChanged
//         .listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           _currentLocation =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(_currentLocation!);
//         });
//       }
//     });
//   }
//
//   Future<List<LatLng>> getPolylinePoints() async {
//     List<LatLng> polylineCoordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       GOOGLE_MAPS_API_KEY,
//       PointLatLng(_cairo.latitude, _cairo.longitude),
//       PointLatLng(_giza.latitude, _giza.longitude),
//       travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     return polylineCoordinates;
//   }
//
//   void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
//     PolylineId id = const PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.blue,
//       points: polylineCoordinates,
//       width: 8,
//     );
//     setState(() {
//       polylines[id] = polyline;
//     });
//   }
// }