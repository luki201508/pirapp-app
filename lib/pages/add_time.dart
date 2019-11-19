import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTime extends StatefulWidget {
  final type;
  AddTime(this.type);

  @override
  _AddTimeState createState() => _AddTimeState(this.type);
}

class _AddTimeState extends State<AddTime> {
  final typeInt;

  _AddTimeState(this.typeInt);

  var type;

  @override
  void initState() {
    setState(() {
      this.type = _TypeToString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: new AppBar(
        title: new Text(
          'Add $type',
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
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _dayNumberField(),
            _selectBeginTime(_beginDateTime)
          ],
        ),
      ),
    );
  }

  _TypeToString() {
    switch (this.typeInt) {
      case 0:
        return 'schedule';
      case 1:
        return 'calendar';
    }
  }

  TextStyle style = new TextStyle(fontSize: 20.0);

  var _dayNumber = [1, 2, 3, 4, 5, 6, 7];

  var _dayNumberController = 0;


  _dayNumberField() {
    return new DropdownButtonFormField(
      items: _dayNumber.map((val) {
        return new DropdownMenuItem(
          child: new Text(_DayNumberToText(val)),
          value: val,
        );
      }).toList(),
      hint: new Text(
          _DayNumberToText(_dayNumberController)
      ),
      onChanged: (value) {
        setState(() {
          _dayNumberController = value;
        });
      },
    );
  }
  DateTime _beginDateTime;
  DateTime _endDateTime;

  _selectTime(controller) {
    return new CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: DateTime(1,1,1,10,0,0),
      onDateTimeChanged: (newDate) {
        print(_beginDateTime);
        setState(() {
          controller = newDate;
        });
      },
      use24hFormat: true,
      minuteInterval: 30,
    );
  }

  _selectBeginTime(controller) {
    return new Container(
      height: MediaQuery.of(context).size.height / 5,
      child: _selectTime(controller),
    );
  }

  _DayNumberToText(day) {
    switch(day) {
      case 1: return 'Monday'; break;
      case 2: return 'Tuesday'; break;
      case 3: return 'Wednesday'; break;
      case 4: return 'Thursday'; break;
      case 5: return 'Friday'; break;
      case 6: return 'Saturday'; break;
      case 7: return 'Sunday'; break;
      default: return 'Choose a Day of the week';
    }
  }
}
