import "VehicleInfo.dart";
import "VehicleResult.dart";

class VehicleRoute {
  const VehicleRoute({
    this.vehicleInfo,
    this.vehicleResults,
  });
  final VehicleInfo? vehicleInfo;
  final List<VehicleResult>?
      vehicleResults; // Multiple spottings of the same vehicle

  @override
  String toString() {
    return "VehicleResults: ${vehicleResults.toString()}";
  }
}
