import 'package:flutter/material.dart';

class SubmitComplaintPage extends StatelessWidget {
  const SubmitComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);

    return Scaffold(
      appBar: AppBar(title: const Text("Submit Complaint", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            // Category Cards
            _buildCategoryItem(Icons.library_books, "Library", "Seating, resources, or disturbances.", primaryColor),
            _buildCategoryItem(Icons.restaurant, "Cafeteria", "Food quality, hygiene, or pricing.", primaryColor),
            _buildCategoryItem(Icons.bus_alert, "Transport", "Bus schedules, driver behavior.", primaryColor),
            const SizedBox(height: 25),
            const Text("Complaint Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Describe the issue in detail...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Submit Complaint", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, String subtitle, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}