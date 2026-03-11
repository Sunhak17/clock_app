import 'package:flutter/material.dart';
import 'screens/clock_screen.dart';
import 'screens/alarm_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/stopwatch_screen.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF2D3142),
        primaryColor: const Color(0xFF4A5568),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF667EEA),
          secondary: const Color(0xFF764BA2),
          surface: const Color(0xFF3A3F52),
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ClockScreen(),
    AlarmScreen(),
    TimerScreen(),
    StopwatchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: const Color(0xFF2A2F3D),
            indicatorColor: Colors.transparent,
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
              size: 28,
            ),
            unselectedIconTheme: IconThemeData(
              color: Colors.grey[600],
              size: 24,
            ),
            selectedLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelTextStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
            ),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.access_time),
                label: Text('Clock'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.alarm),
                label: Text('Alarm'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.hourglass_empty),
                label: Text('Timer'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.timer),
                label: Text('Stopwatch'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFF1E222E)),
          // Main content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
