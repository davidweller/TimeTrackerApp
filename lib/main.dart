import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'providers/time_entry_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  
  runApp(
    // The Provider must wrap the MaterialApp to share data across screens.
    ChangeNotifierProvider(
      create: (context) => TimeEntryProvider(),
      child: const TimeTrackerApp(),
    ),
  );
}

class TimeTrackerApp extends StatelessWidget {
  const TimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Setting this to HomeScreen replaces the default counter demo.
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}