import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';
import 'package:smart_complain_management_system/screens/settings_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, int> _stats = {"total": 0, "pending": 0, "solved": 0};

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  void _fetchStats() async {
    final user = MongoDatabase.currentUser;
    final stats = await MongoDatabase.getStats(user?['email'], role: user?['role'], dept: user?['department']);
    if (mounted) setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A1F36);
    const Color accentColor = Color(0xFF6366F1);
    final user = MongoDatabase.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [accentColor, Colors.blue])),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Text(user?['name']?[0] ?? "U", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: primaryColor)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: accentColor, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(user?['name'] ?? "User", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: primaryColor)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(user?['role'] ?? "Student", style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildQuickStatRow(accentColor),
                  const SizedBox(height: 30),
                  _buildProfileMenu(context, primaryColor, accentColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatRow(Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard("Active", _stats['pending'].toString(), Icons.bolt_rounded, Colors.orange),
        _buildStatCard("Resolved", _stats['solved'].toString(), Icons.verified_rounded, Colors.green),
        _buildStatCard("Archive", _stats['total'].toString(), Icons.inventory_2_rounded, Colors.blue),
      ],
    );
  }

  Widget _buildStatCard(String label, String val, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, Color primaryColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          _buildMenuTile(Icons.settings_suggest_rounded, "Global Settings", "Theme, Notifications, Language", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
          }),
          const Divider(indent: 60),
          _buildMenuTile(Icons.shield_rounded, "Privacy Center", "Data control and account safety", () {}),
          const Divider(indent: 60),
          _buildMenuTile(Icons.help_center_rounded, "Knowledge Base", "FAQs and system guides", () {}),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String sub, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFF1A1F36), size: 22)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }
}
