// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:pakan_ikan_iot/pages/activity_page.dart';
import 'package:pakan_ikan_iot/pages/dashboard_page.dart';
import 'package:pakan_ikan_iot/pages/settings_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Fish Feeder',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      )),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;
  final screens = [
    ActivityPage(),
    DashboardPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.shifting,
        // backgroundColor: Color.fromARGB(255, 255, 132, 62),
        // selectedItemColor: Colors.white,
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 255, 132, 62),
        showUnselectedLabels: false,

        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// class RandwomWords extends StatefulWidget {
//   const RandwomWords({Key? key}) : super(key: key);

//   @override
//   State<RandwomWords> createState() => _RandwomWordsState();
// }

// class _RandwomWordsState extends State<RandwomWords> {
//   final _suggestions = <WordPair>[];
//   final _saved = <WordPair>{};
//   final _biggerFont = TextStyle(fontSize: 18);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Name Generator'),
//         actions: [
//           IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list))
//         ],
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemBuilder: (context, i) {
//           if (i.isOdd) return const Divider();

//           final index = i ~/ 2;
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(10));
//           }

//           final alreadySaved = _saved.contains(_suggestions[index]);

//           return ListTile(
//             title: Text(
//               _suggestions[index].asPascalCase,
//               style: _biggerFont,
//             ),
//             trailing: Icon(
//               alreadySaved ? Icons.favorite : Icons.favorite_border,
//               color: alreadySaved ? Colors.red : null,
//               semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
//             ),
//             onTap: () {
//               setState(() {
//                 if (alreadySaved) {
//                   _saved.remove(_suggestions[index]);
//                 } else {
//                   _saved.add(_suggestions[index]);
//                 }
//               });
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(MaterialPageRoute<void>(
//       builder: (context) {
//         final tiles = _saved.map(
//           (pair) {
//             return ListTile(
//               title: Text(
//                 pair.asPascalCase,
//                 style: _biggerFont,
//               ),
//             );
//           },
//         );
//         final divided = tiles.isNotEmpty
//             ? ListTile.divideTiles(
//                 context: context,
//                 tiles: tiles,
//               ).toList()
//             : <Widget>[];

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Saved Suggestions'),
//           ),
//           body: ListView(children: divided),
//         );
//       },
//     ));
//   }
// }
