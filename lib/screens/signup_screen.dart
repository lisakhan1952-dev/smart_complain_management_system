import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';
import 'package:mongo_dart/mongo_dart.dart' show where, modify;
import 'login_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String _userRole = "Student";
  String _selectedDept = "CSE";
  bool _isObscured = true;
  bool _isLoading = false;

  final List<String> _departments = ["CSE", "EEE", "ME", "CE", "IPE", "BBA", "General"];

  void _handleSignup() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required!")));
      return;
    }

    setState(() => _isLoading = true);

    bool success = await MongoDatabase.register(name, email, password, _userRole);
    if (success) {
      await MongoDatabase.userCollection.update(
        where.eq('email', email), 
        modify.set('department', _selectedDept)
      );
      
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account created! Please login.")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signup failed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF0D1C43);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Create Account"), elevation: 0, backgroundColor: Colors.white, foregroundColor: primaryColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text("Join BAUST CMS", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Fully dynamic management system", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

              const Align(alignment: Alignment.centerLeft, child: Text("I am a:", style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              FittedBox(
                child: SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(value: 'Student', label: Text('Student')),
                    ButtonSegment<String>(value: 'Staff', label: Text('Staff')),
                    ButtonSegment<String>(value: 'Teacher', label: Text('Teacher')),
                    ButtonSegment<String>(value: 'Admin', label: Text('Admin'))
                  ],
                  selected: <String>{_userRole},
                  onSelectionChanged: (Set<String> newSelection) => setState(() => _userRole = newSelection.first),
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedDept,
                decoration: const InputDecoration(labelText: "Select Department", border: OutlineInputBorder()),
                items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (val) => setState(() => _selectedDept = val!),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "University Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
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
                    onPressed: () => setState(() => _isObscured = !_isObscured),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
