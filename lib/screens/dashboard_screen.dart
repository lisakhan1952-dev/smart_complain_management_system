import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/dashboard_content.dart';
import 'package:smart_complain_management_system/screens/submit_complaint_screen.dart';
import 'package:smart_complain_management_system/screens/login_screen.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';
import 'tracking_screen.dart';
import 'profile_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardContent(),
    const SubmitComplaintPage(),
    const TrackingPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);
    // Awesome Feature: Dynamic User Info from DB
    final String userName = MongoDatabase.currentUser?['name'] ?? "Guest User";
    final String userEmail = MongoDatabase.currentUser?['email'] ?? "guest@baust.edu.bd";
    final String userRole = MongoDatabase.currentUser?['role'] ?? "Visitor";

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      drawer: _buildAwesomeDrawer(primaryColor, userName, userEmail, userRole),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        title: Text(
          _currentIndex == 0 ? "BAUST CMS" :
          _currentIndex == 1 ? "New Complaint" :
          _currentIndex == 2 ? "Live Tracking" : "Profile",
          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: PageTransitionSwitcher(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: 'Submit'),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes_rounded), label: 'Track'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildAwesomeDrawer(Color primaryColor, String name, String email, String role) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            accountName: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                  child: Text(role, style: const TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF0D1C43)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("My Complaints"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Settings"),
            onTap: () {},
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text("Sign Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: _handleLogout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _handleLogout() {
    // 1. Clear session
    MongoDatabase.logout();
    
    // 2. Show alert and Navigate
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Logging Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class PageTransitionSwitcher extends StatelessWidget {
  final Widget child;
  const PageTransitionSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
