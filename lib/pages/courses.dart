import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math' as math;

import 'package:pirapp/API/auth.dart';
import 'package:pirapp/pages/course.dart';


final storage = new FlutterSecureStorage();

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  var accessToken;
  var courses;

  @override
  void initState() {
    super.initState();
    _accessToken().then((value){
      print(accessToken);
      setState(() {
        courses = _getCourses();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: new AppBar(
        title: new Center(
          child: new Text(
            "Courses",
            style: new TextStyle(color: Colors.black),
          )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.add
            ),
            color: Colors.black45,
            onPressed: () {},
          )
        ],
      ),
      body: new SafeArea(
        child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new FutureBuilder(
                future: courses,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return new Flexible(
                      child: new RefreshIndicator(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var course = snapshot.data[index];
                            return _CourseCard(course);
                          },
                        ),
                        onRefresh: () {
                          setState(() {
                            courses = _getCourses();
                          });
                          return Future.value();
                        },
                      ),
                    );
                  } else if(snapshot.hasError) {
                    return Text("Error");
                  }

                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _accessToken() async {
    accessToken = await storage.read(key: 'accessToken');
  }

  Future<List<dynamic>> _getCourses() async {
    return await getCourses(this.accessToken);
  }

  _CourseCard(course) {
    TextEditingController _descriptionController = TextEditingController();
    _descriptionController.text = course['description'];
    var color;
    var text;
    if(course['countHours'] != null && course['countHours']['hours'] != null) {
      if(course['countHours']['hours'] > course['totalHours']['hours'] * 50 / 100) {
        if(course['countHours']['hours'] == course['totalHours']['hours']) {
          print('son iguales');
          color = Colors.redAccent;
          text = 'WARNING!';
        } else {
          color = Colors.orangeAccent;
          text = 'CAUTION!';
        }
      } else {
        color = Colors.green;
        text = 'WELL';
      }
    } else {
      color = Colors.greenAccent;
      text = 'GOOD';
    }

      return new Center(
        child: new Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
          height: 235,
          child: new AspectRatio(
            aspectRatio: 3.5/2,
            child: new GestureDetector(
              child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(20.0),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 10.0
                      )
                    ]
                ),
                child: new Padding(
                  padding: new EdgeInsets.all(20.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            course['name'],
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: new Color(0xff29292A)
                            ),
                          ),
                          new Container(
                            width: 150,
                            height: 25,
                            decoration: new BoxDecoration(
                              color: color,
                              borderRadius: new BorderRadius.circular(20.0)
                            ),
                            child: new Center(
                              child: new Text(
                                  text,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 5,
                                  ),
                              ),
                            ),
                          )
                        ],
                      ),
                      new TextField(
                          maxLines: null,
                          maxLength: 140,
                          controller: _descriptionController,
                          enabled: false,
                          decoration: new InputDecoration.collapsed()
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Transform.rotate(
                            angle: 45 * math.pi/180,
                            child: _DynamicButton(
                                course['id'],
                                0xffDF4D68,
                                Colors.red,
                                course['countHours'] != null ? course['countHours']['hours'] : 0,
                                null,
                                Icons.add,
                                'del'
                            ),
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'HOURS',
                                style: new TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              new SizedBox(height: 5),
                              new Text(
                                  (course['countHours'] == null)
                                      || (course['countHours']['hours'] == null) ?
                                  '00' : course['countHours']['hours'] < 10 ?
                                  '0' + course['countHours']['hours'].toString() :
                                course['countHours']['hours'].toString(),
                                style: new TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              new SizedBox(height: 10)
                            ],
                          ),
                          new Column(
                            children: <Widget>[
                              new Text(
                                'TOTAL',
                                style: new TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              new SizedBox(height: 5),
                              new Text(
                                course['totalHours'] == null ?
                                '00' : course['totalHours']['hours'] < 10 ?
                                '0' + course['totalHours']['hours'].toString() :
                                course['totalHours']['hours'].toString(),
                                style: new TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              new SizedBox(height: 10)
                            ],
                          ),
                          _DynamicButton(
                              course['id'],
                              0xff55B84D,
                              Colors.green,
                              course['countHours']['hours'],
                              course['totalHours']['hours'],
                              Icons.add,
                              'add'
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => new Course(course['id'])
                    )
                );
              },
            ),
          ),
        ),
      );
    }


  _DynamicButton(
      id,
      primaryColor,
      secondaryColor,
      countHours,
      totalHours,
      icon,
      operation) {
    return new ClipOval(
      child: new Material(
        color:
        countHours != totalHours ? Color(primaryColor): Color(0xffC9C9C9),
        child: new InkWell(
          splashColor:
          countHours != totalHours ? secondaryColor: Colors.white70,
          child: new SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
          ),
          onTap: () async {
            if(countHours != totalHours) {
              await operationCourses(this.accessToken, id, operation);
              setState(() {
                courses = _getCourses();
              });
            }
          },
        ),
      ),
    );
  }
}


