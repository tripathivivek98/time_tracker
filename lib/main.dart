import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/project_task_provider.dart';
import 'providers/time_entry_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider()..loadData()),
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()..loadData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
