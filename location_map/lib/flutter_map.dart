/// This is a wrapper for the Flutter package `flutter_map`.
///
/// Configured buttons, options for personalization, preferred [TileLayerOptions] and path drawing.
/// ----------------------
/// Lurvig @2022
library;

// ignore_for_file: avoid_field_initializers_in_const_classes

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:datatype_extensions/listqueue_extensions.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:platform_adaptivity/adaptive_icons.dart';
import 'package:location_map/location_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

const List<double> _kLocation = [52.0454, 8.4924];

const ColorFilter identity = ColorFilter.matrix(<double>[
  1, 0, 0, 0, 0, // disable formatter
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 1, 0,
]);

const ColorFilter invertDark = ColorFilter.matrix(<double>[
  0, -1, 0, 0, 240, // disable formatter
  0, 0, -1, 0, 280,
  -1, 0, 0, 0, 300,
  0, 0, 0, 1, 0,
]);

/// An unbounded size map widget using an open-source free map.
// ignore: must_be_immutable
class MyMap extends StatefulWidget {
  MyMap({
    super.key,
    required this.locale, // = 'de_DE',
    this.showZoomButtons = false,
    this.showLayersButton = false,
    this.showCurrentLocationMarker = true,
    this.alwaysActualizeCurrentLocation = false,
    this.markerSize = 25,
    this.markerColor,
    this.markerBcgColor,
    this.showSpeedometer = true,
    this.speedometerSize = 56,
    this.showCurrentLocation = true,
    this.fromLTRBClearance = const [0, 0, 0, 0],
    this.showLocationActualizeButton = true,
    this.routeCoordinates,
    this.routePolylines,
    this.disableFirstMover = false,
    this.centerOffset = const (0, 0),
  });

  String locale;

  /// A plus and minus button for zoom in and out on the bottom-right of the window.
  final bool showZoomButtons;

  /// A button for switching between classic and satellite maps.
  final bool showLayersButton;

  /// Set window always to center current location. If this is disabled, a button is shown that does this manually.
  final bool alwaysActualizeCurrentLocation;

  /// An aiming circle marker shows the current location on the map.
  final bool showCurrentLocationMarker;

  /// Size of the current location marker on the map.
  final double markerSize;

  /// Color of the current location marker on the map.
  ///
  /// Default value is `Theme.of(context).colorScheme.primary`.
  final Color? markerColor;

  final Color? markerBcgColor;

  /// A circle with current speed value in it `[m/s]` shown in the bottom left corner.
  final bool showSpeedometer;

  /// The size of the circle with the current speed value in `[m/s]` in the bottom left corner.
  final double speedometerSize;

  /// Current location `longitude` and `latitude` values shown in a field text in the bottom center.
  final bool showCurrentLocation;

  /// Offset for every widget on the map from the sides.
  final List<double> fromLTRBClearance;

  /// A button to update map position to current GPS location.
  final bool showLocationActualizeButton;

  /// Optional list of Coordinates which will be connected on the map with a line
  ///
  /// You should only use this variable or [routePolylines], not both.
  final List<LatLng>? routeCoordinates;

  /// Optional list of lines on the map
  ///
  /// You should only use this variable or [routeCoordinates], not both.
  List<Polyline>? routePolylines;

  final bool disableFirstMover;

  final (double, double) centerOffset;

  @override
  MyMapState createState() => MyMapState();
}

class MyMapState extends State<MyMap> {
  final MapController mapController = MapController();

  /// This can be used to get location and other GPS data to reduce redundancy.
  /// This is accessable from outside.
  late final LocationServices _locationServices = LocationServices(formatter: NumberFormat('#.######', widget.locale));
  bool terrain = false;
  final ListQueue<Polyline> _liveRoute = ListQueue();
  LatLng? _temp;

  Timer? firstMover;
  bool isLocInit = false;
  int removeAt = 1;

  LocationServices get locationServices => _locationServices;

  @override
  void initState() {
    super.initState();
    if (widget.routeCoordinates != null) createPolylines(widget.routeCoordinates!);
    if (!widget.disableFirstMover)
      firstMover = Timer.periodic(
        const Duration(milliseconds: 300),
        (Timer t) {
          isLocInit = locationServices.locationDouble.$2;
          if (!isLocInit) return;
          final List<double> loc = locationServices.locationDouble.$1;
          _offsetMoveAndRotate(widget.centerOffset, LatLng(loc[0], loc[1]), 18, 0);
          firstMover!.cancel();
        },
      );
  }

  @override
  void dispose() {
    firstMover?.cancel();
    super.dispose();
  }

  ({bool moveSuccess, bool rotateSuccess}) _offsetMoveAndRotate(
    (double, double) offset,
    LatLng center,
    double zoom,
    double degree, {
    String? id,
  }) {
    return mapController.moveAndRotate(LatLng(center.latitude + offset.$1, center.longitude + offset.$2), zoom, degree, id: id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: locationServices.locationStream,
      builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
        final double latitude = snapshot.data?[0] ?? _kLocation[0];
        final double longitude = snapshot.data?[1] ?? _kLocation[1];
        if (widget.alwaysActualizeCurrentLocation)
          try {
            _offsetMoveAndRotate(widget.centerOffset, LatLng(latitude, longitude), 18, 0);
          } catch (_) {}
        return Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(latitude + widget.centerOffset.$1, longitude + widget.centerOffset.$2),
                initialZoom: 13.0,
              ),
              children: [
                terrain
                    ? TileLayer(
                        wmsOptions: WMSTileLayerOptions(
                          baseUrl: 'https://{s}.s2maps-tiles.eu/wms/?',
                          layers: const ['s2cloudless-2018_3857'],
                        ),
                        subdomains: const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
                      ) // satellite view
                    : ColorFiltered(
                        colorFilter: Theme.of(context).brightness == Brightness.light ? identity : invertDark,
                        child: TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          tileProvider: _CachedTileProvider(),
                        ),
                      ), // normal view
                if (widget.routeCoordinates != null) PolylineLayer(polylines: createPolylines(widget.routeCoordinates!)),
                if (widget.routePolylines != null) PolylineLayer(polylines: widget.routePolylines!),
                if (_liveRoute.isNotEmpty) PolylineLayer(polylines: _liveRoute.toList()),
                MarkerLayer(
                  markers: [
                    if (widget.showCurrentLocationMarker)
                      PulsatingLocationMarker(
                        size: widget.markerSize,
                        point: LatLng(latitude, longitude),
                      ),
                    if (widget.routeCoordinates != null || widget.routePolylines != null)
                      Marker(
                        width: widget.markerSize,
                        height: widget.markerSize * 2,
                        point: widget.routeCoordinates != null ? widget.routeCoordinates!.first : widget.routePolylines!.first.points.first,
                        child: _RouteMarker(
                          size: widget.markerSize,
                          bcgColor: widget.markerBcgColor ?? Theme.of(context).colorScheme.surface,
                          iconColor: widget.markerColor ?? Theme.of(context).colorScheme.primary,
                          isStart: true,
                        ),
                      ), // Start marker
                    if (widget.routeCoordinates != null || widget.routePolylines != null)
                      Marker(
                        width: widget.markerSize,
                        height: widget.markerSize * 2,
                        point: widget.routeCoordinates != null ? widget.routeCoordinates!.last : widget.routePolylines!.last.points.last,
                        child: _RouteMarker(
                          size: widget.markerSize,
                          bcgColor: widget.markerBcgColor ?? Theme.of(context).colorScheme.surface,
                          iconColor: widget.markerColor ?? Theme.of(context).colorScheme.primary,
                          isStart: false,
                        ),
                      ), // Finish marker
                  ],
                ),
                if (widget.showZoomButtons)
                  const FlutterMapZoomButtons(
                    minZoom: 4,
                    maxZoom: 19,
                    mini: true,
                    padding: 10,
                    alignment: Alignment.bottomRight,
                  ),
              ],
            ),
            Positioned(
              top: widget.fromLTRBClearance[1] + 20,
              right: widget.fromLTRBClearance[2] + 20,
              child: Column(
                children: [
                  if (!widget.alwaysActualizeCurrentLocation && widget.showLocationActualizeButton)
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      onPressed: () => _offsetMoveAndRotate(widget.centerOffset, LatLng(latitude, longitude), 18, 0),
                      child: Icon(
                        Icons.gps_fixed,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  if (widget.showLayersButton || !widget.alwaysActualizeCurrentLocation) const SizedBox(height: 20),
                  if (widget.showLayersButton)
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      onPressed: () => setState(() => terrain = !terrain),
                      child: Icon(
                        CupertinoIcons.layers_fill,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            if (widget.showSpeedometer)
              Positioned(
                left: 20,
                bottom: widget.fromLTRBClearance[3] + 35,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.surface, //widget.speedometerSize
                  onPressed: () {},
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<double>(
                            stream: locationServices.speedStream,
                            builder: (context, AsyncSnapshot<double> snapshot) => Text(
                                  snapshot.hasData ? NumberFormat('0.#').format(snapshot.data) : '0',
                                  style: TextStyle(
                                    fontSize: widget.speedometerSize / 3,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )),
                        Text(
                          'm/s',
                          style: TextStyle(
                            fontSize: widget.speedometerSize / 4,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (widget.showCurrentLocation)
              Positioned(
                bottom: widget.fromLTRBClearance[3],
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    padding: const EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
                    child: Text(
                      locationServices.locationString ?? 'lat: - long: -',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<Polyline> createPolylines(List<LatLng> positions) {
    final List<Polyline> polylines = [];
    for (int i = 1; i < positions.length; i++) {
      polylines.add(
        Polyline(
          strokeWidth: 5,
          color: Colors.red,
          points: [positions[i - 1], positions[i]],
        ),
      );
    }
    return polylines;
  }

  void addPointToRoute() {
    const double strokeWidth = 3.5;
    final Color color = Theme.of(context).colorScheme.primary;
    const int maxPolylines = 130;
    final List<double> now = locationServices.locationDouble.$1;
    final LatLng nowLL = LatLng(now[0], now[1]);
    late List<LatLng> line;
    if (_liveRoute.isEmpty) {
      if (_temp == null) {
        _temp = nowLL;
        return;
      } else {
        if (_temp != nowLL)
          line = [_temp!, nowLL];
        else
          return;
        _temp = null;
      }
    } else {
      final LatLng prevLL = _liveRoute.last.points[1];
      if (prevLL != nowLL)
        line = [prevLL, nowLL];
      else
        return;
    }
    if (_liveRoute.length > maxPolylines) {
      if (removeAt >= _liveRoute.length) removeAt = 1;
      _liveRoute.removeAt(removeAt);
      removeAt++;
    }
    _liveRoute.add(
      Polyline(
        strokeWidth: strokeWidth,
        color: color,
        points: line,
      ),
    );
    setState(() {});
  }

  void clearRoute() => _liveRoute.clear();
}

const double _pulseMaxFactor = 3;
const double _pulseMinFactor = 2;

class PulsatingLocationMarker extends Marker {
  PulsatingLocationMarker({
    this.size = 30.0,
    this.color,
    required super.point,
  }) : super(
          width: size * _pulseMaxFactor,
          height: size * _pulseMaxFactor * 2,
          child: PulsatingLocationMarkerWidget(
            markerSize: size,
            markerColor: color,
          ),
        );

  final double size;
  final Color? color;
}

class PulsatingLocationMarkerWidget extends StatefulWidget {
  const PulsatingLocationMarkerWidget({
    super.key,
    this.markerSize = 30,
    this.markerColor,
  });

  final double markerSize;
  final Color? markerColor;

  @override
  State<PulsatingLocationMarkerWidget> createState() => _PulsatingLocationMarkerState();
}

class _PulsatingLocationMarkerState extends State<PulsatingLocationMarkerWidget> with SingleTickerProviderStateMixin {
  late Tween<double> _pulsateTween;
  late AnimationController _animationController;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  static const Duration _duration = Duration(seconds: 2);

  @override
  void initState() {
    _pulsateTween = Tween<double>(begin: _pulseMinFactor, end: _pulseMaxFactor);
    _animationController = AnimationController(vsync: this, duration: _duration)
      ..repeat(reverse: true)
      ..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ScaleTransition(
          scale: _pulsateTween.animate(_animation),
          child: Icon(
            Icons.circle,
            color: (widget.markerColor ?? Theme.of(context).colorScheme.primary).withOpacity(.25),
            size: widget.markerSize,
          ),
        ),
        Container(
          width: widget.markerSize,
          height: widget.markerSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        Container(
          width: widget.markerSize * 0.75,
          height: widget.markerSize * 0.75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.markerColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class FlutterMapZoomButtons extends StatelessWidget {
  const FlutterMapZoomButtons({
    super.key,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.mini = true,
    this.padding = 2.0,
    this.alignment = Alignment.topRight,
  });

  final double minZoom;
  final double maxZoom;
  final bool mini;
  final double padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final controller = MapController.of(context);
    final camera = MapCamera.of(context);
    final theme = Theme.of(context);
    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: padding, top: padding, right: padding),
            child: FloatingActionButton(
              heroTag: 'zoomInButton',
              mini: mini,
              backgroundColor: theme.primaryColor,
              onPressed: () {
                final double zoom = min(camera.zoom + 1, maxZoom);
                controller.move(camera.center, zoom);
              },
              child: Icon(AdaptiveIcons.plus, color: theme.iconTheme.color),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: FloatingActionButton(
              heroTag: 'zoomOutButton',
              mini: mini,
              backgroundColor: theme.primaryColor,
              onPressed: () {
                final zoom = max(camera.zoom - 1, minZoom);
                controller.move(camera.center, zoom);
              },
              child: Icon(AdaptiveIcons.minus, color: theme.iconTheme.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _CachedTileProvider extends TileProvider {
  _CachedTileProvider();
  @override
  ImageProvider getImage(TileCoordinates coords, TileLayer options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
      //Now you can set options that determine how the image gets cached via whichever plugin you use.
    );
  }
}

class _RouteMarker extends StatelessWidget {
  const _RouteMarker({required this.size, required this.iconColor, required this.bcgColor, required this.isStart});

  final double size;
  final Color iconColor;
  final Color bcgColor;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            RotatedBox(
              quarterTurns: -1,
              child: Icon(
                AdaptiveIcons.bubble_left,
                color: bcgColor,
                size: size,
              ),
            ),
            Icon(
              isStart ? Icons.directions_run_rounded : CupertinoIcons.flag_fill,
              color: iconColor,
              size: size * .6,
            ),
          ],
        ),
      ],
    );
  }
}
