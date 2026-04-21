import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/timezone_model.dart';
import '../services/timezone_converter.dart';
import '../data/timezones.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  late String _selectedTimezone;

  @override
  void initState() {
    super.initState();
    _selectedTimezone = worldTimezones
        .firstWhere(
          (tz) => tz.id == 'Asia/Phnom_Penh',
          orElse: () => worldTimezones[0],
        )
        .id;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Get the selected timezone object
  TimezoneData _getSelectedTimezone() {
    return worldTimezones.firstWhere(
      (tz) => tz.id == _selectedTimezone,
      orElse: () => worldTimezones[0],
    );
  }

  /// Get the time in the selected timezone
  DateTime _getTimezoneTime() {
    return TimezoneConverter.convertToTimezone(_currentTime, _getSelectedTimezone());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3142),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Clock',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Digital time
                Text(
                  DateFormat('HH:mm').format(_getTimezoneTime()),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                // Date
                Text(
                  DateFormat('EEE, d MMM').format(_getTimezoneTime()),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                // Timezone display
                Text(
                  _getSelectedTimezone().getDisplayName(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 48),
                // Analog Clock
                AnalogClock(time: _getTimezoneTime()),
                const SizedBox(height: 48),
                // Timezone Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3F52),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Timezone',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3142),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedTimezone,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF3A3F52),
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 15,
                            ),
                            items: worldTimezones.map((tz) {
                              return DropdownMenuItem<String>(
                                value: tz.id,
                                child: Text(tz.getDisplayName()),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedTimezone = value ?? worldTimezones[0].id;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnalogClock extends StatefulWidget {
  final DateTime time;

  const AnalogClock({super.key, required this.time});

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF3A3F52),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(
        painter: ClockPainter(widget.time),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = min(centerX, centerY);

    // Draw clock face border
    final outerCirclePaint = Paint()
      ..color = const Color(0xFF4A5568)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius - 10, outerCirclePaint);

    // Draw hour markers
    final hourMarkerPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 2;

    for (int i = 0; i < 60; i++) {
      if (i % 5 == 0) {
        final angle = (i * 6) * pi / 180;
        final startX = centerX + (radius - 25) * sin(angle);
        final startY = centerY - (radius - 25) * cos(angle);
        final endX = centerX + (radius - 15) * sin(angle);
        final endY = centerY - (radius - 15) * cos(angle);
        
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          Paint()
            ..color = Colors.grey[400]!
            ..strokeWidth = 3,
        );
      } else {
        final angle = (i * 6) * pi / 180;
        final x = centerX + (radius - 20) * sin(angle);
        final y = centerY - (radius - 20) * cos(angle);
        canvas.drawCircle(Offset(x, y), 1.5, hourMarkerPaint);
      }
    }

    // Hour hand
    final hourAngle = (dateTime.hour % 12 + dateTime.minute / 60) * 30 * pi / 180;
    final hourHandPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(
        centerX + (radius * 0.4) * sin(hourAngle),
        centerY - (radius * 0.4) * cos(hourAngle),
      ),
      hourHandPaint,
    );

    // Minute hand
    final minuteAngle = (dateTime.minute + dateTime.second / 60) * 6 * pi / 180;
    final minuteHandPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(
        centerX + (radius * 0.6) * sin(minuteAngle),
        centerY - (radius * 0.6) * cos(minuteAngle),
      ),
      minuteHandPaint,
    );

    // Second hand
    final secondAngle = dateTime.second * 6 * pi / 180;
    final secondHandPaint = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(
        centerX + (radius * 0.65) * sin(secondAngle),
        centerY - (radius * 0.65) * cos(secondAngle),
      ),
      secondHandPaint,
    );

    // Center dot
    final centerDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 8, centerDotPaint);
    canvas.drawCircle(center, 5, Paint()..color = const Color(0xFF3A3F52));
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) => true;
}
