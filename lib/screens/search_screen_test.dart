import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:um_ehailing/config.dart';
import 'package:um_ehailing/constants.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(3.154430, 101.715103), zoom: 14.0);

  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: const Text('Search places'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          // ElevatedButton(
          //   onPressed: _handlePressedButton,
          //   child: const Text('Search places'),
          // ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Container(
                  // height: 50,
                  // margin: const EdgeInsets.symmetric(vertical: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 2.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: TextField(
                      keyboardType: TextInputType.text,
                      // controller: _startSearchFieldController,
                      textAlignVertical: TextAlignVertical.center,
                      cursorHeight: 30,
                      cursorColor: kTextColor,
                      readOnly: false,
                      // autofocus: true,
                      showCursor: true,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Where to?",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                        icon: Image.asset("assets/icons/button.png",
                            width: 20, height: 20),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _OnType();
                        } else {
                          // clear the value
                        }
                      }),
                ),
                const SizedBox(height: 10),
                Container(
                  // height: 50,
                  // margin: const EdgeInsets.symmetric(vertical: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 2.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: TextField(
                      keyboardType: TextInputType.text,
                      // controller: _endSearchFieldController,
                      textAlignVertical: TextAlignVertical.center,
                      cursorHeight: 30,
                      cursorColor: kTextColor,
                      readOnly: false,
                      // autofocus: true,
                      showCursor: true,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Where to?",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                        icon: Image.asset("assets/icons/placeholder.png",
                            width: 22, height: 22),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          // placeAutoComplete(value);
                        } else {
                          // clear the value
                        }
                      }),
                ),
              ])),
        ],
      ),
    );
  }

  Future<void> _OnType() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApi,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [''],
        // decoration: InputDecoration(
        //   hintText: ('Search places'),
        //   focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(20),
        //     borderSide: BorderSide(color: Colors.white),
        //   ),
        // ),
        components: [Component(Component.country, "my")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
    print(p);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApi,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }
}
