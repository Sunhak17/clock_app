import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  final List<String> _laps = [];

  void _start() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _milliseconds += 10;
      });
    });
  }

  void _pause() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _milliseconds = 0;
      _isRunning = false;
      _laps.clear();
    });
  }

  void _lap() {
    setState(() {
      _laps.insert(0, _formatTime(_milliseconds));
    });
  }

  String _formatTime(int milliseconds) {
    final hours = milliseconds ~/ 3600000;
    final minutes = (milliseconds % 3600000) ~/ 60000;
    final seconds = (milliseconds % 60000) ~/ 1000;
    final ms = (milliseconds % 1000) ~/ 10;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${ms.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${ms.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          'Stopwatch',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          // Time display
          Text(
            _formatTime(_milliseconds),
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 60),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRunning && _milliseconds == 0) ...[
                ElevatedButton(
                  onPressed: _start,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: _isRunning ? _pause : _start,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning
                        ? Colors.orange
                        : const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isRunning ? 'Pause' : 'Resume',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isRunning ? _lap : _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning
                        ? Colors.green
                        : Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isRunning ? 'Lap' : 'Reset',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 40),
          // Laps list
          if (_laps.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Laps',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3F52),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lap ${_laps.length - index}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _laps[index],
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
