import "VehicleInfo.dart";

class VehicleResult {
  VehicleResult({
    required this.id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    // required this.vehicleInfo,
    required this.imageUrl,
    this.featureVectorPath,
  });
  int id;
  String timestamp;
  double latitude;
  double longitude;
  // VehicleInfo vehicleInfo;
  String? imageUrl;
  String? featureVectorPath;

  get datetime {
    return DateTime.parse(timestamp);
  }

  factory VehicleResult.fromJson(Map<String, dynamic> json) {
    return VehicleResult(
        id: json['id'],
        timestamp: json["Date"]["year"].toString() +
            "-" +
            json["Date"]["monthValue"].toString().padLeft(2, "0") +
            "-" +
            json["Date"]["dayOfMonth"].toString().padLeft(2, "0") +
            " " +
            json['Time']["hour"].toString().padLeft(2, "0") +
            ":" +
            json['Time']["minute"].toString().padLeft(2, "0") +
            ":" +
            json['Time']["second"].toString().padLeft(2, "0"),
        latitude: double.parse(json['Latitude']),
        longitude: double.parse(json['Longitude']),
        // vehicleInfo: VehicleInfo.fromJson(json['vehicleInfo']),
        imageUrl: json['ImageUrl']);
    // featureVectorPath: json['FeatureVectorPath']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "VehicleResult{id: $id, timestamp: $timestamp, latitude: $latitude, longitude: $longitude";
  }
}
