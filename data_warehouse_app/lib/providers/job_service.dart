import 'dart:convert';

import 'package:data_warehouse_app/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class JobService {
  final String url = 'http://10.0.2.2:8000/api/job';

  Future<Job> getJob(int id) async {
    final jobUrl = '$url/get?id=$id';
    final res = await http.get(jobUrl);
    if (res.statusCode == 200) {
      final decodeData = utf8.decode(res.bodyBytes);
      final data = jsonDecode(decodeData);
      return Job.fromJson(data);
    } else {
      throw Exception('Failed to get job');
    }
  }

  Future<List<Job>> getJobByCategory(int cat) async {
    final jobListUrl = '$url/list?cat=$cat';
    final res = await http.get(jobListUrl);
    if (res.statusCode == 200) {
      final decodeData = utf8.decode(res.bodyBytes);
      final data = jsonDecode(decodeData);
      //debugPrint('data: $data');
      return List<Job>.from(data.map((e) => Job.fromMap(e)));
    } else {
      throw Exception('Failed to get job list');
    }
  }

  Future<List<Job>> getNearJob(double lat, double long, double radius) async {
    final jobListUrl = '$url/near?lat=$lat&long=$long&radius=$radius';
    final res = await http.get(jobListUrl);
    if (res.statusCode == 200) {
      final decodeData = utf8.decode(res.bodyBytes);
      final data = jsonDecode(decodeData);
      //debugPrint('data: $data');
      return List<Job>.from(data.map((e) => Job.fromMap(e)));
    } else {
      throw Exception('Failed to get job list near you');
    }
  }
}
