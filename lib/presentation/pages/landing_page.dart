import 'package:data_farmers_pre/models/VehicleInfo.dart';
import 'package:data_farmers_pre/models/VehicleQuery.dart';
import 'package:data_farmers_pre/models/VehicleResult.dart';
import 'package:data_farmers_pre/presentation/pages/second_page.dart';
import 'package:data_farmers_pre/presentation/pages/select_location_page.dart';
import 'package:data_farmers_pre/services/QueryVehiclesService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  /// Holds From Date
  DateTime? _fromSelectedDate;

  /// Holds From Time
  TimeOfDay? _fromSelectedTimeOfDay;
  TextEditingController _fromSelectedDateController = TextEditingController();

  /// Holds To Date
  DateTime? _toDate;

  /// Holds To Time
  TimeOfDay? _toTimeOfDay;
  TextEditingController _toSelectedDateController = TextEditingController();

  /// Holds the location and radius
  late double _latitude;
  late double _longitude;
  double? _radius;

  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _radiusController = TextEditingController();

  @override
  void dispose() {
    _fromSelectedDateController.dispose();
    _toSelectedDateController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  List<String> vehicleType = [
    'SUV',
    'Sedan',
  ];
  String? _vehicleType;
  String? _vehicleColor = 'Grey';
  List<String> vehicleColor = [
    'Black',
    'Grey',
    'White',
    'Red',
    'Yellow',
    'Blue'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: ListView(
        children: <Widget>[
          _buildTitleHeader(),
          Center(
            child: Container(
              width: 400,
              child: Card(
                color: Colors.white,
                //shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(),
                elevation: 4,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    _cardHeader(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildWelcomeText(),
                    SizedBox(
                      height: 50,
                    ),
                    _buildFromDateSelector(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildToDateSelector(),
                    SizedBox(
                      height: 10,
                    ),
                    //_buildSelectLocationButton(),
                    _buildLocation(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildCarColorSelector(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildCarTypeSelector(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildFindVehicleButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Column(
      children: [
        _buildLatitude(),
        SizedBox(
          height: 10,
        ),
        _buildLongitude(),
        SizedBox(
          height: 10,
        ),
        _buildRadius(),
      ],
    );
  }

  Widget _buildLatitude() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Latitude',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: _latitudeController,
            onTap: _selectLocation,
            decoration: InputDecoration(
              hintText: 'Enter Latitude',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              fillColor: Color(0xFFF5F5F5),
              filled: true,
            ),

            //initialValue: _latitude.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildLongitude() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Longitude',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: _longitudeController,
            onTap: _selectLocation,
            decoration: InputDecoration(
              hintText: 'Enter Longitude',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              fillColor: Color(0xFFF5F5F5),
              filled: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadius() {
    return Column(
      children: [
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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: _radiusController,
            inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
            onTap: _selectLocation,
            decoration: InputDecoration(
              
              hintText: 'Enter Radius',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              fillColor: Color(0xFFF5F5F5),
              filled: true,
            ),

            //  initialValue: _radius.toString() + " km",
          ),
        ),
      ],
    );
  }

  void onLocationUpdated(LatLng latLng, double radius) {
    radius = radius / 1000; // convert to km
    _latitude = latLng.latitude;
    _longitude = latLng.longitude;
    _radius = radius;

    setState(() {
      _latitudeController = TextEditingController(
        text: latLng.latitude.toString(),
      );
      _longitudeController = TextEditingController(
        text: latLng.longitude.toString(),
      );
      _radiusController = TextEditingController(
        text: radius.toString(),
      );
    });
  }

  // Widget _buildSelectLocationButton() {
  //   return MaterialButton(
  //     onPressed: () async {
  //       List<dynamic> result = await Navigator.push(context,
  //           MaterialPageRoute(builder: (builder) => SelectLocationPage()));

  //       onLocationUpdated(result[0], result[1]);
  //     },
  //     color: Colors.deepPurple,
  //     textColor: Colors.white,
  //     child: Text('Select Location'),
  //   );
  // }

  Widget _buildFromDateSelector() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'From',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                fillColor: Color(0xFFF5F5F5),
                filled: true,
                hintText: 'Select Date and Time',
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: _fromSelectedDateController,
              onTap: () async {
                final DateTime? _fromDate = await _pickDate();
                if (_fromDate != null) {
                  setState(() {
                    _fromSelectedDate = _fromDate;
                  });
                  final String formattedDate =
                      DateFormat('dd-MM-yyyy').format(_fromDate);
                  _fromSelectedDateController
                    //..text = DateFormat.yMMMd().format(_fromDate)
                    ..text = formattedDate
                    ..selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: _fromSelectedDateController.text.length,
                        affinity: TextAffinity.upstream,
                      ),
                    );
                  TimeOfDay? tod = await _selectTime();
                  if (tod != null) {
                    setState(() {
                      _fromSelectedTimeOfDay = tod;
                    });
                    _fromSelectedDateController
                      ..text = formattedDate +
                          ' ' +
                          '${_fromSelectedTimeOfDay?.hour.toString().padLeft(2, '0')}:${_fromSelectedTimeOfDay?.minute.toString().padLeft(2, '0')}'
                      ..selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: _fromSelectedDateController.text.length,
                          affinity: TextAffinity.upstream,
                        ),
                      );
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToDateSelector() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'To',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                fillColor: Color(0xFFF5F5F5),
                hintText: 'Select Date and Time',
                filled: true,
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: _toSelectedDateController,
              onTap: () async {
                final DateTime? toDate = await _pickDate();
                if (toDate != null) {
                  setState(() {
                    _toDate = toDate;
                  });
                  final String formattedDate =
                      DateFormat('dd-MM-yyyy').format(toDate);
                  _toSelectedDateController
                    //..text = DateFormat.yMMMd().format(_fromDate)
                    ..text = formattedDate
                    ..selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: _toSelectedDateController.text.length,
                        affinity: TextAffinity.upstream,
                      ),
                    );
                  TimeOfDay? tod = await _selectTime();
                  if (tod != null) {
                    setState(() {
                      _toTimeOfDay = tod;
                    });
                    _toSelectedDateController
                      ..text = formattedDate +
                          ' ' +
                          '${_toTimeOfDay?.hour.toString().padLeft(2, '0')}:${_toTimeOfDay?.minute.toString().padLeft(2, '0')}'
                      ..selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: _toSelectedDateController.text.length,
                          affinity: TextAffinity.upstream,
                        ),
                      );
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarTypeSelector() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Vehicle Type (Optional)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InputDecorator(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _vehicleType,
                  items: vehicleType.map(
                    (String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _vehicleType = newValue;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarColorSelector() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Vehicle Color',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InputDecorator(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _vehicleColor,
                  items: vehicleColor.map(
                    (String color) {
                      return DropdownMenuItem(
                        value: color,
                        child: Text(
                          color,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _vehicleColor = newValue;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text _buildWelcomeText() {
    return Text(
      'Welcome to Vekognizer, add below details to find vehicles',
      style: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 15,
      ),
      textAlign: TextAlign.center,
    );
  }

  Text _cardHeader() {
    return Text(
      'Find Vehicles',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      textAlign: TextAlign.center,
    );
  }

  Padding _buildTitleHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Text(
        'Vekognizer',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 25,
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate() async {
    final DateTime? fromDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(
        2050,
        12,
        31,
      ),
      currentDate: DateTime.now(),
    );
    return fromDate;
  }

  Future<TimeOfDay?> _selectTime() async {
    final TimeOfDay? tod = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return tod;
  }

  Widget _buildFindVehicleButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MaterialButton(
            onPressed: () async {
              final service = QueryVehiclesService();
              if (_fromSelectedDate != null &&
                  _toDate != null &&
                  _fromSelectedTimeOfDay != null &&
                  _toTimeOfDay != null &&
                  _vehicleColor != null) {
                final String fromFormattedDate =
                    DateFormat('yyyy-MM-dd').format(_fromSelectedDate!);
                final String toFormattedDate =
                    DateFormat('yyyy-MM-dd').format(_toDate!);
                String fromTime =
                    "${_fromSelectedTimeOfDay?.hour.toString().padLeft(2, '0')}"
                    ":"
                    "${_fromSelectedTimeOfDay?.minute.toString().padLeft(2, '0')}";
                String toTime =
                    "${_toTimeOfDay?.hour.toString().padLeft(2, '0')}"
                    ":"
                    "${_toTimeOfDay?.minute.toString().padLeft(2, '0')}";

                List<VehicleResult> results = await service.findVehicles(
                  VehicleQuery(
                    startDate: fromFormattedDate, //2021-09-03
                    //startDate: "2021-01-01",
                    startTime: fromTime,
                    //startTime: "00:00:00",
                    vehicleInfo: VehicleInfo(
                      color: _vehicleColor!,
                      //color: "Grey",
                      type: _vehicleType!,
                      //type: "Truck",
                    ),
                    endTime: toTime,
                    //endTime: "02:00:00",
                    endDate: toFormattedDate,
                    //endDate: "2021-01-01",
                    radius: 1,
                    latitude: 0.642864,
                    longitude: -35.458403,
                  ),
                );
                debugPrint('Result: $results');
              } else {
                List<VehicleResult> results = await service.findVehicles(
                  VehicleQuery(
                    // startDate: fromDate, //2021-09-03
                    startDate: "2021-01-01",
                    // startTime: fromTime,
                    startTime: "00:00:00",
                    vehicleInfo: VehicleInfo(
                      // color: _vehicleColor!,
                      color: "Grey",
                      // type: _vehicleType!,
                      type: "Truck",
                    ),
                    // endTime: toTime,
                    endTime: "02:00:00",
                    // endDate: toDate,
                    endDate: "2021-01-01",
                    radius: 1,
                    latitude: 0.642864,
                    longitude: -35.458403,
                  ),
                );
                debugPrint('Result: $results');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SecondPage(results: results),
                  ),
                );
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            color: Colors.deepPurpleAccent.shade400,
            child: Text(
              'Find Vehicles',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _selectLocation() async {
    List<dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => SelectLocationPage(),
      ),
    );

    if (result != null) {
      onLocationUpdated(result[0], result[1]);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
