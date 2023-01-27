import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:um_ehailing/constants.dart';
import 'package:um_ehailing/config.dart';

import 'package:um_ehailing/components/network_utility.dart';
import 'package:um_ehailing/models/place_autocomplete_prediction.dart';
import 'package:um_ehailing/models/place_autocomplete_response.dart';
import 'package:um_ehailing/screens/map_screen.dart';
import 'package:um_ehailing/widgets/location_list_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  /*
  TO DO
  multiple stops 
  */

  dynamic startPosition;
  dynamic endPosition;
  late String startPlaceId;
  late String endPlaceId;

  late FocusNode startFocusNode;
  late FocusNode endFocusNode;

  // Timer? _debounce;

  List<AutocompletePrediction> placePredictions = [];

  @override
  void initState() {
    super.initState();

    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    startFocusNode.dispose();
    endFocusNode.dispose();
  }

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json',
        {"input": query, "key": kGoogleApi, "components": "country:my"});

    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  Future<dynamic> getPlaceDetails(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/place/details/json',
        {"place_id": placeId, "key": kGoogleApi});

    String? response = await NetworkUtility.fetchUrl(uri);
    var jsonPlaceDetails = jsonDecode(response!);
    String stringPlaceDetails = jsonEncode(jsonPlaceDetails);
    Map<String, dynamic> placeDetails = jsonDecode(stringPlaceDetails);
    return placeDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Color.fromARGB(240, 53, 49, 49)),
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Center(
              child: Container(
                child: ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          // proceed with booking
                        },
                        child: const Text("Now")),
                    TextButton(
                        onPressed: () {
                          // Prompt date time (compulsory)
                          // then proceed with booking
                        },
                        child: const Text("Schedule")),
                  ],
                ),
              ),
            ),
            Container(
              // height: 50,
              // margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  focusNode: startFocusNode,
                  keyboardType: TextInputType.text,
                  controller: _startSearchFieldController,
                  textAlignVertical: TextAlignVertical.center,
                  cursorHeight: 30,
                  cursorColor: kTextColor,
                  readOnly: false,
                  // autofocus: true,
                  // showCursor: true,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                  decoration: InputDecoration(
                      hintText: "Pick up at?",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                      icon: Image.asset("assets/icons/button.png",
                          width: 20, height: 20),
                      border: InputBorder.none,
                      suffixIcon: _startSearchFieldController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  placePredictions = [];
                                  _startSearchFieldController.clear();
                                });
                              },
                              icon: const Icon(Icons.clear_outlined,
                                  color: Colors.black12),
                            )
                          : null),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      placeAutoComplete(value);
                    } else {
                      setState(() {
                        startPosition = null;
                        placePredictions = [];
                      });
                    }
                  }),
            ),
            const SizedBox(height: 10),
            Container(
              // height: 50,
              // margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  focusNode: endFocusNode,
                  enabled: _startSearchFieldController.text.isNotEmpty,
                  keyboardType: TextInputType.text,
                  controller: _endSearchFieldController,
                  textAlignVertical: TextAlignVertical.center,
                  cursorHeight: 30,
                  cursorColor: kTextColor,
                  readOnly: false,
                  // autofocus: true,
                  // showCursor: true,
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
                      suffixIcon: _endSearchFieldController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  placePredictions = [];
                                  _endSearchFieldController.clear();
                                });
                              },
                              icon: const Icon(
                                Icons.clear_outlined,
                                color: Colors.black12,
                              ),
                            )
                          : null),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      placeAutoComplete(value);
                    } else {
                      setState(() {
                        startPosition = null;
                        placePredictions = [];
                      });
                    }
                  }),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: placePredictions.length,
                itemBuilder: ((context, index) => LocationListTile(
                      location: placePredictions[index].description!,
                      press: () async {
                        final placeId = placePredictions[index].placeId!;
                        // print(placePredictions[index].description!);
                        var details = await getPlaceDetails(placeId);
                        if (startFocusNode.hasFocus) {
                          setState(() {
                            startPosition = details;
                            startPlaceId = placeId;
                            // inspect(startPlaceId);
                            _startSearchFieldController.text =
                                placePredictions[index]
                                    .structuredFormatting!
                                    .mainText!;
                            placePredictions = [];
                          });
                        } else {
                          setState(() {
                            endPosition = details;
                            endPlaceId = placeId;
                            // inspect(endPlaceId);
                            _endSearchFieldController.text =
                                placePredictions[index]
                                    .structuredFormatting!
                                    .mainText!;
                            placePredictions = [];
                          });
                        }

                        if (startPosition != null && endPosition != null) {
                          LatLng startPoint = LatLng(
                              startPosition['result']['geometry']['location']
                                  ['lat'],
                              startPosition['result']['geometry']['location']
                                  ['lng']);
                          LatLng endPoint = LatLng(
                              endPosition['result']['geometry']['location']
                                  ['lat'],
                              endPosition['result']['geometry']['location']
                                  ['lng']);
                          double startPointLat = startPosition['result']
                              ['geometry']['location']['lat'];
                          double startPointLng = startPosition['result']
                              ['geometry']['location']['lng'];
                          double endPointLat = endPosition['result']['geometry']
                              ['location']['lat'];
                          double endPointLng = endPosition['result']['geometry']
                              ['location']['lng'];
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                  startPoint: startPoint,
                                  endPoint: endPoint,
                                  startPointLat: startPointLat,
                                  startPointLng: startPointLng,
                                  endPointLat: endPointLat,
                                  endPointLng: endPointLng,
                                  startPlaceId: startPlaceId,
                                  endPlaceId: endPlaceId),
                              fullscreenDialog: true,
                            ),
                          );
                        }
                      },
                    )),
              ),
            ),
          ])),
    );
  }
}
