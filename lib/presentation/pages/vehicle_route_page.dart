import 'package:http/http.dart' as http;
import 'package:data_farmers_pre/models/VehicleResult.dart';
import 'package:data_farmers_pre/models/VehicleRoute.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleRoutePage extends StatefulWidget {
  const VehicleRoutePage({
    required this.route,
    Key? key,
  }) : super(key: key);

  final VehicleRoute route;

  @override
  _VehicleRoutePageState createState() => _VehicleRoutePageState();
}

class _VehicleRoutePageState extends State<VehicleRoutePage> {
  VehicleRoute get route => widget.route;
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  // List<Marker> customMarkers = [];

  void _showPos() async {
    List<LatLng> points = [];
    int idx = 1;
    for (VehicleResult vr in route.vehicleResults!) {
      points.add(LatLng(vr.latitude, vr.longitude));
      _markers.add(
        Marker(
          markerId: MarkerId(
            vr.id.toString(),
          ),
          position: LatLng(
            vr.latitude,
            vr.longitude,
          ),
          icon: BitmapDescriptor.fromBytes(
              (await http.get(Uri.parse(vr.imageUrl!))).bodyBytes),
          infoWindow: InfoWindow(
            title: "Pos: $idx, ${vr.timestamp}",
          ),
        ),
      );
      idx += 1;
    }
    _polylines.add(
      Polyline(
        polylineId: PolylineId('1'),
        points: points,
        color: Colors.red,
        width: 3,
        patterns: [PatternItem.dash(15), PatternItem.gap(5)],
      ),
    );

    setState(() {});
  }

  @override
  void initState() {
    _showPos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(
              route.vehicleResults![0].latitude,
              route.vehicleResults![0].longitude,
            ),
            zoom: 5),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
