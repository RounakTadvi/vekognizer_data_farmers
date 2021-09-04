import 'package:flutter/material.dart';

import "../models/VehicleResult.dart";

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class LambdaService {
  static const String _findSameVehicleAPI =
      "https://v42lj5b4p4.execute-api.ap-south-1.amazonaws.com/prod/compare_fv";

  warmUpLambda() {
    try {
      http.post(Uri.parse(_findSameVehicleAPI));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<dynamic>> findSameVehicleResultInstances(
      VehicleResult selectedVehicleResult,
      List<VehicleResult> queriedVehiclesResults) async {
    // Map<String, dynamic> requestData = {
    //   "selected_vehicle": {
    //     "id": selectedVehicleResult.id,
    //     "feature_vector_path": selectedVehicleResult.featureVectorPath,
    //   },
    //   "queried_vehicles": queriedVehiclesResults
    //       .map((vehicleResult) => {
    //             "id": vehicleResult.id,
    //             "feature_vector_path": vehicleResult.featureVectorPath,
    //           })
    //       .toList()
    // };

    var requestData = {
      "selected_vehicle": {
        "id": 0,
        "feature_vector_path":
            "datafarmers/feature_vectors/2021/9/3/query.pickle"
      },
      "queried_vehicles": [
        {
          "id": 2,
          "feature_vector_path": "datafarmers/feature_vectors/2021/9/3/a.pickle"
        },
        {
          "id": 1,
          "feature_vector_path":
              "datafarmers/feature_vectors/2021/9/3/match.pickle"
        },
        {
          "id": 4,
          "feature_vector_path": "datafarmers/feature_vectors/2021/9/3/b.pickle"
        }
      ]
    };

    var response = await makeRequest(requestData);
    // debugPrint(response.toString());

    // Map<String, dynamic> response = {
    //   "vehicle_result_instances_ids": [0, 1]
    // };

    List<dynamic> vehicle_result_instances_ids =
        response["vehicle_result_instances_ids"];

    return vehicle_result_instances_ids;
  }

  Future<Map<String, dynamic>> makeRequest(
      Map<String, dynamic> requestBody) async {
    http.Response response = await http.post(
      Uri.parse(_findSameVehicleAPI),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(requestBody),
    );
    debugPrint(response.toString());
    debugPrint(response.body.toString());
    return json.decode(response.body);
  }
}
