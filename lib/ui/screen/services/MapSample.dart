import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huawei_map/components/components.dart' as huawei;

import 'HuaweiMapScreen.dart';

class MapSample extends StatelessWidget {
  final ArgumentCallback<LatLng>? onTap;
  final LatLng? initLocation;
  final bool supportClick;

  MapSample(
      {Key? key, this.onTap, this.initLocation, this.supportClick = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid &&
        GetIt.I<AndroidDeviceInfo>().manufacturer.toLowerCase() == 'huawei')
      return HuaweiMapScreen(
        onTap: (l) {
          onTap?.call(LatLng(l.lat, l.lng));
        },
        initLocation: initLocation?.latitude != null
            ? huawei.LatLng(initLocation!.latitude, initLocation!.longitude)
            : null,
        supportClick: supportClick,
      );
    else
      return GoogleMapScreen(
        onTap: onTap,
        initLocation: initLocation,
        supportClick: supportClick,
      );
  }
}

class GoogleMapScreen extends StatefulWidget {
  final ArgumentCallback<LatLng>? onTap;
  final LatLng? initLocation;
  final bool supportClick;

  GoogleMapScreen(
      {Key? key, this.onTap, this.initLocation, this.supportClick = false})
      : super(key: key);

  @override
  State<GoogleMapScreen> createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> markers = Set();

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initLocation != null) {
      _handleTap(widget.initLocation);
      goTo(widget.initLocation);
    } else
      _currentLocation(supportMarker: true);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  _handleTap(LatLng? point) async {
    try {
      if (widget.onTap != null) {
        widget.onTap!.call(point!);
      }

      var oldValue = await getBytesFromAsset(
          Assets.images.iconMaterialLocationOn.path, 120);

      BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(oldValue);

      setState(() {
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point!,
          infoWindow: InfoWindow(
            title: '',
          ),
          icon: customIcon,
        ));
      });
    } catch (e) {}
  }

  Future<void> goTo(LatLng? location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: location!,
      zoom: 11.4746,
    )));
  }

  _currentLocation({bool supportMarker = false}) async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (supportMarker) {
      _handleTap(LatLng(position.latitude, position.longitude));
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: markers,
            onTap: widget.supportClick ? _handleTap : null,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: _currentLocation,
                child: Container(
                  margin: EdgeInsetsResponsive.only(top: 10, right: 10),
                  child: RawMaterialButton(
                    onPressed: _currentLocation,
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.location_on,
                      size: 25.w,
                      color: AppFactory.getColor('primary', toString()),
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
              )),
        ],
      ),

      /* floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _handleTap(widget.initLocation);
        },
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
