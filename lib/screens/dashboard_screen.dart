import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/dashboard_content.dart';
import 'package:smart_complain_management_system/screens/submit_complaint_screen.dart';
import 'package:smart_complain_management_system/screens/login_screen.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';
import 'package:smart_complain_management_system/screens/admin_panel.dart';
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
    const Color primaryColor = Color(0xFF1A1F36);
    final String userName = MongoDatabase.currentUser?['name'] ?? "User";
    final String userRole = MongoDatabase.currentUser?['role'] ?? "Student";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          _currentIndex == 0 ? "BAUST CMS" :
          _currentIndex == 1 ? "New Entry" :
          _currentIndex == 2 ? "Live Monitor" : "User Profile",
          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, color: primaryColor),
          ),
          Builder(builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(Icons.menu_rounded, color: primaryColor),
          )),
        ],
      ),
      endDrawer: _buildPremiumDrawer(primaryColor, userName, userRole),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), label: 'Post'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Track'),
            BottomNavigationBarItem(icon: Icon(Icons.person_2_rounded), label: 'User'),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumDrawer(Color primaryColor, String name, String role) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            color: primaryColor,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: Text(name[0], style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(role, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildDrawerItem(Icons.dashboard_outlined, "Overview", () => Navigator.pop(context)),
          if (MongoDatabase.currentUser?['role'] == 'Admin')
            _buildDrawerItem(Icons.admin_panel_settings_outlined, "Admin Space", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanel()));
            }, color: Colors.indigo),
          _buildDrawerItem(Icons.history_rounded, "Archives", () {
            Navigator.pop(context);
            setState(() => _currentIndex = 2);
          }),
          const Spacer(),
          const Divider(),
          _buildDrawerItem(Icons.logout_rounded, "Terminate Session", _handleLogout, color: Colors.redAccent),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF1A1F36)),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? const Color(0xFF1A1F36))),
      onTap: onTap,
    );
  }

  void _handleLogout() {
    MongoDatabase.logout();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
  }
}
