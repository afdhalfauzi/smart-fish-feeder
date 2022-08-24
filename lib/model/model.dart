import 'package:flutter/material.dart';

class Schedules {
  final int? id;
  final String time;
  final int gr;

  Schedules({this.id, required this.time, required this.gr});

  factory Schedules.fromMap(Map<String, dynamic> json) =>
      Schedules(id: json['id'], time: json['time'], gr: json['gr']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'gr': gr,
    };
  }
}
