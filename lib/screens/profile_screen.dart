import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Profile Image
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.person, size: 60, color: primaryColor),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Ahmed Abdullah",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const Text(
                    "CSE Student | ID: 2102001",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatItem("Total", "12", Icons.folder_open, Colors.blue),
                  _buildStatItem("Solved", "08", Icons.check_circle_outline, Colors.green),
                  _buildStatItem("Pending", "04", Icons.access_time, Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // User Info & Settings List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Account Overview",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 15),

                  _buildMenuCard([
                    _buildMenuItem(Icons.person_outline, "Personal Info", "Name, ID, Department", primaryColor),
                    _buildMenuItem(Icons.email_outlined, "Contact Details", "abc@baust.edu.bd", primaryColor),
                    _buildMenuItem(Icons.notifications_none, "Notification Settings", "Manage alerts", primaryColor),
                  ]),

                  const SizedBox(height: 20),
                  const Text("Support & More",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 15),

                  _buildMenuCard([
                    _buildMenuItem(Icons.security, "Privacy & Policy", "Our commitment to security", primaryColor),
                    _buildMenuItem(Icons.help_outline, "Help & Support", "Get technical assistance", primaryColor),
                    _buildMenuItem(Icons.info_outline, "About BAUST CMS", "Version 1.0.2", primaryColor),
                  ]),

                  const SizedBox(height: 20),

                  // Logout Button
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Center(
                        child: Text("Logout Account",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Statistics কার্ড হেল্পার
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // মেনু কার্ড কন্টেইনার
  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  // মেনু আইটেম হেল্পার
  Widget _buildMenuItem(IconData icon, String title, String subtitle, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.08), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }
}