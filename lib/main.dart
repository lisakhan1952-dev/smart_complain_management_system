import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/login_screen.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

void main() async {
  // 1. Ensure Flutter bindings are initialized for async work
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Await the connection so the app doesn't start "empty"
  print("Initializing Database...");
  await MongoDatabase.connect();

  // 4. Finally launch the UI
  runApp(const BAUSTApp());
}

class BAUSTApp extends StatelessWidget {
  const BAUSTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BAUST CMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0D1C43),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D1C43)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}