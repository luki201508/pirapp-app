import 'package:http/http.dart' show Response;
import 'package:pirapp/classes/Courses.dart';

class CoursesList {
  final List<Course> courses;

  CoursesList({
    this.courses,
  });

  factory CoursesList.fromJson(Response parsedJson) {
    List<Course> courses = new List<Course>();

    return new CoursesList(
      courses: courses,
    );
  }
}