import 'package:flutter/material.dart';
import 'routing/app_router.dart';

class FastingTrackerApp extends StatelessWidget {
  const FastingTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fasting Tracker',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      routerConfig: router,
    );
  }
}
