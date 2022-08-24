import 'package:flutter/material.dart';
import 'package:pakan_ikan_iot/db/database_helper.dart';
import 'package:pakan_ikan_iot/model/model.dart';
import 'package:pakan_ikan_iot/pages/dashboard_page.dart';

class AddSchedule extends StatefulWidget {
  // const AddSchedule({Key? key}) : super(key: key);
  TimeOfDay time = TimeOfDay(hour: 07, minute: 00);
  int gr = 5;
  int? selectedID;

  AddSchedule({required this.time, required this.gr, this.selectedID});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}
//ssddd

class _AddScheduleState extends State<AddSchedule> {
  Future _addScheduleDialog(String hours, String minutes, double weight) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Confirm'),
              content: Text(
                  'Add New Schedule in ${hours}:${minutes} with ${weight.round()}gr of food?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      await DatabaseHelper.instance.add(
                        Schedules(time: '$hours:$minutes', gr: weight.round()),
                      );
                      setState(() {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        _showToast(Text('Schedule Added'));
                      });
                    },
                    child: Text("Add")),
              ]);
        });
  }

  Future _updateScheduleDialog(
      int? id, String hours, String minutes, int weight) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Confirm'),
              content: Text(
                  'Update Schedule into ${hours}:${minutes} with ${weight.round()}gr of food?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      await DatabaseHelper.instance.update(
                        Schedules(
                            id: id,
                            time: '$hours:$minutes',
                            gr: weight.round()),
                      );
                      setState(() {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        _showToast(Text('Schedule Updated'));
                      });
                    },
                    child: Text("Update")),
              ]);
        });
  }

  Future pickTime() async {
    TimePickerThemeData(backgroundColor: Colors.black);
    final newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        confirmText: 'NEXT',
        builder: (context, childWidget) {
          //needed so timepicker alwaysUse24HourFormat
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: childWidget!);
        });

    if (newTime == null) return;

    setState(() => widget.time = newTime);
  }

  void _showToast(Text text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: text,
      ),
    );
  }

  double sliderValueSchedule = 5;

  @override
  Widget build(BuildContext context) {
    final hours = widget.time.hour.toString().padLeft(2, '0');
    final minutes = widget.time.minute.toString().padLeft(2, '0');

    //screen size
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screen = MediaQuery.of(context).size;
    final screenHeight = (screen.height - statusBarHeight);
    Color myOrange = Color(0xFFFF893E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.selectedID != null
                    ? 'Edit Schedule'
                    : 'Add New Schedule',
                style: TextStyle(fontSize: screenHeight * 0.03),
              ),
              //TIME COLUMN
              Column(
                children: [
                  Text(
                    '${hours}:${minutes}',
                    style: TextStyle(
                      fontSize: screenHeight * 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: Icon(Icons.access_time),
                    style: OutlinedButton.styleFrom(
                      primary: myOrange,
                      side: BorderSide(color: myOrange, width: 1),
                    ),
                    onPressed: () {
                      pickTime();
                    },
                    label: Text('PickTime'),
                  ),
                ],
              ),
              //5GR
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.gr.toString(),
                      style: TextStyle(
                        fontSize: screenHeight * 0.12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      ' gr',
                      style: TextStyle(
                          fontSize: screenHeight * 0.05, color: Colors.black26),
                    ),
                  ],
                ),
              ),
              //SLIDER COLUMN
              Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                        activeTrackColor: myOrange,
                        thumbColor: Colors.white,
                        inactiveTrackColor: Colors.black12,
                        overlayColor: Colors.white54,
                        activeTickMarkColor: Colors.white,
                        inactiveTickMarkColor: Colors.black12,
                        trackHeight: 16,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 16),
                        // overlayShape: RoundSliderOverlayShape(overlayRadius: 32),
                        valueIndicatorColor: myOrange,
                        tickMarkShape:
                            RoundSliderTickMarkShape(tickMarkRadius: 12),
                        valueIndicatorTextStyle: TextStyle(
                          fontSize: screenHeight * 0.03,
                        )),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screen.width * 0.05),
                      child: Slider(
                        min: 5,
                        max: 25,
                        value: widget.gr.toDouble(),
                        divisions: 4,
                        // thumbColor: Colors.white,
                        // activeColor: Colors.amber,
                        // inactiveColor: Colors.grey,
                        label: widget.gr.toString(),
                        onChanged: ((newValue) {
                          setState(() {
                            widget.gr = newValue.toInt();
                          });
                        }),
                      ),
                    ),
                  ),
                  Text(
                    'Select the amount of food',
                    style: TextStyle(
                      color: myOrange,
                      fontSize: screenHeight * 0.03,
                    ),
                  ),
                ],
              ),

              //CONFIRM ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('CANCEL')),
                  TextButton(
                      onPressed: () {
                        widget.selectedID != null
                            ? _updateScheduleDialog(
                                widget.selectedID, hours, minutes, widget.gr)
                            : _addScheduleDialog(
                                hours, minutes, sliderValueSchedule);
                      },
                      child: Text('CONFIRM')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
