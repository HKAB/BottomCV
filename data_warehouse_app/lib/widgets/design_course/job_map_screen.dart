import 'package:flutter/material.dart';
import 'package:data_warehouse_app/models/job.dart';

class JobMapScreen extends StatefulWidget {
  const JobMapScreen(this.jobList);

  final Future<List<Job>> jobList;

  @override
  _JobMapScreenState createState() => _JobMapScreenState();
}

class _JobMapScreenState extends State<JobMapScreen>{
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
