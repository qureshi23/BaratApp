import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({Key? key}) : super(key: key);

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  final locationServices = Get.find<LocationServices>();

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController? _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude!.toDouble(), l.longitude!.toDouble()),
              zoom: 15),
        ),
      );
    });
  }

  static CameraPosition position = const CameraPosition(
      target: LatLng(37.1162262, -122.0511514), zoom: 14.17);
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: position,
              // mapType: MapType.normal,
              // onMapCreated: _onMapCreated,
              // myLocationEnabled: true,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.only(
                    right: 60, left: 10, bottom: 40, top: 40),
                child: MaterialButton(
                  onPressed: () async {
                    await _location.getLocation().then((value) {
                      setState(() {
                        locationServices.latitude.value =
                            value.latitude.toString();
                        locationServices.longitude.value =
                            value.longitude.toString();
                      });
                      print(
                          "Longitude is ${locationServices.longitude.value} ");
                      print("latitude is ${locationServices.latitude.value}");
                    });
                    Navigator.of(context).pop();
                  },
                  color: primaryColor,
                  child: const Text("Set Location"),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
