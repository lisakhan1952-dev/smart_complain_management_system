import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Complaints", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTrackTile("Dorm AC Maintenance", "#CMS-90421", "In Progress", Colors.teal),
          _buildTrackTile("Wifi Connectivity Issues", "#CMS-87002", "Resolved", Colors.grey),
          _buildTrackTile("Grade Revision Request", "#CMS-88120", "Pending", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildTrackTile(String title, String id, String status, Color color) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(id),
        trailing: Chip(label: Text(status, style: const TextStyle(color: Colors.white)), backgroundColor: color),
      ),
    );
  }
}