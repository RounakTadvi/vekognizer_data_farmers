import 'package:data_farmers_pre/models/VehicleResult.dart';
import 'package:data_farmers_pre/models/VehicleRoute.dart';
import 'package:data_farmers_pre/presentation/pages/vehicle_route_page.dart';
import 'package:data_farmers_pre/services/VehicleRouteService.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({
    required this.results,
    Key? key,
  }) : super(
          key: key,
        );

  final List<VehicleResult> results;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<VehicleResult> get vehicleResults => widget.results;
  final ScrollController _scrollController = ScrollController();
  int selectedIdx = -1;

  VehicleRouteService vehicleRouteService = VehicleRouteService();
  String btnText = "Find Vehicle Route";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectedIdx == -1
          ? null
          : MaterialButton(
              textColor: Colors.white,
              color: Colors.deepPurple,
              onPressed: () async {
                setState(() {
                  btnText = "Finding...";
                });
                debugPrint("Find Vehicle Route Button Pressed");
                VehicleResult selectedVehicleResult =
                    vehicleResults[selectedIdx];
                List<VehicleResult> otherVehicles = List.from(vehicleResults);
                otherVehicles.removeAt(selectedIdx);
                VehicleRoute vehicleRoute = await vehicleRouteService
                    .fetchVehicleRoute(selectedVehicleResult, otherVehicles);
                debugPrint(
                  "Vehicle Route: ${vehicleRoute.toString()}",
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VehicleRoutePage(
                      route: vehicleRoute,
                    ),
                  ),
                );
              },
              child: Text(btnText),
            ),
      body: Scrollbar(
        controller: _scrollController,
        child: GridView.count(
          crossAxisCount: 3,
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: List.generate(
            vehicleResults.length,
            (i) {
              return GestureDetector(
                onTap: () {
                  debugPrint(vehicleResults[i].id.toString());
                  setState(() {
                    selectedIdx = i;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Opacity(
                        opacity: selectedIdx == i ? 0.4 : 1.0,
                        child: Container(
                          height: 300,
                          width: 300,
                          child: Image.network(
                            vehicleResults[i].imageUrl!,
                            fit: BoxFit.fill,
                            // 'https://datafarmers.s3.ap-south-1.amazonaws.com/images/2021/9/3/s60-exterior-right-front-three-quarter-3.jpeg',
                          ),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      Text(vehicleResults[i].timestamp),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
