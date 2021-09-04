class VehicleInfo {
  VehicleInfo({
    required this.color,
    this.type,
    // this.registration_plate_number,
  });
  String color;
  String? type;
  // String? registration_plate_number;

  Map<String, dynamic> toJson() {
    return {
      // "type": convertVehicleTypeToString(type),
      // "registration_plate_number": registration_plate_number,
      "color": color,
    };
  }

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
        // type: VehicleType.values[json["type"]],
        //  registration_plate_number: json["registration_plate_number"],
        type: json["Type"],
        color: json['Color']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'VehicleInfo(color: $color, type: $type)';
  }
}
