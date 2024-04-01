import 'package:latlong2/latlong.dart';
import 'package:location_map/location_services.dart';

class MyPoint {
  const MyPoint({required this.time, required this.location});

  final DateTime time;
  final LatLng location;

  int elapsedTime(MyPoint? other) {
    if (other == null) return 0;
    return time.difference(other.time).inMicroseconds;
  }

  double distance(MyPoint? other) {
    if (other == null) return 0;
    return LocationServices.calcDistance(other.location, location);
  }
}
