import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'description_limit_text.dart';
import 'design_course_app_theme.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:data_warehouse_app/models/job.dart';
import 'dart:developer' as developer;
import 'package:location/location.dart' as location_but_not_from_we_map;

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen(this.jobInfo);

  final Job jobInfo;

  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  WeMapDirections directionAPI = WeMapDirections();

  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  // use when i can show popup on map
  int _tripDistance = 0;
  int _tripTime = 0;

// wemap part

  WeMapController controller;
  LatLng myLatLng;

  void _onMapCreated(WeMapController controller) {
    this.controller = controller;
  }

// help func to add picture in map
  void _add(String iconImage, LatLng point) {
    controller.addSymbol(
      SymbolOptions(
        geometry: point,
        iconImage: iconImage,
        iconSize: 1 / controller.cameraPosition.zoom * 3,
      ),
    );
    developer.log(controller.cameraPosition.toString());
  }

  Future<LatLng> _getMyCurrentLatLng() async {
    final location = location_but_not_from_we_map.Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions !=
        location_but_not_from_we_map.PermissionStatus.GRANTED) {
      await location.requestPermission();
    }

    location_but_not_from_we_map.LocationData _locationData =
        await location.getLocation();

    return LatLng(_locationData.latitude, _locationData.longitude);
  }

  void _route(int type) async {
    List<LatLng> points = [];

    if (widget.jobInfo.lat != null) {
      points.add(LatLng(widget.jobInfo.lat, widget.jobInfo.long));

      await _getMyCurrentLatLng().then((value) => {points.add(value)});

      final json = await directionAPI.getResponseMultiRoute(
          0, points); //0 = car, 1 = bike, 2 = foot

      List<LatLng> _route = directionAPI.getRoute(json);
      List<LatLng> _waypoins = directionAPI.getWayPoints(json);

      setState(() {
        _tripDistance = directionAPI.getDistance(json);
        _tripTime = directionAPI.getTime(json);
      });

      if (_route != null) {
        await controller.addLine(
          LineOptions(
            geometry: _route,
            lineColor: "#0071bc",
            lineWidth: 5.0,
            lineOpacity: 1,
          ),
        );
        await controller.addSymbol(
          SymbolOptions(
            geometry: _waypoins[0],
            iconImage: 'assets/symbols/office-building.png',
            iconSize: 1 / controller.cameraPosition.zoom * 3,
            iconAnchor: "bottom",
          ),
        );

        await controller.addSymbol(
          SymbolOptions(
            geometry: _waypoins[1],
            iconImage: 'assets/symbols/businessman.png',
            iconSize: 1 / controller.cameraPosition.zoom * 3,
            iconAnchor: "bottom",
          ),
        );

        LatLngBounds latLngBounds =
            directionAPI.routeBounds(points[0], points[1]);
        controller.animateCamera(
          CameraUpdate.newLatLngBounds(latLngBounds,
              left: 40, top: 40, right: 40, bottom: 40),
        );
      }
    } else
      // points.add(LatLng(widget.jobInfo.lat, widget.jobInfo.long));
      developer.log('Dont have job coordinate!');
    // points.add(myLocation);

    // developer.log(json.toString());
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();

    _route(0);
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: DesignCourseAppTheme.notWhite,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('Chi tiết việc làm', style: DesignCourseAppTheme.headline),
          iconTheme: IconThemeData(
            color: DesignCourseAppTheme.nearlyBlack, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: DesignCourseAppTheme.cardShadowColor,
                    elevation: 5.0,
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 24, bottom: 12),
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 4,
                            ),
                            ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: widget.jobInfo.companyLogo,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'assets/images/company_default.png'),
                              ),
                              title: Text(widget.jobInfo.title.trim(),
                                  style: DesignCourseAppTheme.cardTitle),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              widget.jobInfo.companyName,
                              style: DesignCourseAppTheme.cardSubTitle,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.watch_later,
                                    size: 18,
                                    color: DesignCourseAppTheme.dangerous,
                                  ),
                                )),
                                TextSpan(
                                    style: TextStyle(
                                      color: DesignCourseAppTheme.dangerous,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: (widget.jobInfo.deadline == null
                                            ? "Hạn nộp hồ sơ: Không"
                                            : widget.jobInfo.deadline),
                                        // dirty trick
                                        style: DesignCourseAppTheme.cardContent,
                                      )
                                    ])
                              ]),
                            )
                          ],
                        ))),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: DesignCourseAppTheme.cardShadowColor,
                    elevation: 5.0,
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 12),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 4,
                          ),
                          ListTile(
                            title: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: DesignCourseAppTheme.dangerous,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Mô tả công việc',
                                        style: DesignCourseAppTheme.cardTitle,
                                      )
                                    ]),
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.description,
                                    size: 22,
                                    color: DesignCourseAppTheme.blue,
                                  ),
                                )),
                              ]),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: new DescriptionTextWidget(
                                  text: widget.jobInfo.description.trim()),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    )),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: DesignCourseAppTheme.cardShadowColor,
                    elevation: 5.0,
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 12),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 4,
                          ),
                          ListTile(
                            title: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: DesignCourseAppTheme.dangerous,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Yêu cầu công việc',
                                        style: DesignCourseAppTheme.cardTitle,
                                      )
                                    ]),
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.fact_check,
                                    size: 22,
                                    color: DesignCourseAppTheme.success,
                                  ),
                                )),
                              ]),
                            ),
                            subtitle: DescriptionTextWidget(
                                text: widget.jobInfo.requirement.trim()),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    )),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: DesignCourseAppTheme.cardShadowColor,
                    elevation: 5.0,
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 12),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 4,
                          ),
                          ListTile(
                            title: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: DesignCourseAppTheme.dangerous,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Quyền lợi',
                                        style: DesignCourseAppTheme.cardTitle,
                                      )
                                    ]),
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.volunteer_activism,
                                    size: 22,
                                    color: DesignCourseAppTheme.pink,
                                  ),
                                )),
                              ]),
                            ),
                            subtitle: DescriptionTextWidget(
                                text: widget.jobInfo.welfare.trim()),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    )),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    shadowColor: DesignCourseAppTheme.cardShadowColor,
                    elevation: 5.0,
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 12),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 4,
                          ),
                          ListTile(
                            title: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: DesignCourseAppTheme.dangerous,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Đường đi',
                                        style: DesignCourseAppTheme.cardTitle,
                                      )
                                    ]),
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.map_rounded,
                                    size: 22,
                                    color: DesignCourseAppTheme.marazineBlue,
                                  ),
                                )),
                              ]),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 8, bottom: 8),
                              child: Column(
                                children: <Widget>[
                                  Center(child: getDistanceChip()),
                                  Container(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Center(
                                      child: SizedBox(
                                        width: 350.0,
                                        height: 300.0,
                                        child: WeMap(
                                          onMapCreated: _onMapCreated,
                                          // onStyleLoadedCallback: onStyleLoadedCallback,
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(20.852, 105.211),
                                            zoom: 11.0,
                                          ),
                                          trackCameraPosition: true,
                                          gestureRecognizers: <
                                              Factory<
                                                  OneSequenceGestureRecognizer>>[
                                            Factory<
                                                OneSequenceGestureRecognizer>(
                                              () => EagerGestureRecognizer(),
                                            ),
                                          ].toSet(),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getDistanceChip() {
    if (_tripDistance > 0.1) {
      return Chip(
        backgroundColor: DesignCourseAppTheme.blue,
        label: Text("Quãng đường: " + (_tripDistance / 1000).toString() + " km",
            style: TextStyle(
              color: DesignCourseAppTheme.nearlyWhite,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            )),
      );
    }

    return Chip(
      backgroundColor: DesignCourseAppTheme.warning,
      label: Text("Không thể hiển thị quãng đường!",
          style: TextStyle(
            color: DesignCourseAppTheme.nearlyWhite,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          )),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
