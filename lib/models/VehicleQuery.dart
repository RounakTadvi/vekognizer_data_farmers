import "VehicleInfo.dart";

class VehicleQuery {
  VehicleQuery({
    required this.startDate,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.vehicleInfo,
    this.endDate,
    this.startTime,
    this.endTime,
  });

  String startDate;
  String? endDate;
  String? startTime = "00:00:00";
  String? endTime = "23:59:59";
  double latitude;
  double longitude;
  double radius;
  VehicleInfo vehicleInfo;
}
