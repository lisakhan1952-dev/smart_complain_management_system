import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController(text: MongoDatabase.currentUser?['name']);
  final TextEditingController _passController = TextEditingController(text: MongoDatabase.currentUser?['password']);
  bool _isDark = false;
  bool _notifications = true;

  void _saveProfile() async {
    final user = MongoDatabase.currentUser;
    if (user == null) return;
    
    await MongoDatabase.updateProfile(user['_id'], _nameController.text.trim(), _passController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Synced with Cloud Database")));
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A1F36);
    const Color accentColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Preferences & Core", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Identity Management"),
            _buildSettingsCard([
              _buildTextSetting("Full Name", _nameController, Icons.person_outline_rounded),
              _buildTextSetting("Secure Key", _passController, Icons.key_outlined, isPass: true),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Update Identity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ]),
            const SizedBox(height: 30),
            _buildSectionHeader("System Configuration"),
            _buildSettingsCard([
              _buildSwitchSetting("Immersive Dark Mode", "Enable eye-care interface", _isDark, (v) => setState(() => _isDark = v), Icons.dark_mode_outlined),
              _buildSwitchSetting("Push Notifications", "Real-time status alerts", _notifications, (v) => setState(() => _notifications = v), Icons.notifications_active_outlined),
            ]),
            const SizedBox(height: 30),
            _buildSectionHeader("Legal & Information"),
            _buildSettingsCard([
              _buildLinkSetting("Privacy Protocol", Icons.security_rounded),
              _buildLinkSetting("Terms of Service", Icons.gavel_rounded),
              _buildLinkSetting("About BAUST CMS v2.0", Icons.info_outline_rounded),
            ]),
            const SizedBox(height: 40),
            Center(child: Text("Build ID: CMS-2024-PRO", style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.blueAccent, letterSpacing: 1)),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)]),
      child: Column(children: children),
    );
  }

  Widget _buildTextSetting(String label, TextEditingController controller, IconData icon, {bool isPass = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(String title, String sub, bool val, Function(bool) onChanged, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6366F1)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 11)),
      trailing: Switch.adaptive(value: val, activeColor: const Color(0xFF6366F1), onChanged: onChanged),
    );
  }

  Widget _buildLinkSetting(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: () {},
    );
  }
}
