import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/dashboard_screen.dart';
import 'package:smart_complain_management_system/screens/signup_screen.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscured = true;
  bool _isLoading = false;

  void _showAwesomeAlert(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
              color: isSuccess ? Colors.green : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    var user = await MongoDatabase.login(email, password);

    setState(() => _isLoading = false);

    if (user != null) {
      // Success Alert
      _showAwesomeAlert("Welcome Back!", "Login Successful. Opening Dashboard...", true);
      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      });
    } else {
      _showAwesomeAlert("Login Failed", "Invalid email or password. Please try again.", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF0D1C43);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("BAUST CMS", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D1C43))),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Hero(
                tag: 'logo',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(25)),
                  child: const Icon(Icons.security_rounded, size: 70, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              const Text("Login Session", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const Text("Access your smart dashboard", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "University Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email is required";
                  if (!value.contains("@")) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _isObscured = !_isObscured),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password is required";
                  if (value.length < 4) return "Password too short";
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Continue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())),
                    child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold)),
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
