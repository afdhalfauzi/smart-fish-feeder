//3
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pakan_ikan_iot/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

bool _notification = false;

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    _getNotifPref();
    super.initState();
    print('harusnya ini sebelum build');
  }

  _getNotifPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _notification = pref.getBool('isNotif') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    @override
    _setNotifPref() async {
      final pref = await SharedPreferences.getInstance();
      await pref.setBool('isNotif', _notification);
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Settings'),
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
        body: ListView(
          children: [
            SwitchListTile(
              title: Text('Notification'),
              value: _notification,
              onChanged: (value) {
                setState(() {
                  _notification = value;
                  _setNotifPref();
                });
              },
            ),
            ListTile(
              title: Text('MQTT Connection'),
              trailing: Icon(Icons.navigate_next),
            )
          ],
        ));
  }
}
