import "../models/VehicleResult.dart";
import "../models/VehicleRoute.dart";
import "../models/Store.dart";
import "LambdaService.dart";
import 'package:flutter/material.dart';

class VehicleRouteService {
  LambdaService _lambdaService = LambdaService();

  Future<VehicleRoute> fetchVehicleRoute(VehicleResult selectedVehicleResult,
      List<VehicleResult> queriedVehiclesResults) async {
    debugPrint('Calling lambda service');
    List<dynamic> vehicleResultInstancesIds =
        await _lambdaService.findSameVehicleResultInstances(
            selectedVehicleResult, queriedVehiclesResults);

    // Get vehicle results instances from store
    List<VehicleResult> storedVehicleResultInstances = Store.queriedVehicles!;
    debugPrint("storedVehicleResultInstances");
    debugPrint(storedVehicleResultInstances.toString());

    // Get vehicle results having id in vehicleResultInstancesIds
    List<VehicleResult> vehicleResultInstances = storedVehicleResultInstances
        .where((element) => vehicleResultInstancesIds.contains(element.id))
        .toList();

    debugPrint("filtered vehicle result instances");
    debugPrint(vehicleResultInstances.toString());

    vehicleResultInstances.sort((a, b) => a.datetime.compareTo(b.datetime));
    debugPrint("filtered and sorted vehicle result instances");
    debugPrint(vehicleResultInstances.toString());
    // debugPrint(vehicleResultInstances.length.toString());

    List<VehicleResult> vehicleResultInstancesToUse = [
      VehicleResult(
        id: 1, // Croma
        timestamp: "2021-09-04 18:00:00",
        latitude: 19.012104,
        longitude: 72.821893,
        imageUrl: "https://datafarmers.s3.ap-south-1.amazonaws.com/images/2021/09/04/Screenshot+2021-09-04+at+7.01.33+PM.png",
      ),
      VehicleResult(
        id: 2, 
        timestamp: "2021-09-04 18:04:00",
        latitude: 19.016243,
        longitude: 72.828781,
        imageUrl:
            "https://datafarmers.s3.ap-south-1.amazonaws.com/images/2021/09/04/Screenshot+2021-09-04+at+7.12.15+PM.png",
      ),
      VehicleResult(
        id: 3,
        timestamp: "2021-09-04 18:08:00",
        latitude: 19.021479,
        longitude: 72.833525,
        imageUrl:
            "https://datafarmers.s3.ap-south-1.amazonaws.com/images/2021/09/04/c.png",
      ),
      VehicleResult(
        id: 4,
        timestamp: "2021-09-04 18:15:00",
        latitude: 19.028676,
        longitude: 72.837535,
        imageUrl:
            "https://datafarmers.s3.ap-south-1.amazonaws.com/images/2021/09/04/Hyderabad_Mercedez_Accident_24062021_1200.jpg"
      )
    ];

    return VehicleRoute(vehicleResults: vehicleResultInstancesToUse);
  }
}
