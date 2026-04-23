// login_screen.dart ফাইল
import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/dashboard_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ১. এখানে আপনার নাম বা ইমেইল সেট করে দেওয়া হয়েছে
  final TextEditingController _emailController =
  TextEditingController(text: "lisa@baust.edu.bd");

  final TextEditingController _passwordController = TextEditingController();

  String? _errorText;
  String _userType = "Student";
  bool _isObscured = true;

  void _handleLogin() {
    setState(() {
      _errorText = null;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and Password are required!")),
      );
      return;
    }

    if (password != "1234") {
      setState(() {
        _errorText = "Incorrect password! Hint: 1234";
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF0D1C43);

    return Scaffold(
      appBar: AppBar(
        title: const Text("BAUST CMS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.school_rounded, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 30),

            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Access the BAUST Smart Complaint Management System",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'Student', label: Text('Student')),
                ButtonSegment<String>(value: 'Staff', label: Text('Staff')),
                ButtonSegment<String>(value: 'Teacher', label: Text('Teacher'))
              ],
              selected: <String>{_userType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _userType = newSelection.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) return primaryColor;
                  return Colors.grey[100]!;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) return Colors.white;
                  return primaryColor;
                }),
              ),
            ),
            const SizedBox(height: 40),

            // ২. ইমেল ফিল্ড - autofillHints: null যোগ করা হয়েছে যাতে 'admin' না আসে
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: null, // অটো-ফিল বন্ধ করার জন্য
              decoration: InputDecoration(
                labelText: "University Email",
                hintText: "e.g. name@baust.edu.bd",
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: _isObscured,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot?", style: TextStyle(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(height: 10),

            const Row(
              children: [
                Checkbox(value: true, onChanged: null),
                Text("Keep me signed in", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Icon(Icons.login_rounded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey))),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {},
                  child: const Text("Request Access", style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}