import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/dashboard_content.dart';
import 'package:smart_complain_management_system/screens/submit_complaint_screen.dart';
import 'tracking_screen.dart';
import 'profile_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  // পেজ লিস্ট (IndexedStack এর জন্য)
  final List<Widget> _pages = [
    const DashboardContent(),
    const SubmitComplaintPage(),
    const TrackingPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);
    const Color accentColor = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // হালকা এবং পরিষ্কার ব্যাকগ্রাউন্ড

      // --- ১. প্রিমিয়াম কাস্টম ড্রয়ার ---
      drawer: _buildAwesomeDrawer(primaryColor),

      // --- ২. ডায়নামিক অ্যাপবার ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _currentIndex == 0 ? "BAUST CMS" :
            _currentIndex == 1 ? "File Complaint" :
            _currentIndex == 2 ? "Live Tracking" : "My Account",
            key: ValueKey<int>(_currentIndex),
            style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, letterSpacing: 0.8),
          ),
        ),
        actions: [
          // নোটিফিকেশন ব্যাজ সহ আইকন
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_active_outlined, size: 26),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                  child: const Text("3", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          const SizedBox(width: 5),
        ],
      ),

      // --- ৩. মেইন কন্টেন্ট উইথ অ্যানিমেশন ---
      body: PageTransitionSwitcher(
        child: _pages[_currentIndex],
      ),

      // --- ৪. কুইক অ্যাকশন ফ্লোটিং বাটন ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () => setState(() => _currentIndex = 1),
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(Icons.add_moderator_rounded, color: Colors.white, size: 30),
      ) : null,

      // --- ৫. প্রিমিয়াম বটম নেভিগেশন ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined), activeIcon: Icon(Icons.dashboard_customize), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.post_add_rounded), activeIcon: Icon(Icons.post_add), label: 'Submit'),
            BottomNavigationBarItem(icon: Icon(Icons.gps_fixed_rounded), activeIcon: Icon(Icons.gps_fixed), label: 'Track'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), activeIcon: Icon(Icons.account_circle), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // --- ড্রয়ার ডিজাইন ফাংশন ---
  Widget _buildAwesomeDrawer(Color primaryColor) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColor, primaryColor.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            accountName: const Text("Ahmed Abdullah", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: const Text("abdullah.cse@baust.edu.bd", style: TextStyle(color: Colors.white70)),
            currentAccountPicture: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const CircleAvatar(backgroundColor: Color(0xFFF1F5F9), child: Icon(Icons.person_pin, size: 50, color: Color(0xFF0D1C43))),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _drawerTile(Icons.dashboard_outlined, "Smart Dashboard", 0),
                  _drawerTile(Icons.history_toggle_off_rounded, "My Case History", -1),
                  _drawerTile(Icons.verified_user_outlined, "Departmental Policy", -1),
                  const Divider(indent: 20, endIndent: 20),
                  _drawerTile(Icons.contact_support_outlined, "Help & Support", -1),
                  _drawerTile(Icons.settings_outlined, "App Settings", -1),
                  const SizedBox(height: 30),
                  _drawerTile(Icons.power_settings_new_rounded, "Sign Out", -2, color: Colors.redAccent),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text("BAUST CMS v2.0.4 • Made with ❤️", style: TextStyle(color: Colors.grey, fontSize: 11)),
          )
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, int index, {Color color = const Color(0xFF0D1C43)}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 15)),
      onTap: () {
        Navigator.pop(context);
        if (index >= 0) setState(() => _currentIndex = index);
      },
    );
  }
}

// --- পেজ ট্রানজিশন উইজেট ---
class PageTransitionSwitcher extends StatelessWidget {
  final Widget child;
  const PageTransitionSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}