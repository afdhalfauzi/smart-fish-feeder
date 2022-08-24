// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pakan_ikan_iot/pages/dashboard_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final List<Text> _activity = [
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Manual feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Manual feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
    Text('Manual feed is given'),
    Text('Scheduled feed is given'),
    Text('Scheduled feed is given'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Activity Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: _clearLog,
            tooltip: 'options',
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 70,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 255, 132, 62), Colors.red],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
        ),
      ),
      body: ListView.builder(
        itemCount: _activity.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          return ListTile(
            title: _activity[index],
            leading: Icon(
              Icons.playlist_add_check_rounded,
              color: Colors.orange,
            ),
            trailing: Text('7:00'),
          );
        },
      ),
    );
  }

  Future _clearLog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Confirm'),
              content: Text('Clear Activity Log?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showToast(context, Text('Activity log cleared'));
                    },
                    child: Text("Clear")),
              ]);
        });
  }
}

void _showToast(BuildContext context, Text text) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: text,
    ),
  );
}
