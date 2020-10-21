import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';

final _valid =
    'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\nBEGIN:VEVENT\nUID:uid1@example.com\nDTSTAMP:19970714T170000Z\nORGANIZER;CN=John Doe:MAILTO:john.doe@example.com\nDTSTART:19970714T170000Z\nDTEND:19970715T035959Z\nSUMMARY:Bastille Day Party\nGEO:48.85299;2.36885\nEND:VEVENT\nEND:VCALENDAR';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ICalendar _iCalendar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Version: ${_iCalendar?.version}"),
            Text("PRODID: ${_iCalendar?.prodid}"),
            Text("Data: ${_iCalendar?.data}"),
            Center(
              child: RaisedButton(
                child: Text('Push me'),
                onPressed: () {
                  final data = ICalendar.fromString(_valid);
                  print(data);
                  setState(() => _iCalendar = data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
