// login_screen.dart ফাইল
import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/dashboard_screen.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// লগইন পেজের স্টেট (এখানে সব লজিক থাকবে)
class _LoginPageState extends State<LoginPage> {
  // টেক্সট কন্ট্রোলার (ইউজার যা টাইপ করবে তা ধরার জন্য)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // পাসওয়ার্ডের এরর বা অন্য কিছুর জন্য স্ট্রিং
  String? _errorText; // এই ভেরিয়েবলটি আমাদের পাসওয়ার্ডের এরর সলভ করতে সাহায্য করবে

  // ইউজার টাইপ (স্টুডেন্ট নাকি স্টাফ) ট্র‍্যাক করার জন্য
  String _userType = "Student"; // ডিফল্টভাবে স্টুডেন্ট থাকবে

  // পাসওয়ার্ড দেখানো বা লুকানোর জন্য (চোখ আইকনের লজিক)
  bool _isObscured = true;

  // লগইন বাটন হ্যান্ডেল করার ফাংশন (সব লজিক এখানে)
  void _handleLogin() {
    setState(() {
      _errorText = null; // নতুন করে লগইন চেষ্টা করার আগে আগের এরর মুছে ফেলুন
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    // ১. খালি ফিল্ড চেক করা (Validation)
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and Password are required!")),
      );
      return; // কোডটি আর নিচে যাবে না
    }

    // ২. ইমেল ফরম্যাট চেক করা (যদি প্রয়োজন হয় - এখানে সিম্পল রেখেছি)

    // ৩. পাসওয়ার্ড ভুল হলে এরর কীভাবে সলভ করবেন?
    // আমরা প্রথমে সিম্পল লজিক ব্যবহার করব। পরে আপনি এখানে ডাটাবেস যুক্ত করবেন।
    if (password != "1234") { // মনে করুন সঠিক পাসওয়ার্ড '1234'
      setState(() {
        // এই লাইনটিই আপনার পাসওয়ার্ড এরর সলভ করবে!
        // এটি টেক্সট ফিল্ডের নিচে লাল লেখা দেখাবে।
        _errorText = "Incorrect password! Hint: 1234";
      });
      return; // লগইন সফল হবে না
    }

    // ৪. যদি সব ঠিক থাকে, তবে ড্যাশবোর্ডে যান
    // Navigator.pushReplacement ব্যবহার করলে ইউজার ব্যাক বাটনে ক্লিক করে আবার লগইন এ ফিরতে পারবে না
    // login_screen.dart এর ভেতরে নেভিগেশনের লাইনটি এভাবে লিখুন
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()), // এখানে 'const' রাখবেন না
    );
  }

  @override
  Widget build(BuildContext context) {
    // BAUST-এর লোগো কালার (গভীর নীল)
    Color primaryColor = const Color(0xFF0D1C43);

    return Scaffold(
      appBar: AppBar(
        title: const Text("BAUST CMS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        centerTitle: false, // স্ক্রিনশটের মতো বাম পাশে টাইটেল
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ১. BAUST লোগো (একটি সিম্পল আইকন দিয়েছি)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.school_rounded, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // ২. Welcome Back লেখা
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

            // ৩. Student/Staff সিলেকশন (Segmented Button)
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'Student', label: Text('Student')),
                ButtonSegment<String>(value: 'Staff', label: Text('Staff')),
              ],
              selected: <String>{_userType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _userType = newSelection.first; // ইউজার টাইপ পরিবর্তন করুন
                });
              },
              // আধুনিক লুক দেওয়ার জন্য
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return primaryColor; // সিলেক্টেড কালার গভীর নীল
                  }
                  return Colors.grey[100]!; // আন-সিলেক্টেড কালার
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white; // সিলেক্টেড টেক্সট কালার সাদা
                  }
                  return primaryColor; // আন-সিলেক্টেড টেক্সট কালার গভীর নীল
                }),
              ),
            ),
            const SizedBox(height: 40),

            // ৪. ইমেল ফিল্ড (Icon এবং Placeholder সহ)
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "University Email",
                hintText: "e.g. name@baust.edu.bd", // Placeholder টেক্সট
                prefixIcon: const Icon(Icons.email_outlined), // বাম পাশে আইকন
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // ৫. পাসওয়ার্ড ফিল্ড (এরর, চোখ আইকন এবং Forgot লজিক)
            TextField(
              controller: _passwordController,
              obscureText: _isObscured, // পাসওয়ার্ড দেখানো বা লুকানো
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline), // বাম পাশে আইকন
                // পাসওয়ার্ড দেখার জন্য চোখ আইকন
                suffixIcon: IconButton(
                  icon: Icon(_isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured; // toggle obscuration
                    });
                  },
                ),
                border: const OutlineInputBorder(),
                // এটিই আপনার পাসওয়ার্ড এরর সলভ করার মূল অংশ!
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

            // ৬. Keep me signed in চেকবক্স
            const Row(
              children: [
                Checkbox(value: true, onChanged: null), // একটি সিম্পল চেকবক্স
                Text("Keep me signed in", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 30),

            // ৭. লগইন বাটন
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleLogin, // লগইন ফাংশন কল করলাম
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // গভীর নীল কালার
                  foregroundColor: Colors.white, // সাদা টেক্সট কালার
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

            // ৮. "OR" লেখা
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey))),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 30),

            // ৯. Request Access লিঙ্ক
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