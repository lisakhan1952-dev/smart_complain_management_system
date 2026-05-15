import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

class SubmitComplaintPage extends StatefulWidget {
  const SubmitComplaintPage({super.key});

  @override
  State<SubmitComplaintPage> createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = "Academic Issues";
  String _selectedPriority = "Medium";
  bool _isSubmitting = false;

  // Expanded Categories based on Department/General Needs
  final List<Map<String, dynamic>> _categories = [
    {"icon": Icons.school_rounded, "name": "Academic Issues", "sub": "Results, registration, faculty, or schedule."},
    {"icon": Icons.biotech_rounded, "name": "Lab & Equipment", "sub": "Faulty hardware, software, or lab access."},
    {"icon": Icons.wifi_tethering_rounded, "name": "Network & Wi-Fi", "sub": "Connection speed, login issues, or coverage."},
    {"icon": Icons.apartment_rounded, "name": "Hostel & Living", "sub": "Cleaning, electricity, or water supply."},
    {"icon": Icons.restaurant_menu_rounded, "name": "Cafeteria & Food", "sub": "Food quality, pricing, or cleanliness."},
    {"icon": Icons.bus_alert_rounded, "name": "Transportation", "sub": "Bus delay, route issues, or driver behavior."},
    {"icon": Icons.library_books_rounded, "name": "Library Services", "sub": "Book availability, quiet zones, or fine issues."},
    {"icon": Icons.payments_rounded, "name": "Financial & Fees", "sub": "Payment portal, scholarship, or refund."},
    {"icon": Icons.sports_basketball_rounded, "name": "Sports & Clubs", "sub": "Facility booking, event requests, or equipment."},
    {"icon": Icons.security_rounded, "name": "Security & Safety", "sub": "Harassment, theft, or medical emergency."},
  ];

  void _submit() async {
    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please describe the issue in detail")));
      return;
    }

    setState(() => _isSubmitting = true);

    final user = MongoDatabase.currentUser;
    final complaint = {
      "userEmail": user?['email'],
      "userName": user?['name'],
      "department": user?['department'] ?? "General",
      "category": _selectedCategory,
      "description": _descController.text.trim(),
      "status": "Pending",
      "priority": _selectedPriority,
      "createdAt": DateTime.now().toIso8601String(),
    };

    bool success = await MongoDatabase.submitComplaint(complaint);
    setState(() => _isSubmitting = false);

    if (success) {
      _descController.clear();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 80),
                const SizedBox(height: 20),
                const Text("Submission Successful", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("Your complaint has been logged and assigned to your department.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                    child: const Text("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A1F36);
    const Color accentColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What's the issue?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: primaryColor)),
            const Text("Select a category that best describes your problem.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            // Grid Layout for Categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.1
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) => _buildCategoryCard(_categories[index], accentColor),
            ),

            const SizedBox(height: 35),
            const Text("Urgency Level", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["Low", "Medium", "High"].map((p) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPriority = p),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedPriority == p ? _getPriorityColor(p) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: _selectedPriority == p ? Colors.transparent : Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Text(p, style: TextStyle(color: _selectedPriority == p ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              )).toList(),
            ),

            const SizedBox(height: 35),
            const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tell us more about what's happening...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade100)),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: _isSubmitting 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Launch Complaint", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat, Color accentColor) {
    bool isSelected = _selectedCategory == cat['name'];
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat['name']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? accentColor : Colors.grey.shade100, width: 2),
          boxShadow: [if(isSelected) BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat['icon'], color: isSelected ? Colors.white : accentColor, size: 32),
            const SizedBox(height: 12),
            Text(cat['name'], style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF1E293B), fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 4),
            Text(cat['sub'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String p) {
    if (p == "High") return const Color(0xFFEF4444);
    if (p == "Medium") return const Color(0xFFF59E0B);
    return const Color(0xFF3B82F6);
  }
}
