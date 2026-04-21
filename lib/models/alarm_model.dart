import 'package:flutter/material.dart';

class Alarm {
  final String id;
  final String label;
  final String time;
  final List<String> days;
  final Color startColor;
  final Color endColor;
  bool isActive;

  Alarm({
    required this.id,
    required this.label,
    required this.time,
    required this.days,
    required this.startColor,
    required this.endColor,
    this.isActive = true,
  });
}
