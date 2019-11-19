class Course {
  final String id;
  final String name;
  final String description;
  final String countHours;
  final String totalHours;
  final String userId;

  Course({
    this.id,
    this.name,
    this.description,
    this.countHours,
    this.totalHours,
    this.userId
  });

  factory Course.fromJson(Map<String, dynamic> parsedJson) {
    return new Course(
      id: parsedJson['id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      countHours: parsedJson['countHours'],
      totalHours: parsedJson['totalHours'],
      userId: parsedJson['userId']
    );
  }
}