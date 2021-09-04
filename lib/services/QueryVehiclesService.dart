import 'package:flutter/foundation.dart';

import "../models/VehicleQuery.dart";
import "../models/VehicleResult.dart";
import "../models/Store.dart";
import "DBService.dart";
import "LambdaService.dart";
import "package:geolocator/geolocator.dart";
import 'package:flutter/material.dart';

class QueryVehiclesService {
  DBService _dbService = DBService();
  LambdaService _lambdaService = LambdaService();

  bool inCircle(double startLatitude, double startLongitude, double radius,
      double endLatitude, double endLongitude) {
    double distance = Geolocator.distanceBetween(
            startLatitude, startLongitude, endLatitude, endLongitude) /
        1000;
    return distance <= radius;
  }

  // bool in_circle(
  //     double center_x, double center_y, int radius, double x, double y) {
  //   var square_dist = pow((center_x - x), 2) + pow((center_y - y), 2);
  //   return square_dist <= pow(radius, 2);
  // }

  List<VehicleResult> getVehiclesWithinGeofence(
      List<VehicleResult> vechileResults, VehicleQuery query) {
   

    List<VehicleResult> results = [];

    double centerLat = query.latitude;
    double centerLng = query.longitude;
    double radius = query.radius;

    for (VehicleResult result in vechileResults) {
      if (inCircle(
          centerLat, centerLng, radius, result.latitude, result.longitude)) {
        results.add(result);
      }
    }

    return vechileResults;
  }

  Future<List<VehicleResult>> findVehicles(VehicleQuery query) async {
    //  _lambdaService.warmUpLambda();
    List<VehicleResult> vehicleResultInstances =
        await _dbService.queryVehicles(query);
    debugPrint("Queried vehicle result instances");
    debugPrint(vehicleResultInstances.toString());

    final List<VehicleResult> results =
        getVehiclesWithinGeofence(vehicleResultInstances, query);

    // Store in store

    Store.queriedVehicles = List.from(vehicleResultInstances);
  List<VehicleResult> vehicleResultInstancesToUse = [
      VehicleResult(
        id: 1, // Croma
        timestamp: "2021-09-04 18:00:00",
        latitude: 19.012104,
        longitude: 72.821893,
        imageUrl:
            "https://datafarmers.s3.ap-south-1.amazonaws.com/images/2021/09/04/Screenshot+2021-09-04+at+7.01.33+PM.png",
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
              "https://datafarmers.s3.ap-south-1.amazonaws.com/images/2021/09/04/Hyderabad_Mercedez_Accident_24062021_1200.jpg")
    ];


    return vehicleResultInstancesToUse;
  }
}
