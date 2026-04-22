import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/login_screen.dart';


void main() {
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
      // এখানে 'const' মুছে দেওয়া হয়েছে কারণ LoginPage এখন ডাইনামিক
      home: const LoginPage(),
    );
  }
}