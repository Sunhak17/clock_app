import 'package:flutter/material.dart';
import '../models/alarm_model.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<Alarm> _alarms = [
    Alarm(
      id: '1',
      label: 'Office',
      time: '06:00',
      days: ['Mon-Fri'],
      startColor: const Color(0xFF667EEA),
      endColor: const Color(0xFF764BA2),
      isActive: true,
    ),
    Alarm(
      id: '2',
      label: 'Sport',
      time: '07:00',
      days: ['Sat-Sun'],
      startColor: const Color(0xFFFF6B95),
      endColor: const Color(0xFFFF9671),
      isActive: true,
    ),
  ];

  void _toggleAlarm(int index) {
    setState(() {
      _alarms[index].isActive = !_alarms[index].isActive;
    });
  }

  void _showAddAlarmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3A3F52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add Alarm',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Alarm creation functionality would go here',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
          'Alarm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Alarm list
            Expanded(
              child: ListView.builder(
                itemCount: _alarms.length,
                itemBuilder: (context, index) {
                  return AlarmCard(
                    alarm: _alarms[index],
                    onToggle: () => _toggleAlarm(index),
                    onDelete: () {
                      setState(() {
                        _alarms.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Add alarm button
            GestureDetector(
              onTap: _showAddAlarmDialog,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3F52),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF667EEA).withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF667EEA),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add Alarm',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            alarm.startColor,
            alarm.endColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Alarm icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.alarm,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Alarm details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alarm.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alarm.days.join(', '),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alarm.time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            // Toggle switch
            Switch(
              value: alarm.isActive,
              onChanged: (value) => onToggle(),
              activeColor: Colors.white,
              activeTrackColor: Colors.white.withOpacity(0.5),
              inactiveThumbColor: Colors.white.withOpacity(0.5),
              inactiveTrackColor: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(width: 8),
            // Expand button
            GestureDetector(
              onTap: () {
                // Show more options
              },
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white.withOpacity(0.7),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
