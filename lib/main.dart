import 'package:flutter/material.dart';
import 'package:schedulebooking/presentation/screens/schedule_booking/schedule_booking_screen.dart';

import 'di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.inject();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShiftScheduler(),
    );
  }
}