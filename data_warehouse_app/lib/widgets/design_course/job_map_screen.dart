import 'package:data_warehouse_app/providers/job_service.dart';
import 'package:data_warehouse_app/widgets/design_course/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:data_warehouse_app/models/job.dart';
import 'package:flutter/widgets.dart';
import 'package:wemapgl/wemapgl.dart';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:location/location.dart';

import 'job_list_screen.dart';

class JobMapScreen extends StatefulWidget {
  const JobMapScreen(this._currentLocation);

  final LocationData _currentLocation;

  @override
  _JobMapScreenState createState() => _JobMapScreenState();
}

class LatLngUnion<double, doube, int> {
  double lat;
  double long;
  int nUnion;

  LatLngUnion(this.lat, this.long, this.nUnion);

  @override
  String toString() {
    // TODO: implement toString
    return lat.toString() +
        "," +
        long.toString() +
        ' have ' +
        nUnion.toString();
  }
}

class _JobMapScreenState extends State<JobMapScreen> {
  WeMapController mapController;
  WeMapDirections directionAPI = WeMapDirections();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(21.038282, 105.782885),
    zoom: 13.0,
  );
  CameraPosition _position = _kInitialPosition;

  WeMapPlace place;
  double _searchRange = 5.0;
  List<Job> nearByJob;
  List p; // parent of Job

  Circle _circleWeNeedButWeNotDeserved;
  double lastZoom;

  List<Symbol> unionSymbols;


  final snackBar = SnackBar(
    duration: Duration(seconds: 5),
    content: Text('You can always show the jobs by tap Find again!'),
    action: SnackBarAction(
      label: '🙂',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  Future<void> _showMyDialog(List<Job> listJob) {

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image(
                    image: AssetImage('assets/images/job-offer.png'),
                    width: 200,
                    height: 200),
                SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'You found ',
                          style: AppTheme.headline,
                          ),
                        TextSpan(
                          text: listJob.length.toString(),
                          style: AppTheme.headlineHighlight,
                        ),
                      TextSpan(text: ' job',
                        style: AppTheme.headline,
                      ),
                    ]
                  ),
                )
                ,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Later', style: AppTheme.actionPopupCancelButton,),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            TextButton(
              child: const Text('Discover it!', style: AppTheme.actionPopupMainButton,),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => JobListScreen("Quanh bạn " + _searchRange.toString() + ' km', null, nearByJob),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _onSymbolTapped(Symbol symbol) async {
    int symbolUnion = unionSymbols.indexOf(symbol);

    List<Job> listJobInUnion = new List();
    for (int i = 0; i < nearByJob.length; i++) {
      if (p[i] == symbolUnion) {
        listJobInUnion.add(nearByJob[i]);
      }
    }

    developer.log(listJobInUnion.length.toString() + ' is tapped.');

    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => JobListScreen("Quanh bạn " + _searchRange.toString() + ' km (' + listJobInUnion.length.toString() + ')', null, listJobInUnion),
      ),
    );

  }

  void _onMapCreated(WeMapController controller) {
    mapController = controller;

    mapController.setSymbolIconAllowOverlap(true);
    mapController.setSymbolTextAllowOverlap(true);
    mapController.setSymbolIconIgnorePlacement(true);
    mapController.setSymbolTextIgnorePlacement(true);

    mapController.addListener(_onMapChanged);
    mapController.onSymbolTapped.add(_onSymbolTapped);
    _extractMapInfo();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    if (_circleWeNeedButWeNotDeserved != null) if (lastZoom != _position.zoom) {
      mapController.updateCircle(
          _circleWeNeedButWeNotDeserved,
          CircleOptions(
              geometry: LatLng(widget._currentLocation.latitude,
                  widget._currentLocation.longitude),
              circleRadius:
                  55 / (pow(2, 11 - _position.zoom)) * _searchRange / sqrt(2),
              circleColor: "#e84118",
              circleOpacity: 0.2));
      lastZoom = _position.zoom;
    }
  }

  double deg2rad(double deg) {
    return deg * (pi / 180);
  }

  double kmDistanceBetweenLatLng(LatLng p1, LatLng p2) {
    double R = 6371;
    var dLat = deg2rad(p2.latitude - p1.latitude); // deg2rad below
    var dLon = deg2rad(p2.longitude - p1.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(p1.latitude)) *
            cos(deg2rad(p2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  void _getNearJob(double lat, double long, double radius) async {
    mapController.clearSymbols();
    mapController.clearCircles();

    if (lat == null) {
      lat = widget._currentLocation.latitude;
      long = widget._currentLocation.longitude;
    }

    nearByJob = await JobService().getNearJob(lat, long, radius);

    // simple union algorithm, start with a random point (can be improve by first find largest polygon and unify from these vertexes)
    var union = new List.filled(nearByJob.length, new LatLngUnion(0.0, 0.0, 0));
    double threshold = _searchRange/2;

    p = new List.filled(nearByJob.length, 0);
    for (int i = 0; i < nearByJob.length; i++) {
      p[i] = i;
      union[i] = new LatLngUnion(0.0, 0.0, 0);
    }

    int curNumUnion = 0;
    for (int i = 0; i < nearByJob.length; i++) {
      int minDistanceIndex = -1;
      double minDistance = 999;
      for (int j = 0; j < i; j++) {
        double tDistance = kmDistanceBetweenLatLng(
            LatLng(nearByJob[i].lat, nearByJob[i].long),
            LatLng(nearByJob[p[j]].lat, nearByJob[p[j]].long));
        // developer.log('tDistance ' + tDistance.toString());
        if (tDistance < minDistance) {
          minDistance = tDistance;
          minDistanceIndex = j;
        }
      }

      if (minDistance < threshold) {
        p[i] = p[minDistanceIndex];
        union[p[minDistanceIndex]].nUnion++;
        union[p[minDistanceIndex]].lat += nearByJob[i].lat;
        union[p[minDistanceIndex]].long += nearByJob[i].long;
      } else {
        curNumUnion++;
        p[i] = curNumUnion - 1;
        union[curNumUnion - 1].nUnion++;
        union[curNumUnion - 1].lat = nearByJob[i].lat;
        union[curNumUnion - 1].long = nearByJob[i].long;
      }
    }

    // debug boys
    // developer.log('union ' + union.toString());
    // developer.log('nearByJob ' + nearByJob.toString());
    // developer.log('parent ' + p.toString());

    LatLngBounds latLngBounds = directionAPI.routeBounds(
        LatLng(lat - radius / 111.32,
            long - radius / (40075 * cos(lat - radius / 111.32) / 360)),
        LatLng(lat + radius / 111.32,
            long + radius / (40075 * cos(lat + radius / 111.32) / 360)));

    mapController.moveCamera(
      CameraUpdate.newLatLngBounds(latLngBounds,
          left: 10, top: 10, right: 10, bottom: 10),
    );

    mapController.addCircle(CircleOptions(
      geometry: LatLng(lat, long),
      circleRadius: 5,
      circleColor: "#e74c3c",
      // circleOpacity: 0.6
    ));
    //
    // mapController.addCircle(CircleOptions(
    //   geometry: LatLng(lat + radius / 111.32, long),
    //   circleRadius: 5,
    //   circleColor: "#00b894",
    //   // circleOpacity: 0.6
    // ));
    //
    // mapController.addCircle(CircleOptions(
    //   geometry: LatLng(
    //       lat, long - radius / (40075 * cos(lat + radius / 111.32) / 360)),
    //   circleRadius: 5,
    //   circleColor: "#00b894",
    //   // circleOpacity: 0.6
    // ));
    //
    // mapController.addCircle(CircleOptions(
    //   geometry: LatLng(
    //       lat, long + radius / (40075 * cos(lat + radius / 111.32) / 360)),
    //   circleRadius: 5,
    //   circleColor: "#00b894",
    //   // circleOpacity: 0.6
    // ));

    _circleWeNeedButWeNotDeserved = await mapController.addCircle(CircleOptions(
      geometry: LatLng(lat, long),
      circleRadius: 55 / (pow(2, 11 - _position.zoom)) * radius / sqrt(2),
      circleColor: "#e84118",
      circleOpacity: 0.2,
    ));

    // nearByJob.forEach((job) {
    //   mapController.addCircle(CircleOptions(
    //     geometry: LatLng(job.lat, job.long),
    //     circleRadius: 2,
    //     circleColor: "#e84118",
    //     // circleOpacity: 0.6
    //   ));
    // });


    List<SymbolOptions> unionSymbolOptions = new List();
    for (int i = 0; i < union.length; i++) {
      if (union[i].nUnion == 0) break;
      unionSymbolOptions.add(SymbolOptions(
          geometry: LatLng(
              union[i].lat / union[i].nUnion, union[i].long / union[i].nUnion),
          iconImage: 'assets/symbols/dry-clean.png',
          iconSize: 0.2,
          iconOpacity: 1,
          fontNames: ['Open Sans Regular'],
          textField: union[i].nUnion.toString(),
          textSize: 20,
          textColor: "#0097e6"));
    }

    unionSymbols = new List();
    unionSymbols = await mapController.addSymbols(unionSymbolOptions);

    // fukcing retard
    _showMyDialog(nearByJob);

    // debug boys, all these years testing waste
    // developer.log('unionSymbols:' + (unionSymbols).toString());
    // developer.log('Size level:' + (215/(pow(2, 11 - _position.zoom))*radius).toString());
    // developer.log('Zoom level:' + (_position.zoom).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        WeMap(
          onMapClick: (point, latlng, _place) async {
            place = await _place;
          },
          onPlaceCardClose: () {
            // print("Place Card closed");
          },
          reverse: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: _kInitialPosition,
          trackCameraPosition: true,
          destinationIcon: "assets/symbols/placeholder.png",
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppTheme.nearlyWhite,
                boxShadow: [
                  BoxShadow(color: Color(0xFFD0D8F3), blurRadius: 5)
                ]),
            margin: EdgeInsets.only(
                top: 10 + MediaQuery.of(context).padding.top,
                left: MediaQuery.of(context).size.width * 0.025,
                right: MediaQuery.of(context).size.width * 0.025,
                bottom: 10),
            child: Row(children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.70,
                  height: 64,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Slider(
                    value: _searchRange,
                    onChanged: (double searchRange) {
                      setState(() {
                        _searchRange = searchRange;
                      });
                    },
                    min: 0,
                    max: 9,
                    divisions: 9,
                  )),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  _getNearJob(null, null, _searchRange);
                },
                child: Text('Find (' + _searchRange.toInt().toString() + 'km)'),
              ),
            ]))
      ],
    ));
  }
}
