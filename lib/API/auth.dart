import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

const String url = 'http://pirapp.tech/api';
Future<dynamic> signIn(String email, String password) async {
  print('Login');
  var res = await http.post(
    url + '/auth/signin',
    body: {
      "email": email,
      "password": password
    });
  if(res.statusCode == 201) {
    print('Logged sign in');
    await storage.write(key: 'connection', value: 'on');
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
    var body = json.decode(res.body);
    String accessToken = body["accessToken"];
    await storage.write(key: 'accessToken', value: accessToken);
    return true;
  }
  return false;
}

isLoggedIn() async {
  return await storage.read(key: 'connection') == 'on';
}

Future<List<dynamic>> getCourses(accessToken) async {
  print('Getting Courses');
  var response = await http.get(
    url + '/courses',
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${accessToken}'
    }
  );
  var courses = json.decode(response.body);
  //print(courses);
  return courses;
}

operationCourses(accessToken, courseId ,operation) async {
  print('${operation} Course');
  var response = await http.get(
    url + '/courses/' + courseId + '/hours/' + operation,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${accessToken}'
    }
  );
  if(response.statusCode != 200) {
    print('Error on ${operation} of course id ${courseId}');
  }
}

getCourseById(accessToken, courseId) async {
  print('getting course ${courseId}');
  var response = await http.get(
    url + '/courses/' + courseId,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${accessToken}'
    }
  );
  if(response.statusCode != 200) {
    print('Error getting course ${courseId}');
    return {};
  }
  var course = json.decode(response.body);
  return course;
}

deleteSchedule(accessToken, courseId, dayNumber, beginHour, endHour) async {
  print('deleting schedule on ${courseId}');
  var rq = http.Request('DELETE', Uri.parse(url + '/courses/' + courseId + '/schedule'));
  rq.headers['authorization'] = 'Bearer $accessToken';
  rq.bodyFields = {
    "dayNumber": dayNumber,
    "beginHour": beginHour,
    "endHour": endHour
  };
  print(rq.bodyFields);

  final client = http.Client();

  var response = await client.send(rq).then(http.Response.fromStream);
}

deleteCalendar(accessToken, courseId, beginDate, endDate) async {
  beginDate = new DateTime(
      int.parse(beginDate.substring(0,4)),
      int.parse(beginDate.substring(5,7)),
      int.parse(beginDate.substring(8,10)) + 1
  ).toString().substring(0,10);
  endDate = new DateTime(
      int.parse(endDate.substring(0,4)),
      int.parse(endDate.substring(5,7)),
      int.parse(endDate.substring(8,10)) + 1
  ).toString().substring(0,10);

  print('deleting schedule on ${courseId}');
  var rq = http.Request('DELETE', Uri.parse(url + '/courses/' + courseId + '/calendar'));
  rq.headers['authorization'] = 'Bearer $accessToken';
  rq.bodyFields = {
    "beginDate": beginDate,
    "endDate": endDate
  };
  print(rq.bodyFields);

  final client = http.Client();

  var response = await client.send(rq).then(http.Response.fromStream);

  print(response.statusCode);
  print(response.reasonPhrase);
}

