import 'package:data_warehouse_app/widgets/design_course/job_info_screen.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:flutter/rendering.dart';
import 'package:data_warehouse_app/models/job.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_warehouse_app/widgets/design_course/app_theme.dart';
import 'package:data_warehouse_app/main.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen(this.categoryName, this.jobList);

  final String categoryName;
  final Future<List<Job>> jobList;

  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.notWhite,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.categoryName, style: AppTheme.headline),
          iconTheme: IconThemeData(
            color: AppTheme.nearlyBlack, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          child: FutureBuilder<List<Job>>(
              future: widget.jobList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  List<Job> theList = snapshot.data;
                  return ListView.builder(
                      itemCount: theList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ConstrainedBox(
                            constraints: new BoxConstraints(
                              minHeight: 15,
                              // minWidth: 5.0,
                              // maxHeight: 30.0,
                              // maxWidth: 30.0,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              shadowColor: AppTheme.cardShadowColor,
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
                                        imageUrl: theList[index].companyLogo,
                                        // imageBuilder: (context, imageProvider) =>
                                        //     Container(
                                        //   height: 100,
                                        //   width: 100,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //         Radius.circular(50)),
                                        //     image: DecorationImage(
                                        //       image: imageProvider,
                                        //       fit: BoxFit.fill,
                                        //     ),
                                        //   ),
                                        // ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/company_default.png'),
                                      ),
                                      title: Text(theList[index].title.trim(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.title),
                                      subtitle: Text(
                                          theList[index].companyName.trim(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.subtitle),
                                      onTap: () => {moveTo(theList[index])},
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      });
                }
              }),
        ),
      ),
    );
  }

  void moveTo(Job thisJob) async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.GRANTED) {
      await location.requestPermission();
    }

    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => JobInfoScreen(thisJob),
      ),
    );
  }
}
