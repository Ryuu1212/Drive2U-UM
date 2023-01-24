import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:um_ehailing/constants.dart';

class MapScreen extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;
  const MapScreen(
      {super.key, required this.startPoint, required this.endPoint});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _initialPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialPosition = CameraPosition(target: widget.startPoint, zoom: 14.5);
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers = {
      Marker(markerId: const MarkerId('start'), position: widget.startPoint),
      Marker(markerId: const MarkerId('end'), position: widget.endPoint),
    };

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
        body: GoogleMap(
          initialCameraPosition: _initialPosition, markers: Set.from(_markers),
        ));
  }
}
