import 'package:data_farmers_pre/models/VehicleInfo.dart';
import 'package:data_farmers_pre/models/VehicleQuery.dart';
import 'package:data_farmers_pre/services/QueryVehiclesService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Holds From Date
  DateTime? _fromSelectedDate;

  /// Holds From Time
  TimeOfDay? _fromSelectedTimeOfDay;

  /// Holds To Date
  DateTime? _fromToDate;

  /// Holds From TO Time
  TimeOfDay? _fromToTimeOfDay;

  List<String> vehicleType = ['SUV', 'Sedan'];
  String? _vehicleType = 'SUV';
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
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('From:  '),
              TextButton(
                onPressed: () async {
                  final DateTime? fromDate = await _pickDate();
                  if (fromDate != null) {
                    setState(() {
                      _fromSelectedDate = fromDate;
                    });
                    TimeOfDay? tod = await _selectTime();
                    if (tod != null) {
                      setState(() {
                        _fromSelectedTimeOfDay = tod;
                      });
                    }
                  }
                },
                child: Text(_fromSelectedDate != null &&
                        _fromSelectedTimeOfDay != null
                    ? '${_fromSelectedDate?.day}/${_fromSelectedDate?.month}/${_fromSelectedDate?.year} ${_fromSelectedTimeOfDay?.hour}:${_fromSelectedTimeOfDay?.minute}'
                    : 'Select Date and Time'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('To:  '),
              TextButton(
                onPressed: () async {
                  final DateTime? toDate = await _pickDate();
                  if (toDate != null) {
                    setState(() {
                      _fromToDate = toDate;
                    });
                    TimeOfDay? tod = await _selectTime();
                    if (tod != null) {
                      setState(() {
                        _fromToTimeOfDay = tod;
                      });
                    }
                  }
                },
                child: Text(_fromToDate != null && _fromToTimeOfDay != null
                    ? '${_fromToDate?.day}/${_fromToDate?.month}/${_fromToDate?.year} ${_fromToTimeOfDay?.hour}:${_fromToTimeOfDay?.minute}'
                    : 'Select Date and Time'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Vehicle Type: '),
              DropdownButton<String>(
                value: _vehicleType,
                items: vehicleType.map(
                  (String type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Vehicle Color: '),
              DropdownButton<String>(
                value: _vehicleColor,
                items: vehicleColor.map(
                  (String color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Text(
                        color,
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Latitude',
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.10,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Longitude',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              final service = QueryVehiclesService();
              String fromDate = _fromSelectedDate.toString().split(' ')[0];
              String toDate = _fromToDate.toString().split(' ')[0];
              String fromTime =
                  "${_fromSelectedTimeOfDay?.hour.toString().padLeft(2, '0')}"
                  ":"
                  "${_fromSelectedTimeOfDay?.minute.toString().padLeft(2, '0')}";
              String toTime =
                  "${_fromToTimeOfDay?.hour.toString().padLeft(2, '0')}"
                  ":"
                  "${_fromToTimeOfDay?.minute.toString().padLeft(2, '0')}";
              var result = await service.findVehicles(
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

              debugPrint(result.toString());
            },
            child: Text('Find matching vehicles'),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> _selectTime() async {
    final TimeOfDay? tod = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return tod;
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
}
