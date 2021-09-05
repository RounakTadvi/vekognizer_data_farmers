import 'package:flutter/foundation.dart';

import "../models/VehicleQuery.dart";
import "../models/VehicleResult.dart";

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:flutter/material.dart';

class DBService {
  static const String _dbBaseURL =
      "ce557233-bf4d-4818-bfae-eddf82dc78f9-asia-south1.apps.astra.datastax.com";
    static const String _vehiclesByColorAPIEndpoint =
      "/api/rest/v2/keyspaces/test/vehicles_by_color";
  static const String _vehiclesByColorTypeAPIEndpoint =
      "/api/rest/v2/keyspaces/test/vehicles_by_color_type";


  Future<List<VehicleResult>> queryVehicles(VehicleQuery vehicleQuery) async {
    Holder vehicleResultsJSON = await makeRequest(vehicleQuery);
    debugPrint("==========================");
    debugPrint(vehicleResultsJSON.count.toString());


    List<VehicleResult> vehicleResults = [];
    int idx = 0;
    var v = vehicleResultsJSON.data![0] as Map<String, dynamic>;

    var vehicles = [];
    for (var vehicle in vehicleResultsJSON.data!) {
      vehicles.add(vehicle as Map<String, dynamic>);
    }
    // debugPrint(vehicles.toString());
    debugPrint("=================================");
    for (Map<String, dynamic> vehicle in vehicles) {

      vehicle["id"] = idx;

      vehicle["vehicleInfo"] = {
        "Color": vehicle["Color"],
        "Type": vehicle["Type"],
      };

      vehicleResults
          .add(VehicleResult.fromJson(vehicle as Map<String, dynamic>));
      idx += 1;
    }

    return Future.value(vehicleResults);
  }

  Map<String, dynamic> addFilteringConditions(
      Map<String, dynamic> query, VehicleQuery vehicleQuery) {
    query["Color"] = {
      "\$eq": vehicleQuery.vehicleInfo.color,
    };

    if (vehicleQuery.vehicleInfo.type != null) {
      query["Type"] = {
        "\$eq": vehicleQuery.vehicleInfo.type,
      };
    }

    return query;
  }

  String getAPIEndpoint(VehicleQuery vehicleQuery) {
    if (vehicleQuery.vehicleInfo.type == null) {
      return _vehiclesByColorAPIEndpoint;
    }
    return _vehiclesByColorTypeAPIEndpoint;
  }

  Uri constructURIForSingleDate(VehicleQuery vehicleQuery) {
  
    Map<String, dynamic> query = {
      "Date": {"\$eq": vehicleQuery.startDate},
      "Time": {"\$gte": vehicleQuery.startTime, "\$lte": vehicleQuery.endTime}
    };

    query = addFilteringConditions(query, vehicleQuery);
    final uri = Uri.parse(
        'https://${_dbBaseURL}${getAPIEndpoint(vehicleQuery)}?where=${json.encode(query).toString()}&fields=Date,Time,ImageUrl,Latitude,Longitude');
    return uri;
  }

  List<Uri> constructURIsForMultipleDates(VehicleQuery vehicleQuery) {
    List<Uri> uris = [];

    Map<String, dynamic> query1 = {
      "Date": {"\$eq": vehicleQuery.startDate},
      "Time": {"\$gte": vehicleQuery.startTime}
    };
    query1 = addFilteringConditions(query1, vehicleQuery);
    final uri1 = Uri.parse(
        'https://${_dbBaseURL}${getAPIEndpoint(vehicleQuery)}?where=${json.encode(query1).toString()}&fields=Date,Time,ImageUrl,Latitude,Longitude');

    uris.add(uri1);

    DateTime startDate = DateTime.parse(vehicleQuery.startDate);
    DateTime endDate = DateTime.parse(vehicleQuery.endDate!);

    List<DateTime> daysInBetween = getDaysInBeteween(startDate, endDate);
    List<String> strDatesInBetween =
        daysInBetween.map((e) => e.toString().split(" ")[0]).toList();
    Map<String, dynamic> tempQuery;
    Uri tempUri;
    if (strDatesInBetween.length >= 1) {
      for (var strDate in strDatesInBetween) {
        tempQuery = {
          "Date": {"\$eq": strDate},
        };
        tempQuery = addFilteringConditions(tempQuery, vehicleQuery);
        tempUri = Uri.parse(
            'https://${_dbBaseURL}${getAPIEndpoint(vehicleQuery)}?where=${json.encode(tempQuery).toString()}&fields=Date,Time,ImageUrl,Latitude,Longitude');
        uris.add(tempUri);
      }
    }

    Map<String, dynamic> query3 = {
      "Date": {"\$eq": vehicleQuery.endDate},
      "Time": {"\$lte": vehicleQuery.endTime}
    };
    query3 = addFilteringConditions(query3, vehicleQuery);
    final uri3 = Uri.parse(
        'https://${_dbBaseURL}${getAPIEndpoint(vehicleQuery)}?where=${json.encode(query3).toString()}&fields=Date,Time,ImageUrl,Latitude,Longitude');
    uris.add(uri3);

    return uris;
  }

  Future<Holder> makeRequest(VehicleQuery vehicleQuery) async {
    // var response;
    if (vehicleQuery.endDate == vehicleQuery.startDate) {
      debugPrint("Single date");
      var response = await http.get(
        constructURIForSingleDate(vehicleQuery),
        headers: {
          'content-type': 'application/json',
          "X-Cassandra-Token":
              "AstraCS:1234"
        },
      );
      debugPrint(response.body);
      return Holder.fromJson(json.decode(response.body));
      // return json.decode(response.body);
    } else {
      List<Uri> uris = constructURIsForMultipleDates(vehicleQuery);
      List<Future> futures = [];
      for (var uri in uris) {
        futures.add(http.get(uri, headers: {
          'content-type': 'application/json',
          "X-Cassandra-Token":
              "AstraCS:1234"
        }));
      }

      var response = await Future.wait(futures);
      debugPrint(response.toString());

      List<Holder> holders =
          response.map((e) => Holder.fromJson(json.decode(e.body))).toList();

      int count = 0;
      List<dynamic> data = [];

      debugPrint(holders.toString());

      for (var holder in holders) {
        data.addAll(holder.data!);
        count += holder.count!;
      }

      return Holder(count: count, data: data);
    }

  }

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 1; i < endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }
}

class Holder {
  int? count;
  List<dynamic>? data;

  Holder({this.count, this.data});

  factory Holder.fromJson(Map<String, dynamic> json) {
    return Holder(
      count: json['count'] as int,
      data: json['data'] as List<dynamic>,
    );
  }
}
