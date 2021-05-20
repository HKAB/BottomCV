import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'package:wemapgl/wemapgl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:data_warehouse_app/models/job.dart';

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
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
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

  final LatLng center = const LatLng(20.080664, 105.9563837);

  void onMapCreated(WeMapController controller) {
    controller.addSymbol(SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconImage: "airport-15"));
    controller.addLine(
      LineOptions(
        geometry: [
          LatLng(21.86711, 105.1947171),
          LatLng(21.86711, 105.1947171),
          LatLng(20.86711, 105.1947171),
          LatLng(21.86711, 106.1947171),
        ],
        lineColor: "#ff0000",
        lineWidth: 7.0,
        lineOpacity: 0.5,
      ),
    );
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
          title: Text('Chi tiết việc làm',
              style: TextStyle(color: DesignCourseAppTheme.nearlyBlack)),
          iconTheme: IconThemeData(
            color: DesignCourseAppTheme.nearlyBlack, //change your color here
          ),
          backgroundColor: DesignCourseAppTheme.nearlyWhite,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Card(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 4,
                    ),
                    ListTile(
                      leading: Image.network(widget.jobInfo.companyLogo),
                      title: Text(widget.jobInfo.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.darkerText,
                          )),
                      subtitle: Text(
                        widget.jobInfo.companyName,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 16,
                          letterSpacing: 0.27,
                          color: DesignCourseAppTheme.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.date_range_rounded,
                              color: DesignCourseAppTheme.grey, size: 20),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            //width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.jobInfo.deadline,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_on_outlined,
                              color: DesignCourseAppTheme.grey, size: 20),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            // width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.jobInfo.officeLocation,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 4,
                      ),
                      ListTile(
                        title: Text(
                          'Mô tả công việc',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.darkerText,
                          ),
                        ),
                        subtitle: Text(
                          widget.jobInfo.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.nearlyBlack,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 4,
                      ),
                      ListTile(
                        title: Text(
                          'Yêu cầu công việc',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.darkerText,
                          ),
                        ),
                        subtitle: Text(
                          widget.jobInfo.requirement,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.nearlyBlack,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 4,
                      ),
                      ListTile(
                        title: Text(
                          'Quyền lợi',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.darkerText,
                          ),
                        ),
                        subtitle: Text(
                          widget.jobInfo.welfare,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.nearlyBlack,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: DesignCourseAppTheme.nearlyWhite,
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: opacity2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: SizedBox(
                            width: 300.0,
                            height: 300.0,
                            /* child: WeMap(
                              onMapCreated: onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: center,
                                zoom: 11.0,
                              ),
                              gestureRecognizers:
                                  <Factory<OneSequenceGestureRecognizer>>[
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              ].toSet(),
                            ),*/
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
