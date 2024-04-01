/// This is a wrapper for the Flutter package `location`.
///
/// Can be used to get current location as `List<double>` or `String`, current speed and calculate distance.
/// ----------------------
/// Lurvig @2022
library;

import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

//import 'package:bivital/modules/plot/src/plot_shared_prefs.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

final LatLng _kLocation = LatLng(52.0454, 8.4924);

/// Get location information of device.
///
/// This object must be initialized by calling `initialize()`!
class LocationServices {
  LocationServices({
    required NumberFormat? formatter,
  }) : _formatter = formatter ?? NumberFormat('#.######', 'de_DE') {
    _initialize();
  }

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  final Location _location = Location();
  LocationData? _locationData;
  final NumberFormat _formatter;
  double _totalDistance = 0;
  double _lat1 = 0;
  double _lon1 = 0;

  /// Checks whether location service is enabled, whether permission is granted and listens for location data
  Future<void> _initialize() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return;
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }
    _locationData = await _location.getLocation();
    //location.enableBackgroundMode();
    // rest of the app still doesn't run in the background
    // but the permanent notification was pretty annoying
    // hint: if ever want to implement, enable this on measurement start
    // and disable it on measurement stop
    _location.onLocationChanged.listen((LocationData currentLocation) => _locationData = currentLocation);
  }

  Stream<List<double>> get locationStream => _location.onLocationChanged.map((LocationData e) => [e.latitude ?? _kLocation.latitude, e.longitude ?? _kLocation.longitude]);

  /// Get current gps location data as a concatenated `string`.
  String? get locationString {
    if (_locationData == null) return null;
    return 'lat: ${_formatter.format(_locationData!.latitude)} long: ${_formatter.format(_locationData!.longitude)}';
  }

  /// Get current gps location data as a `double array` `[latitude, longitude]`.
  (List<double>, bool) get locationDouble {
    if (_locationData == null || _locationData!.latitude == null || _locationData!.longitude == null) return ([_kLocation.latitude, _kLocation.longitude], false);
    return ([_locationData!.latitude!, _locationData!.longitude!], true);
  }

  /// Get current gps location data as a `double array` `[latitude, longitude]`.
  LatLng get location {
    if (_locationData == null || _locationData!.latitude == null || _locationData!.longitude == null) return _kLocation;
    return LatLng(_locationData!.latitude!, _locationData!.longitude!);
  }

  /// Returns current speed.
  ///
  /// Gets it directly from API.
  double get speed => (_locationData?.speed ?? 0).abs();

  /// Returns a stream of speed value directly from API.
  Stream<double> get speedStream => _location.onLocationChanged.map((LocationData e) => (e.speed ?? 0).abs());

  /// Sets [_totalDistance] to `0`. Use this to reset distance measurement.
  void resetDistance() => _totalDistance = 0;

  /// Looks for current location, and adds distance to last location to [_totalDistance].
  double get distance {
    final double lat2 = locationDouble.$1[0];
    final double lon2 = locationDouble.$1[1];
    final distance = calcDistance(LatLng(_lat1, _lon1), LatLng(lat2, lon2));
    _lat1 = lat2;
    _lon1 = lon2;
    return _totalDistance += distance;
  }

  /// Calculates the distance between two [LatLng] locations.
  static double calcDistance(LatLng previous, LatLng current) {
    final double lat1 = previous.latitude;
    final double lon1 = previous.longitude;
    final double lat2 = current.latitude;
    final double lon2 = current.longitude;
    const double p = 0.017453292519943295;
    const Function c = cos;
    final double a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
