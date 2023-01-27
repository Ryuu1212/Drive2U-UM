import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:um_ehailing/config.dart';
import 'package:um_ehailing/constants.dart';
import '../components/network_utility.dart';
import '../models/map_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/panel_widget.dart';

class MapScreen extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;
  final double startPointLat;
  final double startPointLng;
  final double endPointLat;
  final double endPointLng;
  final String startPlaceId;
  final String endPlaceId;

  const MapScreen(
      {super.key,
      required this.startPoint,
      required this.endPoint,
      required this.startPointLat,
      required this.startPointLng,
      required this.endPointLat,
      required this.endPointLng,
      required this.startPlaceId,
      required this.endPlaceId});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _initialPosition;

  List<LatLng> polyLineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kGoogleApi,
        PointLatLng(widget.startPointLat, widget.startPointLng),
        PointLatLng(widget.endPointLat, widget.endPointLng));
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polyLineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  Future<dynamic> getRouteDetails() async {
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/directions/json', {
      "units": "metric",
      "key": kGoogleApi,
      "origin": "place_id:${widget.startPlaceId}",
      "destination": "place_id:${widget.endPlaceId}",
      "mode": "driving"
    });

    String? response = await NetworkUtility.fetchUrl(uri);
    var jsonRouteDetails = jsonDecode(response!);
    String stringPlaceDetails = jsonEncode(jsonRouteDetails);
    Map<String, dynamic> routeDetails = jsonDecode(stringPlaceDetails);
    return routeDetails;
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
    _initialPosition = CameraPosition(target: widget.startPoint, zoom: 14.5);
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers = {
      Marker(
        markerId: const MarkerId('start'),
        position: widget.startPoint,
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: widget.endPoint,
      ),
    };

    final panelHeightClossed = MediaQuery.of(context).size.height * 0.3;
    final panelHeightOpened = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: SlidingUpPanel(
          minHeight: panelHeightClossed,
          maxHeight: panelHeightOpened,
          parallaxEnabled: true,
          parallaxOffset: .5,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          body: GoogleMap(
            initialCameraPosition: _initialPosition,
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: polyLineCoordinates,
                color: Colors.black,
                width: 5,
              )
            },
            markers: Set.from(_markers),
            onMapCreated: (GoogleMapController controller) {
              Future.delayed(const Duration(milliseconds: 2000), () {
                controller.animateCamera(CameraUpdate.newLatLngBounds(
                    MapUtils.boundsFromLatLngList(
                        _markers.map((loc) => loc.position).toList()),
                    1));
              });
            },
          ),
          panelBuilder: (controller) => PanelWidget(
            controller: controller,
          ),
        ));
  }
}
