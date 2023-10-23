import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart';


class AttendanceRecord {
 final String name;
 final DateTime time;

 AttendanceRecord(this.name, this.time);

 String getTimeAgo() {
 return format(time, locale: 'en');
 }

 String getFormattedTime() {
 return DateFormat('dd MMM yyyy, h:mm a').format(time);
 }
}

class AttendanceRecordsList extends StatefulWidget {
 final List<AttendanceRecord> attendanceRecords;

 AttendanceRecordsList({Key? key, required this.attendanceRecords})
 : super(key: key);

 @override
 State<AttendanceRecordsList> createState() =>
 _AttendanceRecordsListState();
}

class _AttendanceRecordsListState extends State<AttendanceRecordsList> {
 bool _showFormattedTime = false;
 final _snackbar = SnackBar(content: Text('Record Added Successfully'));

 final _nameController = TextEditingController();
 final _searchController = TextEditingController();

 @override
 void initState() {
 super.initState();
 _loadShowFormattedTime();
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 backgroundColor: Colors.grey,
 appBar: AppBar(
 title: Text('Attendance Records'),
 actions: [
 Switch(
   value: _showFormattedTime,
   onChanged: (value) {
     setState(() {
       _showFormattedTime = value;
       _saveShowFormattedTime(value);
     });
   },
 ),
 Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
   IconButton(
    icon: Icon(Icons.add),
    onPressed: () {
     _addAttendanceRecord();
 _showOnboarding();
    },
  ),
  Text('Add Attendance Records                    '),
   ],
  ),
 ],
 ),
 body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          setState(() {
            filteredAttendanceRecords = widget.attendanceRecords
                .where((element) =>
                    element.name.toLowerCase().contains(value.toLowerCase()))
                .toList();
          });
        },
      ),
    ),
    Expanded(
      child: ListView.builder(
        itemCount: filteredAttendanceRecords.length,
        itemBuilder: (context, index) {
          final attendanceRecord = filteredAttendanceRecords[index];
          return ListTile(
            title: Text(attendanceRecord.name),
            subtitle: Text(_showFormattedTime
                ? attendanceRecord.getFormattedTime()
                : attendanceRecord.getTimeAgo()),
            trailing: AnimatedOpacity(
              duration: Duration(seconds:3),
              opacity: 1,
              child: IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceRecordDetail(attendanceRecord: attendanceRecord),
      ),
                 );
              },
              ),
      ),
        );
 },
 ),
   ),
  if(filteredAttendanceRecords.length == 0) ...[
        Center(child: Text("You have reached the end of the list."))
      ]
  ],
 ),
 );
 }

 List<AttendanceRecord> filteredAttendanceRecords = [];

void _showOnboarding() {
 showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text('Welcome to Attendance Records!'),
      content: Column(
        children: [
          Text('This app allows you to track your attendance.'),
          Text('To add a record, simply tap the + button.'),
          Text('You can search for records by name.'),
          Text('Tap on a record to view its details.'),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Got it!'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
 );
 }

 void _addAttendanceRecord() {
 showDialog(
 context: context,
 builder: (context) {
 return AlertDialog(
 title: Text('Add Attendance Record'),
 content: TextField(
 autofocus: true,
   controller: _nameController,
   decoration: InputDecoration(hintText: 'Name'),
 ),
 actions: [
   TextButton(
     child: Text('Cancel'),
     onPressed: () {
       Navigator.of(context).pop();
     },
   ),
   TextButton(
     child: Text('Add'),
     onPressed: () {
       final name = _nameController.text;
       if (name.isNotEmpty) {
         setState(() {
           widget.attendanceRecords.add(AttendanceRecord(name, DateTime.now()));
            ScaffoldMessenger.of(context).showSnackBar(_snackbar);
         });
       }
       Navigator.of(context).pop();
     },
   ),
 ],
 );
 },
 );
 }
 void _saveShowFormattedTime(bool value) async {
 final prefs = await SharedPreferences.getInstance();
 prefs.setBool('showFormattedTime', value);
 }

 void _loadShowFormattedTime() async {
 final prefs = await SharedPreferences.getInstance();
 final value = prefs.getBool('showFormattedTime');
 if (value != null) {
 setState(() {
 _showFormattedTime = value;
 });
 }
 }
}


final attendanceRecords = [
 AttendanceRecord(
 'Chan Saw Lin', DateTime.parse('2020-06-30 16:10:05')),
 AttendanceRecord(
 'Lee Saw Loy', DateTime.parse('2020-07-11 15:39:59')),
 AttendanceRecord(
 'Khaw Tong Lin', DateTime.parse('2020-08-19 11:10:18')),
 AttendanceRecord(
 'Lim Kok Lin', DateTime.parse('2020-08-19 11:11:35')),
 AttendanceRecord(
 'Low Jun Wei', DateTime.parse('2020-08-15 13:00:05')),
 AttendanceRecord(
 'Yong Weng Kai', DateTime.parse('2020-07-31 18:10:11')),
 AttendanceRecord(
 'Jayden Lee', DateTime.parse('2020-08-22 08:10:38')),
 AttendanceRecord(
 'Kong Kah Yan', DateTime.parse('2020-07-11 12:00:00')),
 AttendanceRecord(
 'Jasmine Lau', DateTime.parse('2020-08-01 12:10:05')),
 AttendanceRecord(
 'Chan Saw Lin', DateTime.parse('2020-08-23 11:59:05')),
];

void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
 return MaterialApp(
 home: AttendanceRecordsList(attendanceRecords: attendanceRecords),
 );
 }
}

class AttendanceRecordDetail extends StatelessWidget {
 final AttendanceRecord attendanceRecord;

 AttendanceRecordDetail({required this.attendanceRecord});

 @override
 Widget build(BuildContext context) {
 return Scaffold(
  backgroundColor: Colors.grey,
  appBar: AppBar(
    title: Text('Attendance Record Detail'),

  ),
  body: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Text(attendanceRecord.name, style: TextStyle(fontSize: 24)),
        Text(attendanceRecord.getFormattedTime()),
      ],
    ),
  ),
 );
 }
}