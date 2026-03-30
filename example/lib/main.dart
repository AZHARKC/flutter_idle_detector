import 'package:flutter/material.dart';
import 'package:flutter_idle_detector/flutter_user_idle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idle Detector Example',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const IdleExamplePage(),
    );
  }
}

class IdleExamplePage extends StatefulWidget {
  const IdleExamplePage({super.key});

  @override
  State<IdleExamplePage> createState() => _IdleExamplePageState();
}

class _IdleExamplePageState extends State<IdleExamplePage> {
  bool _isIdle = false;

  void _onIdle() {
    debugPrint('🔴 User is IDLE');
    setState(() => _isIdle = true);
  }

  void _onActive() {
    debugPrint('🟢 User is ACTIVE again');
    setState(() => _isIdle = false);
  }

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      timeout: const Duration(seconds: 10),
      onIdle: _onIdle,
      onActive: _onActive,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Idle Detector Example'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isIdle ? Icons.bedtime_rounded : Icons.touch_app_rounded,
                size: 72,
                color: _isIdle ? Colors.orange : Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                _isIdle ? 'User is Idle 😴' : 'User is Active 🟢',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isIdle ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isIdle
                    ? 'Tap anywhere to resume'
                    : 'Goes idle after 10 seconds\nof no interaction',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
