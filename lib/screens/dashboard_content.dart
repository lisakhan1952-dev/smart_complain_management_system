import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);
    const Color accentColor = Color(0xFF3B82F6);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ১. প্রিমিয়াম ইউজার প্রোফাইল সেকশন ---
          _buildUserInfoSection(primaryColor),

          const SizedBox(height: 20),

          // --- ২. ডাইনামিক নোটিশ স্লাইডার (New Feature) ---
          _buildNoticeSlider(accentColor),

          const SizedBox(height: 25),

          // --- ৩. মেইন স্ট্যাটাস গ্রিড (Total, Pending, Resolved) ---
          _buildMainStatsGrid(primaryColor),

          const SizedBox(height: 25),

          // --- ৪. স্মার্ট অ্যাকশন মেনু (Grid) ---
          const Text("University Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 15),
          _buildActionGrid(),

          const SizedBox(height: 30),

          // --- ৫. ডিপার্টমেন্টাল কমপ্লেন শর্টকাট (Category Feature) ---
          const Text("Departmental Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 12),
          _buildCategoryList(),

          const SizedBox(height: 30),

          // --- ৬. রিসেন্ট অ্যাক্টিভিটি টাইমলাইন ---
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ongoing Tracking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
              Text("See All", style: TextStyle(color: accentColor, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 15),
          _buildActivityItem("Hostel Wi-Fi Down", "Ref: #BAUST-901", "In Progress", Colors.teal, Icons.wifi_off_rounded),
          _buildActivityItem("Lab Equipment Issue", "Ref: #BAUST-882", "Pending", Colors.orange, Icons.biotech_rounded),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- হেল্পার উইজেটস ---

  Widget _buildUserInfoSection(Color primaryColor) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor.withOpacity(0.2), width: 2),
          ),
          child: const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFF1F5F9),
            child: Icon(Icons.person_outline_rounded, color: Color(0xFF0D1C43), size: 30),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good Morning,", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text("Ahmed Abdullah",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.grey),
        )
      ],
    );
  }

  Widget _buildNoticeSlider(Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign_rounded, color: Color(0xFF3B82F6), size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("BAUST Official Notice",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                Text("New feedback system is live for CSE department.",
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey[700])),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMainStatsGrid(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatsColumn("12", "Total"),
          _buildVerticalDivider(),
          _buildStatsColumn("04", "Active"),
          _buildVerticalDivider(),
          _buildStatsColumn("08", "Closed"),
        ],
      ),
    );
  }

  Widget _buildStatsColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.white24);
  }

  Widget _buildActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 15,
      children: [
        _buildIconAction(Icons.add_task_rounded, "New", Colors.blue),
        _buildIconAction(Icons.history_edu_rounded, "Logs", Colors.orange),
        _buildIconAction(Icons.contact_support_rounded, "Support", Colors.teal),
        _buildIconAction(Icons.gavel_rounded, "Policy", Colors.indigo),
        _buildIconAction(Icons.apartment_rounded, "Hostel", Colors.purple),
        _buildIconAction(Icons.library_books_rounded, "Library", Colors.brown),
        _buildIconAction(Icons.bus_alert_rounded, "Transport", Colors.redAccent),
        _buildIconAction(Icons.grid_view_rounded, "More", Colors.blueGrey),
      ],
    );
  }

  Widget _buildIconAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildCategoryList() {
    List<String> cats = ["CSE", "EEE", "ME", "CE", "IPE", "BBA"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: index == 0 ? const Color(0xFF0D1C43) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(cats[index],
                  style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityItem(String title, String ref, String status, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(ref, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}