import 'package:flutter/material.dart';


import 'submit_complaint_screen.dart';
import 'tracking_screen.dart';
import 'profile_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  // এখানে আমরা আপনার আলাদা করা ফাইলগুলোর ক্লাস নাম ব্যবহার করছি
  final List<Widget> _pages = [
    const DashboardContent(),
    const SubmitComplaintPage(),
    const TrackingPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: primaryColor),
        title: Text(
          _currentIndex == 0 ? "BAUST CMS" :
          _currentIndex == 1 ? "Submit Complaint" :
          _currentIndex == 2 ? "Tracking" : "Profile",
          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),

      // IndexedStack ব্যবহারের ফলে এক পেজ থেকে অন্য পেজে গেলে ডাটা রিলোড হবে না
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 1;
          });
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Submit'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Tracking'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// --- ড্যাশবোর্ড কন্টেন্ট সেকশন ---
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome back,", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const Text("Ahmed Abdullah", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 25),

          _buildActiveCaseCard(primaryColor),
          const SizedBox(height: 20),

          Row(
            children: [
              _buildStatCard("Pending", "04", Icons.more_horiz, Colors.orange),
              const SizedBox(width: 15),
              _buildStatCard("Resolved", "08", Icons.check_circle, Colors.green),
            ],
          ),
          const SizedBox(height: 30),

          const Text("Recent Complaints", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 15),

          _buildComplaintItem("Dorm AC Maintenance", "Ref: #CMS-90421", "In Progress", Colors.greenAccent, Icons.build),
          _buildComplaintItem("Grade Revision Request", "Ref: #CMS-88120", "Pending", Colors.orangeAccent, Icons.school),
        ],
      ),
    );
  }

  // হেল্পার উইজেটগুলো আগের মতোই থাকছে
  Widget _buildActiveCaseCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("TOTAL ACTIVE", style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text("12 Cases", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          ]),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildComplaintItem(String title, String ref, String status, Color statusColor, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon, size: 20, color: const Color(0xFF0D1C43))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(ref),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}