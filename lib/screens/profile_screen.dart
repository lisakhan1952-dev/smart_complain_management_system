import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Center(child: CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50))),
          const SizedBox(height: 15),
          const Text("Ahmed Abdullah", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("ID: 2102001", style: TextStyle(color: Colors.grey)),
          const Divider(height: 40),
          ListTile(leading: const Icon(Icons.settings), title: const Text("Settings"), onTap: () {}),
          ListTile(leading: const Icon(Icons.help), title: const Text("Help Support"), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Logout"), onTap: () {}),
        ],
      ),
    );
  }
}