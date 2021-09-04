import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({
    Key? key,
  }) : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  late GoogleMapController _controller;
  final TextEditingController _radiusController = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Set<Marker> _markers = {};

  Set<Circle> _circles = {};

  double defaultRadius = 0;
  late MarkerId markerId;
  Marker? marker;
  int marId = 1;
  int circleId = 1;
  LatLng? _latlng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GoogleMap(
              onTap: (LatLng latLng) {
                debugPrint("Tapped: $latLng");
                marId += 1;
                int markerIdVal = marId;
                String mar = markerIdVal.toString();
                markerId = MarkerId(mar);
                marker = Marker(
                  markerId: markerId,
                  position: latLng,
                  icon: BitmapDescriptor.defaultMarker,
                  draggable: true,
                  onDragEnd: (updatedLatLng) {
                    setState(() {
                      _latlng = updatedLatLng;
                      _circles.clear();
                      circleId += 1;
                      _circles.add(
                        Circle(
                          circleId: CircleId(circleId.toString()),
                          center: updatedLatLng,
                          radius: defaultRadius,
                          strokeWidth: 2,
                          fillColor: Colors.purple.shade100.withOpacity(0.5),
                          strokeColor: Colors.purple.shade100.withOpacity(0.1),
                        ),
                      );
                    });
                  },
                  infoWindow: InfoWindow(
                    title: "${latLng.latitude},${latLng.longitude} ",
                  ),
                );
                _latlng = latLng;
                _markers.clear();
                _circles.clear();
                circleId += 1;
                _circles.add(
                  Circle(
                    circleId: CircleId(circleId.toString()),
                    center: latLng,
                    radius: defaultRadius,
                    strokeWidth: 2,
                    fillColor: Colors.purple.shade100.withOpacity(0.5),
                    strokeColor: Colors.purple.shade100.withOpacity(0.1),
                  ),
                );
                setState(
                  () {
                    _markers.add(marker!);
                  },
                );
              },
              markers: _markers,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  39.693826,
                  -77.349021,
                ),
                zoom: 5,
              ),
              circles: _circles,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Radius (in KM)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 4,
                ),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: _radiusController,
                    onChanged: (r) {
                      if (r.isNotEmpty && marker != null) {
                        setState(
                          () {
                            defaultRadius =
                                double.parse(_radiusController.text); // in kms
                            defaultRadius = defaultRadius * 1000; // in meters
                            _circles.clear();
                            circleId += 1;
                            _circles.add(
                              Circle(
                                circleId: CircleId(circleId.toString()),
                                center: _latlng!,
                                radius: defaultRadius,
                                strokeWidth: 2,
                                fillColor:
                                    Colors.purple.shade100.withOpacity(0.5),
                                strokeColor:
                                    Colors.purple.shade100.withOpacity(0.1),
                              ),
                            );
                          },
                        );
                      } else {}
                    },
                    enabled: marker != null ? true : false,
                    style: TextStyle(color: Colors.black),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9\.]')),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      fillColor: Color(0xFFF5F5F5),
                      hintText: 'Enter Radius (in KM)',
                      filled: true,
                    ),
                  ),
                ),
              ),
              if (_radiusController.text != '')
                Flexible(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context, [_latlng, defaultRadius]);
                    },
                    child: Text('Submit'),
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
