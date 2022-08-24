import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pakan_ikan_iot/db/database_helper.dart';
import 'package:pakan_ikan_iot/model/model.dart';
import 'package:pakan_ikan_iot/pages/add_schedule_page.dart';
import 'package:pakan_ikan_iot/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

bool _isSchedule = true;

class _DashboardPageState extends State<DashboardPage> {
  @override
  //this is called once before the build
  void initState() {
    indexPage = 0;
    getSchedulePref();
    super.initState();
  }

  void _updateDashboard() {
    setState(() {});
  }

  void getSchedulePref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isSchedule = pref.getBool('isSchedule') ?? true;
    });
  }

  void setSchedulePref() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isSchedule', _isSchedule);
  }

  int? updateID;
  Color myOrange = Color(0xFFFF893E);
  TimeOfDay time = TimeOfDay(
      hour: 10,
      minute: 30); //USED FOR CONVERTING STRING DATA FROM DATABASE TO TIMEOFDAY
  final List<Text> _schedule = [
    Text('07:00 - 5gr'),
    Text('12:00 - 10gr'),
    Text('17:00 - 15gr'),
    Text('21:00 - 20gr'),
  ];
  final pageViewController = PageController(initialPage: 0);
  static int indexPage = 0;
  double sliderValueManual = 5;
  double sliderValueSchedule = 5;
  final appBar = AppBar(
    title: const Text(
      'Dashboard',
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    // toolbarHeight: 70,
    toolbarHeight: kToolbarHeight + 1,
    foregroundColor: Colors.white,
    backgroundColor: Colors.red,
    elevation: 0.0,
    centerTitle: true,
  );

  @override
  Widget build(BuildContext context) {
    final appBarHeight = appBar.preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screen = MediaQuery.of(context).size;
    final navbarHeight = kBottomNavigationBarHeight;
    final screenHeight =
        (screen.height - statusBarHeight - appBarHeight - navbarHeight);
    int _radio = 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: ListView(children: [
        //UPPER PART
        Container(
          height: screenHeight * 0.45,
          width: screen.width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80)),
              gradient: LinearGradient(
                colors: [Color(0xFFFF893E), Colors.red],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
          child: Stack(
            children: [
              PageView(
                controller: pageViewController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (i) {
                  indexPage = i;
                  setState(() {});
                },
                children: [
                  //FOOD LEVEL
                  Container(
                    width: screen.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //LIQUID INDICATOR
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 15),
                          height: screenHeight * 0.45,
                          child: LiquidLinearProgressIndicator(
                            value: 0.7,
                            valueColor: AlwaysStoppedAnimation(
                                Color.fromARGB(50, 255, 255, 255)),
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            borderRadius: 80,
                            borderWidth: 5.0,
                            direction: Axis.vertical,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "72⁒",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 80,
                                      shadows: [
                                        Shadow(
                                            color: Color.fromARGB(40, 0, 0, 0),
                                            offset: Offset(1.5, 1.5))
                                      ]),
                                ),
                                Text(
                                  'Food Level',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: const SliderThemeData(
                        activeTrackColor: Colors.amber,
                        thumbColor: Colors.white,
                        inactiveTrackColor: Colors.black12,
                        overlayColor: Colors.white54,
                        activeTickMarkColor: Colors.white,
                        inactiveTickMarkColor: Colors.black12,
                        trackHeight: 16,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 16),
                        // overlayShape: RoundSliderOverlayShape(overlayRadius: 32),
                        valueIndicatorColor: Colors.amber,
                        tickMarkShape:
                            RoundSliderTickMarkShape(tickMarkRadius: 12),
                        valueIndicatorTextStyle: TextStyle(
                          fontSize: 40,
                        )),
                    //MANUAL FEED
                    child: Container(
                      height: screenHeight * 0.45,
                      width: screen.width,
                      child: Column(
                        children: [
                          //10gr
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  sliderValueManual.round().toString(),
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.12,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ' gr',
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.05,
                                      color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Manual Feed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.03,
                            ),
                          ),
                          //SLIDER
                          Expanded(
                              child: Container(
                            height: screenHeight * 0.07,
                            margin: EdgeInsets.symmetric(
                                horizontal: screen.width * 0.05),
                            child: Slider(
                              min: 5,
                              max: 25,
                              value: sliderValueManual,
                              divisions: 4,
                              // thumbColor: Colors.white,
                              // activeColor: Colors.amber,
                              // inactiveColor: Colors.grey,
                              label: sliderValueManual.round().toString(),
                              onChanged: ((newValue) {
                                setState(() {
                                  sliderValueManual = newValue;
                                });
                              }),
                            ),
                          )),
                          //FEED BUTTON
                          Container(
                            margin: EdgeInsets.only(bottom: 40),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // minimumSize: Size(80, 40),
                                  primary: Colors.white,
                                  onPrimary: Colors.deepOrange,
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                                onPressed: () {
                                  _manualFeedDialog(context, sliderValueManual);
                                },
                                child: Text('Feed!')),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              (indexPage == 0)
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius:
                                BorderRadius.all(Radius.circular(90))),
                        child: IconButton(
                            iconSize: 15,
                            onPressed: () => pageViewController.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate),
                            icon: Icon(Icons.navigate_next_rounded)),
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius:
                                BorderRadius.all(Radius.circular(90))),
                        child: IconButton(
                          iconSize: 15,
                          onPressed: () => pageViewController.animateToPage(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.decelerate),
                          icon: Icon(Icons.navigate_before_rounded),
                        ),
                      )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: SmoothPageIndicator(
                    controller: pageViewController,
                    count: 2,
                    effect: ScaleEffect(
                      spacing: 7,
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: Colors.black26,
                      activeDotColor: Colors.white,
                      activePaintStyle: PaintingStyle.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        //SCHEDULEONOFF
        Container(
          height: screenHeight * 0.1,
          child: SwitchListTile(
            title: Text(
              'Schedule',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            value: _isSchedule,
            onChanged: (value) {
              setState(() {
                _isSchedule = value;
                setSchedulePref();
              });
            },
          ),
        ),
        //SCHEDULELIST
        Column(
          children: [
            Container(
                height: screenHeight * 0.45,
                padding: EdgeInsets.fromLTRB(9.0, 0, 9.0, 0),
                child: (!_isSchedule)
                    ? Center(
                        child: const Text(
                        'Schedule is Disabled',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ))
                    // : ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: (_schedule.length * 2) + 1,
                    //     itemBuilder: (context, i) {
                    //       if (i.isOdd) return Divider();
                    //       if (i >= _schedule.length * 2) {
                    //         return Container(
                    //           child: Center(
                    //             child: ElevatedButton(
                    //                 style: ElevatedButton.styleFrom(
                    //                   // minimumSize: Size(20, 40),
                    //                   // maximumSize: Size(40, 40),
                    //                   onPrimary: Colors.white,
                    //                   primary: myOrange,
                    //                   textStyle:
                    //                       TextStyle(fontSize: screenHeight * 0.03),
                    //                 ),
                    //                 onPressed: () {
                    //                   setState(() {
                    //                     Navigator.of(context).push(
                    //                         MaterialPageRoute(builder: (context) {
                    //                       return const AddSchedule();
                    //                     }));
                    //                   });
                    //                 },
                    //                 child: Text('Add Schedule')),
                    //           ),
                    //         );
                    //       }
                    //       final index = i ~/ 2;
                    //       return ListTile(
                    //         title: _schedule[index],
                    //         trailing: Wrap(
                    //           children: [
                    //             IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    //             IconButton(
                    //                 onPressed: () {
                    //                   _deleteScheduleDialog(context);
                    //                 },
                    //                 icon: Icon(Icons.delete)),
                    //           ],
                    //         ),
                    //       );
                    //     }),
                    : FutureBuilder<List<Schedules>>(
                        future: DatabaseHelper.instance.getSchedules(),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: const Text(
                              'Loading...',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ));
                          }
                          return snapshot.data!.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Schedule in List.',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                )
                              : ListView(
                                  children: snapshot.data!.map((schedules) {
                                    return ListTile(
                                      title: Text(
                                          '${schedules.id} - ${schedules.time} - ${schedules.gr}gr'),
                                      trailing: Wrap(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return AddSchedule(
                                                      time: TimeOfDay(
                                                          hour: int.parse(
                                                              schedules.time
                                                                  .split(
                                                                      ':')[0]),
                                                          minute: int.parse(
                                                              schedules.time
                                                                  .split(
                                                                      ':')[1])),
                                                      gr: schedules.gr,
                                                      selectedID: schedules.id,
                                                    );
                                                  }),
                                                ).then((_) => setState(
                                                      () {},
                                                    ));
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                _deleteScheduleDialog(
                                                        context, schedules.id!)
                                                    .then((value) {
                                                  setState(
                                                    () {},
                                                  );
                                                });
                                              },
                                              icon: Icon(Icons.delete)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                        }),
                      )),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddSchedule(
                        time: TimeOfDay(hour: 07, minute: 00),
                        gr: 5,
                        selectedID: null,
                      );
                    })).then((_) => setState((() {})));
                  });
                },
                child: const Text('Add Schedule')),
          ],
        )
      ]),
    );
  }
}

Future _deleteScheduleDialog(BuildContext context, int id) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Confirm'),
            content: Text('Delete Selected Schedule?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    DatabaseHelper.instance.remove(id);
                    Navigator.pop(context);
                    _showToast(context, Text('Selected schedule deleted'));
                  },
                  child: Text("Delete")),
            ]);
      });
}

Future _manualFeedDialog(BuildContext context, double sliderValueManual) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Confirm'),
            content: Text('Feed the fish with ' +
                sliderValueManual.round().toString() +
                'gr of food?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showToast(context, Text('Manual feed is given'));
                  },
                  child: Text("Feed")),
            ]);
      });
}

void _showToast(BuildContext context, Text text) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: text,
    ),
  );
}
