import 'package:dynamics_crm/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';

import '../models/activity.dart';
import '../models/google_autocomplete_place.dart';
import '../models/google_place.dart';

class LocationMaps extends StatefulWidget {
  LocationMaps({Key? key, required this.activity, required this.location}) : super(key: key);

  final Activity activity;
  late LatLng location;

  @override
  State<LocationMaps> createState() => _LocationMapsState();
}

class _LocationMapsState extends State<LocationMaps> {
  final locationMapScaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  var txtSearch = TextEditingController();
  var myMarkers = <Marker>{};
  String _sessionToken = const Uuid().v4();

  late LatLng selectLocation;
  List<GooglePlace> _googlePlaceList = [];

  @override
  void initState() {
    // TODO: implement initState
    myMarkers = {
      Marker(
        markerId: const MarkerId('mark1'),
        position: widget.location != null ? LatLng(widget.location.latitude, widget.location.longitude) : DEFAULT_LOCATION,
        infoWindow: const InfoWindow(title: 'ตำแหน่งของลูกค้า', snippet: '')
    )};

    selectLocation = widget.location;

    super.initState();

    txtSearch.addListener(() {
      _onChanged();
    });
  }

  void _onChanged() async {
    if (_sessionToken == null) {
      _sessionToken = const Uuid().v4();
    }

    // _placeList = await ApiService(accessToken: '').getSuggestion(txtSearch.text, _sessionToken);
    setState(() {

    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _onTap(LatLng location) {
    setState(() {
      widget.location = location;
      myMarkers = changeLocationMarker(location);
    });
  }

  Future<Null> displayPrediction(Prediction? p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: GOOGLE_MAP_API,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId ?? '');
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;

      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: GOOGLE_MAP_API,
      onError: (PlacesAutocompleteResponse? res) {},
      mode: Mode.overlay,
      language: "th",
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "th")],
    );

    displayPrediction(prediction, locationMapScaffoldKey.currentState!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: locationMapScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.activity == Activity.checkIn ? 'เช็คอิน' : 'เก็บพิกัด'),
        actions: [
          IconButton(onPressed: _handlePressButton, icon: const Icon(Icons.search))
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Replace this container with your Map widget
          Container(
            child: GoogleMap(
              // myLocationEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(target: widget.location, zoom: 18),
              markers: myMarkers,
              onMapCreated: _onMapCreated,
              onTap: _onTap,
            ),
          ),
          Positioned(
            top: 10,
            right: 15,
            left: 15,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // IconButton(
                  //   splashColor: Colors.grey,
                  //   icon: Icon(Icons.menu),
                  //   onPressed: () {},
                  // ),
                  Expanded(
                    // child: TypeAheadField(
                    //   textFieldConfiguration: TextFieldConfiguration(
                    //       autofocus: true,
                    //       style: DefaultTextStyle.of(context).style.copyWith(
                    //           fontStyle: FontStyle.italic
                    //       ),
                    //       decoration: const InputDecoration(
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    //           )
                    //       )
                    //   ),
                    //   suggestionsCallback: (pattern) async {
                    //     return await ApiService(accessToken: '').getSuggestion(pattern, _sessionToken);
                    //   },
                    //   itemBuilder: (context, suggestion) {
                    //     return ListTile(
                    //       leading: const Icon(Icons.shopping_cart),
                    //       title: Text(suggestion['description']),
                    //       subtitle: Text('\$${suggestion!['price'] ?? ''}'),
                    //     );
                    //   },
                    //   onSuggestionSelected: (suggestion) {
                    //     // Navigator.of(context).push(MaterialPageRoute(
                    //     //     builder: (context) => ProductPage(product: suggestion)
                    //     // ));
                    //   },
                    // ),
                    // child: TextFormField(
                    //   controller: txtSearch,
                    //   // cursorColor: Colors.black,
                    //   keyboardType: TextInputType.text,
                    //   textInputAction: TextInputAction.go,
                    //   decoration: const InputDecoration(
                    //       border: InputBorder.none,
                    //       contentPadding:
                    //       EdgeInsets.symmetric(horizontal: 15),
                    //       hintText: "Search..."),
                    // ),
                    child: Autocomplete(
                      optionsBuilder: (TextEditingValue textEditingValue) async {
                        // _placeList = await ApiService(accessToken: '').getSuggestion(textEditingValue.text, _sessionToken);
                        // _placeList = await ApiService(accessToken: '').getSuggestion(textEditingValue.text, _sessionToken);
                        _googlePlaceList = await ApiService(accessToken: '').getTextSearch(textEditingValue.text);
                        return _googlePlaceList;
                        // return _placeList
                        //     .where((Map<String, String> continent) => continent.name.toLowerCase()
                        //     .startsWith(textEditingValue.text.toLowerCase())
                        // ).toList();
                      },
                      optionsMaxHeight: 400,
                      displayStringForOption: (GooglePlace? option) => '${option?.name ?? ''} ${option?.formattedAddress ?? ''}',
                      fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted
                          ) {
                        return TextFormField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(width: 0, style: BorderStyle.none,),
                            )
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          onTap: () {
                            fieldTextEditingController.selection = TextSelection(baseOffset: 0, extentOffset: fieldTextEditingController.value.text.length);
                          },
                        );
                      },
                      onSelected: (GooglePlace value) {
                        setState(() {
                          LatLng location = LatLng(value.geometry?.location?.lat ?? 13, value.geometry?.location?.lng ?? 100);
                          selectLocation = location;
                          myMarkers = changeLocationMarker(location);
                          mapController.animateCamera(CameraUpdate.newCameraPosition(changeCameraPosition(location)));
                        });
                      },
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.only(right: 8.0),
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.deepPurple,
                  //     child: Text('RD'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
          elevation: 0,
          foregroundColor: PRIMARY_COLOR,
          backgroundColor: Colors.white.withOpacity(0.7),
        child: const Icon(Icons.my_location),
          onPressed: () async {
          Position currentLocation = await getMyLocation();
          widget.location = LatLng(currentLocation.latitude, currentLocation.longitude);

          setState(() {
            // marker added for current users location
            myMarkers.clear();
            myMarkers.add(
                Marker(
                  markerId: const MarkerId("2"),
                  position: LatLng(widget.location.latitude, widget.location.longitude),
                  infoWindow: const InfoWindow(title: 'ตำแหน่งของฉัน',),
                )
            );

            // specified current users location
            CameraPosition cameraPosition = CameraPosition(
              zoom: 20,
              target: LatLng(widget.location.latitude, widget.location.longitude),
            );

            mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          });
        }
      ),
      // bottomSheet: ListView.builder(
      //   physics: const NeverScrollableScrollPhysics(),
      //   shrinkWrap: true,
      //   itemCount: _placeList.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(_placeList[index]['description']),
      //     );
      //   },
      // ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, selectLocation);
        },
        child: Text('ใช้งานตำแหน่งนี้', style: GoogleFonts.kanit(fontSize: 18.0)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15.0)
        ),
      ),
    );
  }
}
