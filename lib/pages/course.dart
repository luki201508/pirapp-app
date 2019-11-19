import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pirapp/API/auth.dart';
import 'package:pirapp/pages/add_time.dart';

final storage = new FlutterSecureStorage();

class Course extends StatefulWidget {
  final String id;

  Course(this.id);

  @override
  _CourseState createState() => _CourseState(this.id);
}

class _CourseState extends State<Course> {
  final String id;
  var accessToken;
  var course;
  var tabIndex = 0;

  _CourseState(this.id);

  @override
  void initState() {
    super.initState();
    _accessToken().then((_) {
      setState(() {
        course = _getCourseById();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: course,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: new Scaffold(
              backgroundColor: Color.fromRGBO(238, 241, 242, 1),
              appBar: new AppBar(
                title: new Text(
                  snapshot.data['name'],
                  style: new TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: new IconButton(
                  icon: new Icon(
                      Icons.arrow_back_ios
                  ),
                  color: Colors.black45,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                bottom: TabBar(
                  onTap: (index) {
                    setState(() {
                      tabIndex = index;
                    });
                  },
                  indicatorColor: Color(0xffB51E3A),
                  tabs: <Widget>[
                    new Tab(
                      icon: new Icon(
                        Icons.schedule,
                        color: Colors.black,
                        size: 25,
                      ),
                      child: new Text(
                        'Schedule',
                        style: new TextStyle(color: Colors.black),
                      ),
                    ),
                    new Tab(
                      icon: new Icon(
                        Icons.today,
                        color: Colors.black,
                        size: 25,
                      ),
                      child: new Text(
                        'Calendar',
                        style: new TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: new FloatingActionButton(
                child: new Icon(Icons.add),
                backgroundColor: Color(0xffB51E3A),
                splashColor: Colors.red,
                onPressed: () {
                  print(tabIndex);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => new AddTime(tabIndex),
                    ),
                  );
                },
              ),
              body: new Column(
                children: <Widget>[
                  new Flexible(
                    child: new TabBarView(
                      children: <Widget>[
                        new RefreshIndicator(
                          onRefresh: () {
                            setState(() {
                              course = _getCourseById();
                            });
                            return Future.value();
                          },
                          child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data['schedules'].length,
                            itemBuilder: (context, index) {
                              return _ScheduleCard(snapshot.data['schedules'][index]);
                            },
                          ),
                        ),
                        new RefreshIndicator(
                          onRefresh: () {
                            setState(() {
                              course = _getCourseById();
                            });
                            return Future.value();
                          },
                          child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data['calendars'].length,
                            itemBuilder: (context, index) {
                              return _CalendarCard(snapshot.data['calendars'][index]);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else if(snapshot.hasError) {
          return new Scaffold(
            backgroundColor: Color.fromRGBO(238, 241, 242, 1),
            appBar: new AppBar(
              title: new Text(
                'Course',
                style: new TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(
                    Icons.arrow_back_ios
                ),
                color: Colors.black45,
                onPressed: () {},
              ),
            ),
            body: new Center(
              child: new Text('Error'),
            ),
          );
        }
        return new Scaffold(
          backgroundColor: Color.fromRGBO(238, 241, 242, 1),
          appBar: new AppBar(
            title: new Text(
              'Course',
              style: new TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(
                  Icons.arrow_back_ios
              ),
              color: Colors.black45,
              onPressed: () {},
            ),
          ),
          body: new Center(
            child: new CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future _accessToken() async {
    accessToken = await storage.read(key: 'accessToken');
  }

  _getCourseById() async {
    return await getCourseById(this.accessToken, this.id);
  }
  
  _ScheduleCard(schedule) {
    return new Container(
      height: 70,
      margin: EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.circular(7.5),
        boxShadow: [
          new BoxShadow(
              color: Colors.black12,
              offset: new Offset(0.0, 0.0),
              blurRadius: 5.0
          )
        ]
      ),
      child: new ListTile(
        title: new Text(
          _DayNumberToText(schedule['dayNumber']),
          style: new TextStyle(
            fontSize: 20
          ),
        ),
        subtitle: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              'From: ' + schedule['beginHour'],
              style: new TextStyle(fontSize: 15),
            ),
            new Text(
              'To: ' + schedule['endHour'],
              style: new TextStyle(fontSize: 15),
            )
          ],
        ),
        trailing: new IconButton(
          icon: new Icon(
            Icons.delete,
            color: Color(0xffB51E3A),
            size: 35,
          ),
          color: Colors.black45,
          onPressed: () {
            return _ShowAlertDialogSchedule(context, schedule);
          },
        ),
      )
    );
  }

  _CalendarCard(calendar) {
    var begin = calendar['beginDate'].substring(0,10);
    var end = calendar['endDate'].substring(0,10);
    return new Container(
        height: 70,
        margin: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(7.5),
            boxShadow: [
              new BoxShadow(
                  color: Colors.black12,
                  offset: new Offset(0.0, 0.0),
                  blurRadius: 5.0
              )
            ]
        ),
        child: new ListTile(
          title: new Text(
            'From: $begin',
            style: new TextStyle(fontSize: 20),
          ),
          subtitle: new Text(
            'To: $end',
            style: new TextStyle(fontSize: 20),
          ),
          trailing: new IconButton(
            icon: new Icon(
              Icons.delete,
              color: Color(0xffB51E3A),
              size: 35,
            ),
            color: Colors.black45,
            onPressed: () {
              return _ShowAlertDialogCalendar(context, calendar);
            },
          ),
        )
    );
  }
  
  _DayNumberToText(day) {
    switch(day) {
      case '1': return 'Monday'; break;
      case '2': return 'Tuesday'; break;
      case '3': return 'Wednesday'; break;
      case '4': return 'Thursday'; break;
      case '5': return 'Friday'; break;
      case '6': return 'Saturday'; break;
      case '7': return 'Sunday'; break;
      default: return 'Null';
    }
  }

  Future<void> _ShowAlertDialogSchedule(BuildContext context, schedule) async {
    _Delete() {
      return new FlatButton(
        child: new Text(
          'Delete',
          style: TextStyle(fontSize: 20,color: Color(0xffB51E3A))
        ),
        onPressed: () async {
          await deleteSchedule(
              accessToken,
              schedule['courseId'],
              schedule['dayNumber'],
              schedule['beginHour'],
              schedule['endHour']);
          setState(() {
            course = _getCourseById();
            Navigator.of(context, rootNavigator: true).pop();
          });
        },
      );
    }
    _Cancel() {
      return new FlatButton(
        child: new Text(
            'Cancel',
            style: TextStyle(fontSize: 20, color: Colors.black45)
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
    }

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text(
              'Delete schedule with: \n'
              ' • Day: ${_DayNumberToText(schedule['dayNumber'])}\n'
              ' • Beginning hour: ${schedule['beginHour']}\n'
              ' • Ending hour: ${schedule['endHour']}.\n'
              'Press cancel in case you do not want to delet it.'
          ),
          actions: <Widget>[
            _Delete(),
            _Cancel()
          ],
        );
      }
    );
    
  }

  Future<void> _ShowAlertDialogCalendar(BuildContext context, calendar) async {
    _Delete() {
      return new FlatButton(
        child: new Text(
            'Delete',
            style: TextStyle(fontSize: 20,color: Color(0xffB51E3A))
        ),
        onPressed: () async {
          await deleteCalendar(
              accessToken,
              calendar['courseId'],
              calendar['beginDate'].substring(0,10),
              calendar['endDate'].substring(0,10));
          setState(() {
            course = _getCourseById();
            Navigator.of(context, rootNavigator: true).pop();
          });
        },
      );
    }
    _Cancel() {
      return new FlatButton(
        child: new Text(
            'Cancel',
            style: TextStyle(fontSize: 20, color: Colors.black45)
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
    }

    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text(
                'Delete calendar with: \n'
                    ' • Beginning date: ${calendar['beginDate']}\n'
                    ' • Ending date: ${calendar['endDate']}.\n'
                    'Press cancel in case you do not want to delet it.'
            ),
            actions: <Widget>[
              _Delete(),
              _Cancel()
            ],
          );
        }
    );

  }

}
